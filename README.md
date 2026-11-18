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
  <a href="docs/MAINTAINING.md">Maintaining the tap</a>
</p>

---

## Install

Requires [Homebrew](https://brew.sh) on macOS or Linux.

```sh
brew tap grainulation/homebrew https://github.com/grainulation/homebrew
brew install grainulation/homebrew/irrigator
```

Then try Irrigator with mock workers:

```sh
irrigator demo --run ./first-irrigator-demo
```

The demo needs no model credentials. Choose a new run directory each time.

## Available formulae

| Tool | What it does | Homebrew status |
| --- | --- | --- |
| [Irrigator](https://github.com/grainulation/irrigator) | Durable local workflows for coding agents. | [1.0.0 stable](Formula/irrigator.rb) |
| [Grainulator](https://github.com/grainulation/grainulator) | Evidence and verification for model-assisted work. | Planned with the 3.0 release |

Irrigator installs a prebuilt CLI; Go is not required. Its 1.1.0 release is
currently source-only, so the stable formula stays on 1.0.0.
[Installation details and development builds →](docs/INSTALLATION.md)

For Grainulator today, use its [installation guide](https://github.com/grainulation/grainulator/blob/main/docs/INSTALLATION.md).
Its Brew formula will follow the verified 3.0 release assets.

## Updating

```sh
brew update
brew upgrade grainulation/homebrew/irrigator
```

Check the installed version or remove the CLI:

```sh
irrigator version
brew uninstall grainulation/homebrew/irrigator
```

Your run directories and exported results stay where you saved them.
[Moving from the old tap →](docs/INSTALLATION.md#moving-from-the-old-tap)

## Contributing

Formula fixes and updates are welcome. Start with the
[maintenance guide](docs/MAINTAINING.md) for release checks and recipe verification.

Report application issues in [Irrigator](https://github.com/grainulation/irrigator/issues)
or [Grainulator](https://github.com/grainulation/grainulator/issues);
report installation-recipe issues [here](https://github.com/grainulation/homebrew/issues).

[MIT license](LICENSE).
