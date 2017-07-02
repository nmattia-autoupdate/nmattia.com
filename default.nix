{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc801" , stdenv ? nixpkgs.stdenv}:

let
  siteBuilder = nixpkgs.pkgs.haskellPackages.callPackage ./foo.nix { };
in
  stdenv.mkDerivation rec {
    name = "nmattia-com-builder";

    src = if stdenv.lib.inNixShell then null else ./.;

    buildPhase = ''
      export LANG=en_US.UTF-8 # fixes charset issues
      ${siteBuilder}/bin/site build
    '';

    installPhase = ''
      mkdir -p $out
      ${nixpkgs.pkgs.rsync}/bin/rsync -rts _site/ $out
    '';
  }
