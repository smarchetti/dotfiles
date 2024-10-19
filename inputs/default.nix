{
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
}
