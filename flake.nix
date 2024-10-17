{
  description = "Example Darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs =
    inputs@{ self
    , nix-darwin
    , nixpkgs
    , home-manager
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [
            pkgs.git
            pkgs.zsh
            pkgs.eza
            pkgs.nixpkgs-fmt
            pkgs.arc-browser
            pkgs.slack
            pkgs.vscode
            pkgs.raycast
            pkgs.iterm2
            pkgs.gh
          ];
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.hostPlatform = "aarch64-darwin";
          services = {
            nix-daemon = {
              enable = true;
            };
          };
          system = {
            stateVersion = 5;
            configurationRevision = self.rev or self.dirtyRev or null;
            defaults = {
              dock = {
                autohide = true;
                orientation = "right";
                launchanim = false;
                persistent-apps = [ ];
                persistent-others = [ ];
                autohide-time-modifier = 0.0;
                show-recents = false;
                tilesize = 16;
              };
              finder = {
                ShowPathbar = true;
                ShowStatusBar = true;
                AppleShowAllFiles = true;
                AppleShowAllExtensions = true;
                FXPreferredViewStyle = "Nlsv";
                FXDefaultSearchScope = "SCcf";
                _FXShowPosixPathInTitle = true;
              };
              NSGlobalDomain = {
                NSTableViewDefaultSizeMode = 1;
                NSNavPanelExpandedStateForSaveMode = true;
                NSNavPanelExpandedStateForSaveMode2 = true;
                PMPrintingExpandedStateForPrint = true;
                PMPrintingExpandedStateForPrint2 = true;
              };
              CustomUserPreferences = {
                "com.apple.symbolichotkeys" = {
                  AppleSymbolicHotKeys = {
                    "64" = {
                      enabled = false;
                    };
                  };
                };
              };

            };
          };
          users.users.sean = {
            name = "sean";
            home = "/Users/sean";
          };
        };
      homeconfig = { pkgs, ... }: {
        home =
          {
            stateVersion = "24.05";
            packages = with pkgs; [ ];
            sessionVariables = {
              EDITOR = "code";
            };
          };
        programs = {
          home-manager = {
            enable = true;
          };
          gh = {
            enable = true;
          };
          zsh = {
            enable = true;
            shellAliases = {
              s = "darwin-rebuild switch --flake ~/.config/nix-darwin && exec zsh";
              c = "clear";
              rz = "exec zsh";
            };
          };
          starship = {
            enable = true;
          };
          eza = {
            enable = true;
          };
          git = {
            enable = true;
            userName = "Sean Marchetti";
            userEmail = "sean.marchetti@gmail.com";
            ignores = [ ".DS_Store" ];
            extraConfig = {
              init.defaultBranch = "main";
              push.autoSetupRemote = true;
            };
          };
        };
      };
    in
    {
      darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.sean = homeconfig;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."mbp".pkgs;
    };
}
