{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    latex.url = "github:leixb/latex-template";
  };

  outputs = { self, nixpkgs, utils, latex }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        dev-packages = with pkgs; [
          texlab
          zathura
          wmctrl
          which
          python39Packages.pygments
        ];

        texlive = [
          pkgs.texlive.combined.scheme-full
          pkgs.gnuplot
        ];
      in
      rec {
        devShell = pkgs.mkShell {
          name = "texlive";
          buildInputs = [ dev-packages texlive ];
        };

        packages.document = latex.lib.latexmk {
          inherit pkgs texlive;
          src = ./.;
          shellEscape = true;
          minted = true;
          name = "document.pdf";
        };

        defaultPackage = packages.document;
      }
    );
}
