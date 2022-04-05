let
  packages = import ./.;
  inherit (packages) pkgs cardano-datum-keeper;
  inherit (cardano-datum-keeper) haskell;
in
  haskell.project.shellFor {
    withHoogle = false;

    nativeBuildInputs = with cardano-datum-keeper; [
      hlint
      cabal-install
      haskell-language-server
      stylish-haskell
      pkgs.niv
      cardano-repo-tool
      pkgs.ghcid
      # HACK: This shouldn't need to be here.
      pkgs.lzma.dev
    ];

    buildInputs = with cardano-datum-keeper; [
      pkgs.postgresql
    ];
  }