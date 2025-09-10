{
  inputs,
  outputs,
}: let
  tmc_autotune = builtins.fetchGit { url = "https://github.com/andrewmcgr/klipper_tmc_autotune.git"; rev = "03b49374d71fde201718f033843d687de8fe9de8"; }; 
  # cartographer_klipper  = builtins.fetchGit { url = "https://github.com/Cartographer3D/cartographer-klipper.git"; rev = "7e354f3baa4bcce53251e90c2154727db37c3c5f"; }; 
  #  cartographer3d_plugin  = builtins.fetchGit { url = "https://github.com/Cartographer3D/cartographer3d-plugin.git"; rev = "ee69b82ac4502cbe9eb8bd0c2a1e5036d0e0c095"; }; 
in {
  # From https://github.com/Misterio77/nix-config/blob/eb20842094f8963d9231ed8bf5e682ee83619f92/overlays/default.nix#L13
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
          packages = (flake.packages or {}).${final.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };

  # Adds pkgs.stable as an option
  stable = final: _: {
    stable = inputs.nixpkgs-stable.legacyPackages.${final.system};
  };

  # Adds additional custom packages
  additions = final: prev:
    import ../pkgs {pkgs = final;}
    // {
      vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins {};
    };

  # Modifies existing packages
  modifications = final: prev: {
    keepassxc = prev.keepassxc.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "keepassxreboot";
        repo = "keepassxc";
        rev = "f4b91c17a9bcaf465382ee8f10e08005dd97cbf9";
        hash = "sha256-qexPsZwcTnHB6nminAc6P5xqde7yBi+DglzuwEZjzYM=";
      };
      buildInputs = oldAttrs.buildInputs ++ [final.keyutils];
    });

    orca-slicer = prev.orca-slicer.overrideAttrs(oldAttrs: {
      version = "v2.3.1-alpha";
      src = prev.fetchFromGitHub {
        owner = "SoftFever";
        repo = "OrcaSlicer";
        rev = "v2.3.1-alpha";
        hash = "sha256-hdo6lzICyIottf9057HQ3KIdZ0GZEIWV4SOjvwe6W1k=";
      };

      patches = [
        (prev.fetchpatch {
          name = "pr-7650-configurable-update-check.patch";
          url = "https://github.com/SoftFever/OrcaSlicer/commit/d10a06ae11089cd1f63705e87f558e9392f7a167.patch";
          hash = "sha256-t4own5AwPsLYBsGA15id5IH1ngM0NSuWdFsrxMRXmTk=";
        })

        (prev.fetchpatch {
          name = "0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch";
          url = "https://github.com/NixOS/nixpkgs/raw/refs/heads/nixos-unstable/pkgs/by-name/or/orca-slicer/patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch";
          hash = "sha256-ZKAsovfU5e/Uh1yaYeiKmWDaq61ja3XbkzmTeOnVJPY=";
        })

        (prev.fetchpatch {
          name = "dont-link-opencv-world-orca.patch";
          url = "https://github.com/NixOS/nixpkgs/raw/refs/heads/nixos-unstable/pkgs/by-name/or/orca-slicer/patches/dont-link-opencv-world-orca.patch";
          hash = "sha256-4SkzI2SGfunxt8+dLiAumKjjAjmpR1QU0YEvJhe82rQ=";
        })
      ];

      prePatch = ''
        sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
        sed -i 's|"libnoise/noise.h"|"noise/noise.h"|' src/libslic3r/PerimeterGenerator.cpp
        sed -i 's|"libnoise/noise.h"|"noise/noise.h"|' src/libslic3r/Feature/FuzzySkin/FuzzySkin.cpp
      '';
    });

    mpv-unwrapped = prev.mpv-unwrapped.override {
      libplacebo = final.libplacebo-mpv;
    };

    libplacebo-mpv = let
      version = "7.349.0";
    in
      prev.libplacebo.overrideAttrs (old: {
        inherit version;
        src = prev.fetchFromGitLab {
          domain = "code.videolan.org";
          owner = "videolan";
          repo = "libplacebo";
          rev = "v${version}";
          hash = "sha256-mIjQvc7SRjE1Orb2BkHK+K1TcRQvzj2oUOCUT4DzIuA=";
        };
      });

    klipper = (prev.klipper.override {
      extraPythonPackages = ps: [ final.pkgs.cartographer3d-plugin ];
    }).overrideAttrs (oldAttrs: {
        installPhase = /* sh */ ''
        runHook preInstall
        mkdir -p $out/lib/klipper
        cp -r ./* $out/lib/klipper

        # Copy custom extras
        mkdir -p $out/lib/klippy/extras
        mkdir -p $out/lib/klipper/extras

        # TMC Autotune
        cp ${tmc_autotune.outPath}/*.{py,cfg} $out/lib/klipper/extras
        # Cartograther3d-plugin
        echo "from cartographer.extra import *" > $out/lib/klipper/extras/cartographer.py

        # Moonraker expects `config_examples` and `docs` to be available
        # under `klipper_path`
        cp -r $src/docs $out/lib/docs
        cp -r $src/config $out/lib/config
        cp -r $src/scripts $out/lib/scripts
        cp -r $src/klippy/* $out/lib/klippy/

        # Add version information. For the normal procedure see https://www.klipper3d.org/Packaging.html#versioning
        # This is done like this because scripts/make_version.py is not available when sourceRoot is set to "${oldAttrs.src.name}/klippy"
        echo "${oldAttrs.version}-NixOS" > $out/lib/klipper/.version

        mkdir -p $out/bin
        chmod 755 $out/lib/klipper/klippy.py
        makeWrapper $out/lib/klipper/klippy.py $out/bin/klippy --chdir $out/lib/klipper

        substitute "$pythonScriptWrapper" "$out/bin/klipper-calibrate-shaper" \
        --subst-var "out" \
        --subst-var-by "script" "calibrate_shaper.py"
        chmod 755 "$out/bin/klipper-calibrate-shaper"

        runHook postInstall
        '';
      });
  };
}
