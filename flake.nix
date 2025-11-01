{
  description = "Personal NixOS config";

  nixConfig = {
    extra-substituters = ["https://hyprland.cachix.org" "https://nix-community.cachix.org" "https://eden-flake.cachix.org"];
    extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "eden-flake.cachix.org-1:9orwA5vFfBgb67pnnpsxBqILQlb2UI2grWt4zHHAxs8="];
  };

  inputs = {
    # Nix Ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default-linux";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tools
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.stable.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Services
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # TODO: Add to dev shells only
    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig-overlay.follows = "zig";
    };

    # Programs
    eden.url = "github:Grantimatter/eden-flake";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    plasma-manager,
    nur,
    systems,
    hyprland,
    colmena,
    nixos-wsl,
    nix-index-database,
    ...
    } @ inputs: let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      pkgsForStable = lib.genAttrs (import systems) (
        system:
        import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays {inherit inputs outputs;};

      packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
      devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      ## NixOS Configurations
      # Set for every interactable system
      nixosConfigurations = {
        # Framework Laptop
        framework = lib.nixosSystem {
          modules = [
            nur.modules.nixos.default
            ./hosts/framework
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };

        # NixOS Desktop
        desktop = lib.nixosSystem {
          modules = [
            nur.modules.nixos.default
            ./hosts/desktop
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };

        # WSL Environment
        wsl = lib.nixosSystem {
          modules = [
            nixos-wsl.nixosModules.default
            nur.modules.nixos.default
            ./hosts/wsl
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      ## Home-Manager Configurations
      # Set only for systems that are interacted with manually
      homeConfigurations = {
        "thestachelfisch@framework" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            nur.modules.homeManager.default
            plasma-manager.homeManagerModules.plasma-manager
            ./hosts/framework/home.nix
          ];
        };

        "thestachelfisch@desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            nur.modules.homeManager.default
            plasma-manager.homeManagerModules.plasma-manager
            ./hosts/desktop/home.nix
          ];
        };

        "thestachelfisch@wsl" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            ./hosts/wsl/home.nix
          ];
        };
      };

      ## Remote Servers
      # Set only for systems that are remotely-deployed to
      colmenaHive = colmena.lib.makeHive self.outputs.colmena;

      colmena = {
        meta = {
          description = "Remote Machines Managed exclusively remotely";
          nixpkgs = pkgsForStable.x86_64-linux;
          nodeNixpkgs = {
            malachite = pkgsForStable.aarch64-linux;
            gen-fra1-arm-srv-oci-03 = pkgsForStable.aarch64-linux;
            printy = pkgsFor.aarch64-linux;
          };

          specialArgs = {
            inherit inputs outputs;
          };
        };

        malachite = {
          deployment = {
            targetHost = "malachite.thestachelfisch.dev";
            targetUser = "thestachelfisch";
            buildOnTarget = true;

            tags = ["arm" "oci" "server"];
          };

          imports = [
            ./hosts/server/malachite
          ];
        };

        gen-fra1-arm-srv-oci-03 = {
          deployment = {
            targetHost = "gen-fra1-arm-srv-oci-03.thestachelfisch.dev";
            targetUser = "thestachelfisch";
            buildOnTarget = true;

            tags = ["arm" "oci" "server"];
          };

          imports = [
            ./hosts/server/gen-fra1-arm-srv-oci-03
          ];
        };

      # Voron 2.4 3d-printer
      printy = {
        deployment = {
          targetHost = "printy.thestachelfisch.dev";
          targetUser = "thestachelfisch";
          targetPort = 23;
          buildOnTarget = true;

          tags = ["arm" "device"];
        };

        imports = [
          ./hosts/printy
        ];
      };
    };
  };
}
