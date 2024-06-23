# cjshearer.dev

My resume site, built from [modern-hugo-resume](https://github.com/cjshearer/cjshearer.dev).

## Requirements

Can be installed manually, or with `nix develop`:

1. Install [`hugo`](https://gohugo.io/installation/) 1.27.0+extended.
2. Install [`go`](https://go.dev/dl/) >= 1.22.3.
3. Install `node` >= 20.2.0 with [nvm](https://github.com/nvm-sh/nvm).
4. Install `pnpm` with `corepack enable`.
5. Run `pnpm install`.

## Local Development

Development of this repository uses the following commands frequently.

```sh
nix build       # build the production site, exactly the same way it's done in CI
nix flake check # run formatter/linter checks, exactly the same way it's done in CI
nix develop     # open a development environment with requirements satisfied

hugo server     # rebuild changes automatically
```
