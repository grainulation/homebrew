# Maintain the shared tap

Keep formula changes separate from application source and release tags. Every
stable URL and SHA-256 must refer to an immutable published archive. Checksums
identify bytes; unsigned checksums and provenance alone do not authenticate the
publisher.

The maintained `Formula/*.rb` recipes live in this shared tap. Application
repositories own their build checks and public release inputs. Commit recipe
updates here.

## Prepare a formula update

Generate Irrigator's formula from its application repository using
`tools/homebrew_formula.py` with all four passing frozen native candidates
and the published SHA256SUMS. The generator verifies the source commit, version
and archive identities.

For Grainulator, follow its current `docs/RELEASING.md`. Download the published
attachments and run `scripts/verify-release.mjs` from the matching built source
with the independently reviewed manifest digest, release version and source
commit. Update `Formula/grainulator.rb` with that version and frozen source,
the base and four native archive URLs and digests, and the manifest URL, digest
and install-receipt pin. Preserve the explicit Node launcher and immutable
application tree. Its installed Node dependency and native target must agree
with the tested host matrix. No Grainulator formula generator is required.

Update both reviewed/public install matrices and the README's stable versions.
When advancing Grainulator, pin the upgrade job's previous formula to an existing
immutable tap commit, verify its formula digest and old version, and set the new
version to the reviewed release.

Do not rebuild or move a runtime tag to include its own generated formula
hashes. Publish separately authorized passing application assets, then advance
the tap in a distribution-only commit. Never commit placeholder checksums or a
stable formula pointing at an unreleased URL.

## Verify what users install

Run the application's actual formula recipe check and credential-free
installed workflows. Private-prefix recipe tests, fresh public-channel
installation, cross-compilation, native execution and full agent-host
discovery establish different evidence; record which ran.

The tap's workflow checks both applications on fresh macOS ARM64 runners.
Pull requests install the published archives using the exact reviewed local
recipes. After a main-branch merge, separate jobs fetch the public tap over the
network, require its commit to match the triggering main commit, then install,
test and check each exact version. Public-channel results come from those
separate jobs. Other advertised application targets need their own native
acceptance. A successful native binary build does not establish that Homebrew
and its dependencies support every OS/prefix combination.

## Grainulator native runtime

The Grainulator formula pins the published base archive, release manifest and
all four native targets. Carry the independently reviewed manifest digest from
the release job when generating an update. Test a fresh fully qualified
installation before advertising a new channel.

The upgrade job installs the published 3.0.1 recipe from immutable tap commit
`dc7ea2bd4fb334de4c6f0c0a9e797a8eeabc0198`, then upgrades its published
archives to 3.2.0 and removes the old keg. It checks user-data hashes and the
stable MCP registration and launcher. This is a reviewed-recipe/public-archive
upgrade. Fresh public-main installation and full agent-host discovery are
separate checks.

Keep the immutable application tree intact. Formula wrappers select the declared
Node and matching formula-owned native asset; they do not rewrite shipped files
or silently use tools from PATH. Required long-lived native hooks use explicit
retained user-cache assets and enrollment receipts, independent of keg cleanup.

Updates must preserve user data, host security wrappers and unrelated
configuration. No install/test operation should invoke paid providers or make
automatic changes to agent-host registration.
