{
  description = "dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-library.url = "github:EarthGman/nix-library";
  };

  outputs = { nixpkgs, nix-library, ... }:
    let
      inherit (nix-library) lib;
      inherit (lib) forAllSystems;
    in
    {
      devShells = forAllSystems
        (system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          {
            default = pkgs.mkShell {
              packages = [
                pkgs.jq
                (pkgs.writeScriptBin "generate" ''
                  #!${pkgs.runtimeShell}
                  # Call the script located in the current directory
                  ${./createJSON.sh} wallpapers
                  ${./createJSON.sh} icons
                  ${./createJSON.sh} binaries
                '')
              ];
            };
          });
    };
}
