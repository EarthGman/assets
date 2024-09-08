{
  description = "Gman's personal-cache";

  inputs.nix-config.url = "github:/EarthGman/nix-config/v4-wip";
  outputs = { nix-config, ... }:
    let
      mapfiles = nix-config.myLib.mapfiles;
    in
    {
      wallpapers = mapfiles ./wallpapers;
      icons = mapfiles ./icons;
    };
}
