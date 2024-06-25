# cjshearer.dev

My resume site, built with [modern-hugo-resume](https://github.com/cjshearer/modern-hugo-resume) - A responsive, minimal, print-friendly resume builder. Powered by Hugo, Tailwind CSS, Nix, and GitHub Pages.

## Local Development

### Requirements

These can be installed manually, or automatically with [nix](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#the-determinate-nix-installer) by running `nix develop`:

1. Install [`hugo`](https://gohugo.io/installation/) 1.27.0+extended.
2. Install [`go`](https://go.dev/dl/) >= 1.22.3.
3. Install `node` >= 20.2.0 with [nvm](https://github.com/nvm-sh/nvm).
4. Install `pnpm` with `corepack enable`.
5. Run `pnpm install`.

### Common Commands
```sh
nix develop     # open a development environment, with all requirements satisfied
nix build       # build the production site, exactly the same way it's done in CI
nix flake check # run formatter/linter checks, exactly the same way it's done in CI

hugo server     # serve to localhost and rebuild changes automatically
hugo --minify   # build static site for production
```