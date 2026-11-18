# Installation details

## Stable releases

Add the shared tap once:

```sh
brew tap grainulation/homebrew https://github.com/grainulation/homebrew
brew install grainulation/homebrew/irrigator grainulation/homebrew/grainulator
brew test grainulation/homebrew/irrigator
brew test grainulation/homebrew/grainulator
```

The explicit URL identifies this repository. Subsequent updates use
`brew update` and `brew upgrade grainulation/homebrew/irrigator grainulation/homebrew/grainulator`.

The stable formulas select published prebuilt archives for macOS or Linux on
ARM64 or x86_64. Homebrew also needs to support your OS and machine. Native
Windows is unsupported; use Linux within WSL2.

The pinned stable versions are Irrigator 1.0.0 and Grainulator 3.0.0.
Irrigator 1.1.0 has tagged source but no published CLI archives. Formula promotion
follows verified release assets rather than switching to a different build
under the same version.

Grainulator requires Node 24; Homebrew installs that dependency. Its formula
also selects the matching prebuilt native runtime. It does not run Cargo or
change agent-host registration during installation.

## Development builds

Build Irrigator's current main branch with:

```sh
brew install --HEAD grainulation/homebrew/irrigator
```

HEAD requires Homebrew's Go compiler and follows a moving development branch.
Update an existing development installation with:

```sh
brew upgrade --fetch-HEAD grainulation/homebrew/irrigator
```

## Moving from the old tap

Inspect `brew list --formula --full-name` and preserve any local formula
customizations. Add this shared tap explicitly, then reinstall:

```sh
brew tap grainulation/homebrew https://github.com/grainulation/homebrew
brew reinstall grainulation/homebrew/irrigator
irrigator version
```

Confirm the installed formula's owner before removing an unused old tap.
Do not remove a tap containing other formulas you use.

## Plugins and saved data

Homebrew installs the CLI. Follow each application's agent setup guide for its
plugins, providers and host registration. Updating the CLI does not refresh a
running agent session or another installed copy.

Uninstalling this formula leaves run directories, checkpoints, exports,
credentials and host settings under your control. Grainulator keeps explicitly
enrolled native hooks separate from disposable Brew kegs; it does not enroll or
detach hooks during package installation/removal. See its
[native-runtime guide](https://github.com/grainulation/grainulator/blob/main/docs/RUNTIME.md)
for retained assets and explicit enrollment.
