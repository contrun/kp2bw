{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        rec {
          packages = {
            kp2bw = with pkgs.python3Packages;
              buildPythonApplication rec {
                pname = "kp2bw";
                version = "unstable";
                src = ./.;

                propagatedBuildInputs = [ pykeepass pkgs.bitwarden-cli ];

                meta = with pkgs.lib; {
                  homepage = "https://github.com/jampe/kp2bw";
                  description = "Python based KeePass 2.x database to Bitwarden converter";
                };
              };
          };

          defaultPackage = packages.kp2bw;

          apps.kp2bw = flake-utils.lib.mkApp { drv = packages.kp2bw; };

          defaultApp = apps.kp2bw;
        });
}
