{
  description = "modern-hugo-resume";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        biome = pkgs.biome;
        commitlint = pkgs.commitlint;
        go = pkgs.go;
        hugo = pkgs.hugo;
        nodejs = pkgs.nodejs_22;
        pnpm = pkgs.pnpm;
        nativeBuildInputs = [ go hugo nodejs pnpm ];
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              biome.enable = true;
              commitizen.enable = true;
              nixpkgs-fmt.enable = true;
            };
          };
        };

        packages.default = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "cjshearer.dev";
          name = finalAttrs.pname;

          src = ./.;

          nativeBuildInputs = nativeBuildInputs ++ [ pnpm.configHook ];

          pnpmDeps = pnpm.fetchDeps {
            inherit (finalAttrs) pname src;
            hash = "sha256-RvE4R277Kam3s32XbGUIQTToG0cpbhpTaLEU5HsNZZ4=";
          };

          preBuild =
            let
              hugoModules = [
                {
                  owner = "cjshearer";
                  repo = "modern-hugo-resume";
                  rev = "d5aff7eecfd0713d269cde8cf56b0c99b667e824";
                  sha256 = "sha256-zZZOav71P6dczHYvgwFqjBRz9dDLX3ZlYJGKUI6hO+c=";
                }
                {
                  owner = "FortAwesome";
                  repo = "Font-Awesome";
                  rev = "6.5.2";
                  sha256 = "sha256-kUa/L/Krxb5v8SmtACCSC6CI3qTTOTr4Ss/FMRBlKuw=";
                }
              ];
            in
            ''
              go mod vendor
              mv vendor _vendor
              sed -i '/## explicit/d' _vendor/modules.txt

              mkdir -p _vendor/github.com/{${(
                pkgs.lib.concatMapStrings (module: "${module.owner},") hugoModules
              )}}

              ${(pkgs.lib.concatMapStrings (module:
                "ln -s ${pkgs.fetchFromGitHub module} " +
                "_vendor/github.com/${module.owner}/${module.repo}\n"
              ) hugoModules)}
            '';

          postBuild = ''
            hugo -d $out
          '';

          dontInstall = true;
          dontFixup = true;
        });

        devShell = pkgs.mkShell {
          nativeBuildInputs = nativeBuildInputs ++ [
            biome
            self.checks.${system}.pre-commit-check.enabledPackages
          ];

          shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
            pnpm install
          '';
        };
      });
}
