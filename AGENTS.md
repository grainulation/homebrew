# Shared Homebrew distribution

Use the user's authorized scope. Keep formulas pinned to immutable published
archives with real SHA-256 values; never placeholders, moving branches for stable,
or silent source/binary version substitution. Release publication and tags belong
to the application repositories and need separate authorization.

The repository name is homebrew, not homebrew-tap. Document an explicit URL:
brew tap grainulation/homebrew https://github.com/grainulation/homebrew

Update formulas from the application's verified candidate tooling. Keep its
frozen runtime commit unchanged; distribution updates are separate commits.
A private-prefix recipe check, fresh published install, cross-build and actual
platform execution establish different evidence. Do not claim more than ran.
Never invoke paid providers for installation checks or modify a user's host
registration as a package-manager lifecycle side effect. Preserve user data
on upgrade/uninstall. Required enrolled hooks must survive keg cleanup.
