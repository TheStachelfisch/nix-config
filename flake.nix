{
  description = "Personal NixOS config";

  nixConfig = {
    extra-substituters = ["https://hyprland.cachix.org" "https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
    # Nix Ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default-linux";
    nur.url = "github:nix-community/NUR";

    # Services
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    home-manager = {
      url = "github:thestachelfisch/home-manager/fix/psd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # TODO: Add to dev shells only
    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zls = {
      url = "github:zigtools/zls/0.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig-overlay.follows = "zig";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    hyprland,
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
  in {
    inherit lib;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    overlays = import ./overlays {inherit inputs outputs;};

    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    ## NixOS Configurations
    # Set for every system
    nixosConfigurations = {
      #Framework Laptop
      framework = lib.nixosSystem {
        modules = [
          inputs.nur.nixosModules.nur
          ./hosts/framework
        ];
        specialArgs = {
          inherit inputs outputs;
        };
      };

      # WSL Environment
      wsl = lib.nixosSystem {
        modules = [
          inputs.nixos-wsl.nixosModules.default
          inputs.nur.nixosModules.nur
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
          inputs.nur.nixosModules.nur
          ./hosts/framework/home.nix
        ];
      };

      "thestachelfisch@wsl" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [ ./hosts/wsl/home.nix ];
      };
    };

    ## Remote Servers
    # Set only for systems that are remotely-deployed to
    colmena = {
      meta = {
        description = "Remote Machines Managed exclusively remotely";
        nixpkgs = pkgsFor.x86_64-linux;

        specialArgs = {
            inherit inputs outputs;
        };
      };

      malachite = { 
        deployment = {
          targetHost = "malachite.thestachelfisch.dev";
          targetUser = "thestachelfisch";
          buildOnTarget = true;

          tags = [ "arm" "oci" ];
        };

        imports = [
          ./hosts/malachite
        ];
      };
    };
  };
}
