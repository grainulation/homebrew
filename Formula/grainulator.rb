class Grainulator < Formula
  desc "Evidence and verified execution tools for model-assisted work"
  homepage "https://grainulator.dev"
  license "MIT"
  # Frozen source commit: 54d33de8b70e3dd5398c42fe16f0c1aa7c6097a7
  # Generate only from independently reviewed, passing candidate bytes.
  url "https://github.com/grainulation/grainulator/releases/download/v3.0.1/grainulator-3.0.1.tgz"
  sha256 "3d23f07476a36750df5b9ae2b612d802a720efb83ad86480ae0bbeaf763c39b1"
  version "3.0.1"
  # v3 supports tested Node 24/26 LTS; pin the minimum supported LTS for this channel.
  depends_on "node@24"
  # The wrapper selects Node explicitly; preserve manifest-verified application bytes.
  skip_clean "libexec/app"

  resource "release-manifest" do
    url "https://github.com/grainulation/grainulator/releases/download/v3.0.1/release-manifest.json"
    sha256 "e027684160ff39b1baeeb2dce925965c97ebefa7d9b92facc8ef4263ff364268"
  end

  on_macos do
    on_arm do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.1/grainulator-runtime-3.0.1-aarch64-apple-darwin.tar.gz"
        sha256 "4a6c58d609ae9ddff052b9f6856addaee52954d9df012b06fe03e5d83107485e"
      end
    end
    on_intel do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.1/grainulator-runtime-3.0.1-x86_64-apple-darwin.tar.gz"
        sha256 "a71a2f8deb2ba8a600f835631b4f8b4e5a76d1ba020b527f01941f519e6b967a"
      end
    end
  end

  on_linux do
    on_arm do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.1/grainulator-runtime-3.0.1-aarch64-unknown-linux-musl.tar.gz"
        sha256 "a593f132ab9a77011d1b3edb7fd8e177c759852156953e444a85ad198f5118b9"
      end
    end
    on_intel do
      resource "native-runtime" do
        url "https://github.com/grainulation/grainulator/releases/download/v3.0.1/grainulator-runtime-3.0.1-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e32e232387f14a11926e7cffb43a42772487e75d1d76fee5b499317668864591"
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
    receipt = { schema: "grainulator.runtime.install.v1", manifest_sha256: "e027684160ff39b1baeeb2dce925965c97ebefa7d9b92facc8ef4263ff364268",
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
