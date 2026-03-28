# Contributing

Thanks for contributing to Deckless.

## Project scope

Deckless exists to improve the real desktop Linux Steam experience without forking or replacing the official Steam package.

Changes are a good fit when they:

- keep the official Steam client as the source of truth
- stay auditable and small
- solve real Linux desktop friction around Steam, Big Picture, controllers, graphics, audio, or proxy policy
- improve installation, rollback, and documentation

Changes are a poor fit when they:

- require patching `/usr/bin/steam`
- permanently rewrite Steam runtime files at rest
- add large background services for problems that can be solved with small scripts

## Development setup

Required local tools:

- `bash`
- `jq`
- `shellcheck`

Optional for runtime testing:

- `steam`
- `gamescope`
- `gamemode`
- `i3`

## Before opening a pull request

Run:

```bash
bash -n install.sh uninstall.sh bin/deckless-steam bin/deckless-bigpicture bin/deckless-i3-bigpicture-bridge
shellcheck install.sh uninstall.sh bin/deckless-steam bin/deckless-bigpicture bin/deckless-i3-bigpicture-bridge
```

If your change affects runtime behavior, include a short note about how you tested it.

## Pull request guidelines

- Keep pull requests focused.
- Explain the user problem first, then the implementation.
- Mention rollback or compatibility impact when you change install behavior.
- Update documentation when you add or rename config variables.
- Add a changelog entry only when preparing a tagged release.

## Issues

Please use the issue templates when possible:

- bug reports for regressions or environment-specific failures
- feature requests for new workflows or platform support

## Code style

- Prefer POSIX-adjacent shell where practical, but Bash is allowed.
- Keep comments short and only where the behavior is not obvious.
- Favor straightforward scripts over clever compactness.
