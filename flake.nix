{
  description = "plymouth-theme-muskduck";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      plymouth-theme-muskduck = (with pkgs; stdenvNoCC.mkDerivation {
          pname = "plymouth-theme-muskduck";
          version = "1.0.0";
          src = ./.;
				  installPhase = ''
				    mkdir -p $out/share/plymouth/themes/muskduck
				    cp -r $src/{*.plymouth,*.script,*.png} $out/share/plymouth/themes/muskduck/
				    substituteInPlace $out/share/plymouth/themes/muskduck/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/muskduck"
				  '';
        }
      );
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = plymouth-theme-muskduck;
      devShell = pkgs.mkShell {
        buildInputs = [
          plymouth-theme-muskduck
        ];
      };
    }
  );
}



