{
  description = "Example Darwin system flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
    };
  };
  outputs = { self, nix-darwin, nixpkgs, home-manager }:
    let

      configuration =
        { pkgs, config, ... }:
        let
          tana = pkgs.callPackage ./packages/tana.nix { };
        in
        {
          programs.zsh.enable = true;
          nix.settings.experimental-features = "nix-command flakes";

          nixpkgs.config.allowUnfree = true;
          nixpkgs.hostPlatform = "aarch64-darwin";

          environment.systemPackages = [
            pkgs.arc-browser
            pkgs.colima
            pkgs.docker
            pkgs.docker-compose
            pkgs.eza
            pkgs.gh
            pkgs.git
            pkgs.iterm2
            pkgs.nixpkgs-fmt
            pkgs.nodejs_22
            pkgs.tableplus
            pkgs.pnpm
            pkgs.python3
            pkgs.raycast
            pkgs.slack
            pkgs.spotify
            pkgs.zoom-us
            pkgs.zsh
            tana
          ];

          nixpkgs.config.packageOverrides = super: {
            tableplus = pkgs.callPackage ./packages/tableplus.nix { };
          };


          fonts.packages = [
            pkgs.nerdfonts
          ];

          launchd = {
            user = {
              agents = {
                colima = {
                  script = "${pkgs.colima}/bin/colima start --foreground";
                  path = [
                    config.environment.systemPath
                  ];
                  serviceConfig = {
                    StandardOutPath = "/tmp/colima.out.log";
                    StandardErrorPath = "/tmp/colima.err.log";
                    KeepAlive = true;
                    RunAtLoad = true;
                  };
                };
              };
            };
          };

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
                      enabled = 0;
                      value = {
                        parameters = [ 32 49 1048576 ];
                        type = "standard";
                      };
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
            home-manager.users.sean = import ./home;
          }
        ];
      };
    };
}
