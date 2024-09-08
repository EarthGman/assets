{
  description = "dependencies";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.jq
          (pkgs.writeScriptBin "generate" ''
            #!${pkgs.runtimeShell}
            # Call the script located in the current directory
            ${./createJSON.sh} wallpapers
            ${./createJSON.sh} icons
          '')
        ];
      };
    };
}
