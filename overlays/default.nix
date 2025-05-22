{
  inputs,
  outputs,
}: let
 tmc_autotune = builtins.fetchGit { url = "https://github.com/andrewmcgr/klipper_tmc_autotune.git"; rev = "03b49374d71fde201718f033843d687de8fe9de8"; }; 
 cartographer_klipper  = builtins.fetchGit { url = "https://github.com/Cartographer3D/cartographer-klipper.git"; rev = "7e354f3baa4bcce53251e90c2154727db37c3c5f"; }; 
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

    klipper = prev.klipper.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [(prev.python3.withPackages (
        p: with p; [
          scipy
          matplotlib
        ]
      ))];

      installPhase = ''
        runHook preInstall
    mkdir -p $out/lib/klipper
    cp -r ./* $out/lib/klipper

    # Moonraker expects `config_examples` and `docs` to be available
    # under `klipper_path`
    cp -r $src/docs $out/lib/docs
    cp -r $src/config $out/lib/config
    cp -r $src/scripts $out/lib/scripts

    mkdir -p $out/lib/klippy/extras
    mkdir -p $out/lib/klippy/plugins
    # Copy custom extras
    cp ${tmc_autotune.outPath}/*.{py,cfg} $out/lib/klipper/extras
    cp ${cartographer_klipper.outPath}/{idm.py,cartographer.py,scanner.py} $out/lib/klipper/extras
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
