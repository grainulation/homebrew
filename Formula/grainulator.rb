class Grainulator < Formula
  desc "Evidence and verified execution tools for model-assisted work"
  homepage "https://grainulator.dev"
  license "MIT"
  # Frozen source commit: 8acbedffe49f8dd6d77d547615d1f13da36e8bb6
  # Generate only from independently reviewed, passing candidate bytes.
  url "https://github.com/grainulation/grainulator/releases/download/v3.0.0/grainulator-3.0.0.tgz"
  sha256 "8913dbf10978f66d6d5691b5b1c1cd3a17c6af514faa0b26c620bb120b46619d"
  version "3.0.0"
  # v3 supports tested Node 24/26 LTS; pin the minimum supported LTS for this channel.
  depends_on "node@24"

  resource "release-manifest" do
    url "https://github.com/grainulation/grainulator/releases/download/v3.0.0/release-manifest.json"
    sha256 "5816b1f7f4fb6c9060851c561f8c7c9c2a30715ff09133efc5df0519bcbe3afd"
  end

  on_macos do
    on_arm do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.0/grainulator-runtime-3.0.0-aarch64-apple-darwin.tar.gz"
        sha256 "03def6d44b8ee2379026521adaca37552185b8474ba36fccf42476809d5cc9bf"
      end
    end
    on_intel do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.0/grainulator-runtime-3.0.0-x86_64-apple-darwin.tar.gz"
        sha256 "64e217fc6db3824bfb82fc01c12c2810361edf43d6ac4510b3dacfc7cee3be1c"
      end
    end
  end

  on_linux do
    on_arm do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.0/grainulator-runtime-3.0.0-aarch64-unknown-linux-musl.tar.gz"
        sha256 "d2e70c69498b2901f3c057fe7d732cfd7fdd301ae4c0d8b949876df46e2275e0"
      end
    end
    on_intel do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.0/grainulator-runtime-3.0.0-x86_64-unknown-linux-musl.tar.gz"
        sha256 "646bbead178ddcaf0ce33c8dd3c5c058d36b2eb29bdb29c205ac8846b4b5a89a"
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
    receipt = { schema: "grainulator.runtime.install.v1", manifest_sha256: "5816b1f7f4fb6c9060851c561f8c7c9c2a30715ff09133efc5df0519bcbe3afd",
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
