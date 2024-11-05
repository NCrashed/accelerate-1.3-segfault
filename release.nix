let
  nixpkgs = import ./pkgs.nix;
  project = import ((nixpkgs {}).fetchFromGitHub {
    owner = "NCrashed";
    repo = "haskell-nix";
    rev = "eb45250ac342027d92f27fb97949b95dbbe1a689";
    sha256  = "sha256-eG6Bz/XlZqLngCUZGOBjRX7wgpi6TG2BKMeKsPDHWH0=";
  }) { inherit nixpkgs; };
  compiler = "ghc810";
  projectOverlay = self: super: {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        "${compiler}" = super.haskell.packages."${compiler}".extend libOverrides;
      };
    };
  };
  libOverrides = new: old: {
    accelerate = new.callPackage ./derivations/accelerate.nix {};
  };
in project {
  inherit compiler;
  packages = {
    app = ./app;
  };
  overlays = [
    projectOverlay
  ];
}