{ pkgs, ... }: {
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
        s = "darwin-rebuild switch --flake ~/.dotfiles#mbp && exec zsh";
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
}
