class Grainulator < Formula
  desc "Evidence and verified execution tools for model-assisted work"
  homepage "https://grainulator.dev"
  license "MIT"
  # Frozen source commit: ed51c24f15e5e0be79c2fc6c1e99a75fa2360dad
  # Pin only independently verified, published release bytes.
  url "https://github.com/grainulation/grainulator/releases/download/v3.2.0/grainulator-3.2.0.tgz"
  sha256 "373bf793d629486078704f9d89f25f5d779d6d119f96593e517758bc58143b3a"
  version "3.2.0"
  # v3 supports tested Node 24/26 LTS; pin the minimum supported LTS for this channel.
  depends_on "node@24"
  # The wrapper selects Node explicitly; preserve manifest-verified application bytes.
  skip_clean "libexec/app"

  resource "release-manifest" do
    url "https://github.com/grainulation/grainulator/releases/download/v3.2.0/release-manifest.json"
    sha256 "59ebc1eb110a5e8e45bb5ff66d1f17a69124fddec71156e0d6ea24ef07b7b004"
  end

  on_macos do
    on_arm do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.2.0/grainulator-runtime-3.2.0-aarch64-apple-darwin.tar.gz"
        sha256 "21435d5704bf43fb12328e8369258384b33f6d274bf01d7a8ec8af0d995c47ae"
      end
    end
    on_intel do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.2.0/grainulator-runtime-3.2.0-x86_64-apple-darwin.tar.gz"
        sha256 "74af25c88eb18b124e20a5de76c01a248a97e74c5860f1c2f82c6f0d6d3ff9a5"
      end
    end
  end

  on_linux do
    on_arm do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.2.0/grainulator-runtime-3.2.0-aarch64-unknown-linux-musl.tar.gz"
        sha256 "574740652f07200dd8c9863e859abdc8ce3c5c7425c6f4ba71a239e621373bea"
      end
    end
    on_intel do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.2.0/grainulator-runtime-3.2.0-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a728aac962f3766cf5c41c480f6482ad5c5e51629ddd399dc05a2e6e8fecd764"
      end
    end
  end

  def install
    (libexec/"app").install Dir.children(".")
    resource("native-runtime").stage { (libexec/"native").install Dir.children(".") }
    resource("release-manifest").stage { (libexec/"release").install "release-manifest.json" }
    manifest_bytes = (libexec/"release/release-manifest.json").binread
    manifest = JSON.parse(manifest_bytes)
    target = (libexec/"native/runtime-asset.json").read.then { |value| JSON.parse(value).fetch("target") }
    asset = manifest.fetch("assets").find { |item| item.fetch("target") == target }
    receipt = { schema: "grainulator.runtime.install.v1", manifest_sha256: "59ebc1eb110a5e8e45bb5ff66d1f17a69124fddec71156e0d6ea24ef07b7b004",
                manifest: [manifest_bytes].pack("m0"), archive_sha256: asset.fetch("sha256") }
    (libexec/"native/.install-receipt.json").write JSON.generate(receipt) + "\n"
    bin.mkpath
    (bin/"grainulator").write <<~SH, perm: 0755
      #!/bin/sh
      GRAINULATOR_INSTALL_ORIGIN=homebrew
      GRAINULATOR_HOMEBREW_LAUNCHER=#{(opt_bin/"grainulator").to_s.shellescape}
      GRAINULATOR_RUNTIME_ASSET_DIR=#{(libexec/"native").to_s.shellescape}
      export GRAINULATOR_INSTALL_ORIGIN GRAINULATOR_HOMEBREW_LAUNCHER GRAINULATOR_RUNTIME_ASSET_DIR
      exec #{(Formula["node@24"].opt_bin/"node").to_s.shellescape} #{(libexec/"app/bin/grainulator.js").to_s.shellescape} "$@"
    SH
    # Completion/manual assets, when shipped, use Homebrew locations; no shell profile edits.
    bash_completion.install_symlink libexec/"app/share/completions/grainulator.bash" => "grainulator"
    zsh_completion.install_symlink libexec/"app/share/completions/grainulator.zsh" => "_grainulator"
    fish_completion.install_symlink libexec/"app/share/completions/grainulator.fish"
    man1.install_symlink libexec/"app/share/man/man1/grainulator.1"
  end

  test do
    assert_path_exists bash_completion/"grainulator"
    assert_path_exists zsh_completion/"_grainulator"
    assert_path_exists fish_completion/"grainulator.fish"
    assert_path_exists man1/"grainulator.1"
    %w[share/completions/grainulator.bash share/completions/grainulator.zsh share/completions/grainulator.fish share/man/man1/grainulator.1].each do |file|
      assert_path_exists libexec/"app"/file
    end
    system bin/"grainulator", "doctor", "--json"
    system bin/"grainulator", "demo", "--dir", testpath/"demo", "--json"
    system bin/"grainulator", "init", "--dir", testpath/"sprint", "--question", "Installed artifact check", "--json"
    system bin/"grainulator", "compile", "--dir", testpath/"sprint", "--json"
    (testpath/"native").mkpath
    system bin/"grainulator", "runtime", "init", "--dir", testpath/"native", "--json"
    system bin/"grainulator", "runtime", "check", "--dir", testpath/"native", "--json", "--no-state"
  end
end
