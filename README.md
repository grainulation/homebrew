# Grainulation Homebrew

Shared Homebrew recipes for [Irrigator](https://github.com/grainulation/irrigator)
and [Grainulator](https://github.com/grainulation/grainulator).

## Install Irrigator

This repository has a nonstandard tap name, so include the explicit URL once:

    brew tap grainulation/homebrew https://github.com/grainulation/homebrew
    brew install grainulation/homebrew/irrigator
    irrigator version
    irrigator demo --run ./first-irrigator-demo

Use a new demo directory. The demo uses a mock provider and requires no model
credentials. It creates local run artifacts.

The stable formula installs the actual published **1.0.0** archives. Irrigator
1.1.0 is available as tagged source, but its published release currently has
no binary archives; the stable formula does not claim to install it. Each
archive has a literal checksum and frozen source identity in the formula.
Checksums detect byte changes; the archives are unsigned.

The optional development build uses current main and a Homebrew Go compiler:

    brew install --HEAD grainulation/homebrew/irrigator

Development HEAD is mutable and distinct from the pinned stable release.
Native runtime archives cover macOS/Linux ARM64 and x86_64. Homebrew support
also depends on the OS and Homebrew's own platform/dependency support; native
Windows is unsupported. Windows users can use the Linux app within WSL2.

## Upgrade and remove

    brew upgrade grainulation/homebrew/irrigator
    brew test grainulation/homebrew/irrigator
    brew uninstall grainulation/homebrew/irrigator

Uninstall removes this copy of the CLI. Keep run directories, checkpoints,
exports, credentials and host/plugin configuration under your own control;
this formula never deletes them or performs agent setup.

For a copy installed from the older application-owned tap, inspect
brew list --formula --full-name and preserve any local formula customizations.
Add this shared tap explicitly before changing the installed formula:

    brew tap grainulation/homebrew https://github.com/grainulation/homebrew
    brew reinstall grainulation/homebrew/irrigator

Check the reported formula owner and version before removing an unused old tap.
Do not remove unrelated formulas or assume a package update refreshes an
already-running host/plugin.

## Grainulator 3

Grainulator's application PR prepares canonical v3 CLI/native archives and a
verified formula generator. A stable grainulator formula will be added here
after the matching release assets are published and a fresh channel install
passes. There is no working Grainulator 3 Brew command yet; no placeholder
formula or checksums are advertised.

Application candidate tests cover offline CLI/MCP behavior, verified native
assets and explicit enrolled hooks. Installing a formula does not configure
agent hosts, migrate existing data, enroll hooks or call model providers.

## Maintainers

Generate Irrigator's formula using tools/homebrew_formula.py in its source
repository with all four frozen native candidates and the published SHA256SUMS.
Generate Grainulator's formula using scripts/homebrew-formula.mjs with its
complete trusted release manifest and exact candidate assets. Do not rebuild
or move the runtime tag to include its own formula hashes.

Review the generated formula and exact bytes, run the application's recipe
verification, publish only separately authorized passing release assets, and
then advance this tap in a distribution-only commit. Run a fresh fully qualified
install before describing a new channel/version as verified. Never copy an
archive's adjacent checksum as independent proof of publisher authenticity.
