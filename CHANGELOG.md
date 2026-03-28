# Changelog

All notable changes to this project will be documented in this file.

The format is inspired by Keep a Changelog, and the project follows semantic versioning once tagged releases begin.

## [0.1.0] - 2026-03-28

### Added

- A user-space Steam launcher that preserves the official client while splitting proxy policy between Steam web content and game traffic.
- A runtime-managed `steamwebhelper` wrapper that removes forced GPU disable flags and restores the original Steam wrapper after exit.
- Optional Big Picture launch integration for `gamescope`, `gamemode`, and `mangoapp`.
- An i3 Big Picture bridge that hands fullscreen to launched games and restores it when they exit.
- XDG-friendly install and uninstall scripts.
- Example proxy and runtime configuration files.
- Architecture and i3 integration documentation.
- GitHub Actions validation for shell syntax and ShellCheck.

[0.1.0]: https://github.com/m1ngsama/deckless/releases/tag/v0.1.0
