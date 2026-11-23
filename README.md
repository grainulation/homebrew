<p align="center">
  <a href="https://github.com/grainulation/homebrew"><img src="docs/mascot.png" alt="Homebrew logo" width="180"></a>
</p>

<h1 align="center">Homebrew</h1>

<p align="center"><strong>Grainulation tools, installed with Homebrew.</strong></p>

<p align="center">
  <a href="https://brew.sh"><img src="https://img.shields.io/badge/Homebrew-tap-fbb040?logo=homebrew&logoColor=white" alt="Homebrew tap"></a>
  <a href="https://github.com/grainulation/homebrew/actions/workflows/verify.yml"><img src="https://github.com/grainulation/homebrew/actions/workflows/verify.yml/badge.svg?branch=main" alt="Formula installation checks"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="MIT license"></a>
</p>

<p align="center">
  <a href="#install">Install</a> ·
  <a href="#available-formulae">Formulae</a> ·
  <a href="#updating">Updating</a> ·
  <a href="docs/MAINTAINING.md">Maintaining the tap</a> ·
  <a href="SECURITY.md">Security</a>
</p>

---

## Install

Requires [Homebrew](https://brew.sh) on macOS or Linux.

```sh
brew tap grainulation/homebrew https://github.com/grainulation/homebrew
brew install grainulation/homebrew/irrigator grainulation/homebrew/grainulator
```

Try the credential-free demos:

```sh
irrigator demo --run ./first-irrigator-demo
grainulator demo --dir ./first-grainulator-demo
```

The demos need no model credentials. Choose new directories each time.

## Available formulae

| Tool | What it does | Homebrew status |
| --- | --- | --- |
| [Irrigator](https://github.com/grainulation/irrigator) | Durable local workflows for coding agents. | [1.2.1 stable](Formula/irrigator.rb) |
| [Grainulator](https://github.com/grainulation/grainulator) | Evidence and verification for model-assisted work. | [3.0.1 stable](Formula/grainulator.rb) |

Irrigator installs a prebuilt CLI; Go is not required. Homebrew installs Node 24
for Grainulator. See the [installation guide](docs/INSTALLATION.md) for agent
setup and saved-data details.

## Updating

```sh
brew update
brew upgrade grainulation/homebrew/irrigator grainulation/homebrew/grainulator
```

Check the installed version or remove the CLI:

```sh
irrigator version
grainulator version
brew uninstall grainulation/homebrew/irrigator grainulation/homebrew/grainulator
```

Your run directories, evidence and exported results stay where you saved them.
[Moving from the old tap →](docs/INSTALLATION.md#moving-from-the-old-tap)

## Contributing

Formula fixes and updates are welcome. Start with the
[maintenance guide](docs/MAINTAINING.md) for release checks and recipe verification.

Report application issues in [Irrigator](https://github.com/grainulation/irrigator/issues)
or [Grainulator](https://github.com/grainulation/grainulator/issues);
report installation-recipe issues [here](https://github.com/grainulation/homebrew/issues).
For sensitive formula or installation-integrity problems, use the private route
in [SECURITY.md](SECURITY.md).

[MIT license](LICENSE).
