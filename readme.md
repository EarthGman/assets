# Wallpapers, Icons, and binaries

used in conjunction with a nix config.

Add raw JSON url to your nix config as a flake input. 
Ex.
```nix
inputs.wallpapers = {
  url = "https://raw.githubusercontent.com/EarthGman/personal-cache/master/wallpapers.json";
  flake = false;
};

inputs.icons = {
  url = "https://raw.githubusercontent.com/EarthGman/personal-cache/master/icons.json";
  flake = false;
};
```
## Contributing:
1. clone repository
2. run "nix develop" if direnv is not installed
3. add new files
4. commit changes then push
5. if commiting new icons or wallpapers run "generate" then commit and push once it completes 
6. update your flake.nix in your local nix-config `nix flake update`

