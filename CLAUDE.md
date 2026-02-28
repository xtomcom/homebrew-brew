# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Homebrew tap repository (`xtomcom/brew`) that distributes pre-built macOS binaries for [xtomcom/rdap](https://github.com/xtomcom/rdap), a command-line RDAP client.

## Repository Structure

- `Formula/rdap.rb` — Homebrew formula for rdap (supports both arm64/aarch64 and x86_64)
- `getRelease.sh` — Script that checks GitHub releases for new versions, downloads binaries, computes SHA256 hashes, and updates the formula
- `.github/workflows/getRelease.yaml` — GitHub Actions workflow that runs `getRelease.sh` on manual dispatch

## How the Update Process Works

1. `getRelease.sh` queries the GitHub API for the latest release tag from `xtomcom/rdap`
2. Compares it against the version string in `Formula/rdap.rb`
3. If newer, downloads both macOS binaries (aarch64 and x86_64), computes their SHA256 hashes
4. Updates the version and SHA256 values in the formula using `sed` with hardcoded line numbers:
   - Line 8: aarch64 SHA256
   - Line 11: x86_64 SHA256
5. The GitHub Actions workflow auto-commits the changes

## Key Conventions

- Formula binaries are downloaded directly from GitHub releases (not built from source)
- The formula uses `Hardware::CPU.arm?` to select the correct binary for the architecture
- Binary download URLs follow the pattern: `rdap-{version}-macos-{aarch64|x86_64}`
- The `sed` commands in `getRelease.sh` reference specific line numbers in `rdap.rb` — if the formula structure changes, these line numbers must be updated accordingly

## Adding a New Formula

To add a new software package, you need to:
1. Create a new `.rb` file in `Formula/` following the pattern in `rdap.rb`
2. Add a corresponding `update_*` function in `getRelease.sh` that handles version checking and hash updates
3. Call the new function at the bottom of `getRelease.sh`
4. Update `README.md` with install instructions
