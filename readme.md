# Repository with various assets for my NixOS configuration

But its not just personal, you can use it too!

A few categories of items are represented in JSON format in the root of the repository. You can add each of these individually to your flake.nix as shown in this example:

```nix
inputs.wallpapers = {
  url = "https://raw.githubusercontent.com/EarthGman/assets/master/wallpapers.json";
  flake = false;
};

inputs.icons = {
  url = "https://raw.githubusercontent.com/EarthGman/assets/master/icons.json";
  flake = false;
};
```

These JSON files contain the URL and SHA256 hash for each asset of that category. These can be easily passed to the nix function: builtins.fetchurl.

you can transform the JSON format into a format that builtins.fetchurl can understand by adding the following lines to configuration.nix.
```nix
{ inputs, ... }:
let
  wallpapers = builtins.fromJSON (builtins.readFile inputs.wallpapers.outPath);
in
*the rest of your module*
```

Now, you can consume the asset using a nix option like so.

```
stylix.image = builtins.fetchurl wallpapers.my-awesome-wallpaper;
```

Notes:
- the dot extension is removed from the name, that's right! The JSON key removes the dot extension for you.

- It is still important to be aware of what format the image is in, as certain programs will only accept a certain format. (Grub only accepts PNG for backgrounds)


# Fonts

Fonts stored in here cannot be accessed directly using this method, as they are stored in raw ttf format and are not packaged.

You can either package the font yourself or use my personal nixpkgs repository where each of these fonts are already packaged. https://github.com/EarthGman/nix-library


#  addition/modification guide (if you have permission)

```
 # clone repo
 cd ~/src/assets (or wherever it is located)
 # add any assets you want using whatever method you like
 git add . 
 git commit -m "added new awesome assets"
 git push
 generate (OR ./createJSON.sh *category)
 # ^ Only run this command while your are in the root of the repo.
 
 git add .
 git commit -m "update manifests"
 git push
 
 you will then have update your nixos flake input.
 cd /etc/nixos (or wherever it is located)
 nix flake update *inputname

 # You can now use the new asset in your NixOS configuration.
 ```
 
 
