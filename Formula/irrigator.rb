class Irrigator < Formula
  desc "Durable local workflows for coding agents"
  homepage "https://irrigator.dev"
  license "MIT"

  # BEGIN GENERATED STABLE RELEASE
  # Frozen runtime commit: 042e27e7a3011480192e65ff20668956df4cc355
  # Source SHA-256: 26d54b7acc155d6cbf61824b0e9d306cd14bf45eae1872e77c33bbb1003bbb93
  version "1.2.0"

  on_macos do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.0/irrigator-1.2.0-darwin-arm64.tar.gz"
      sha256 "8e9ccdc21bcff384ece6068a968746dc64d1b173901492a7f349939b01c3b0a5"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.0/irrigator-1.2.0-darwin-amd64.tar.gz"
      sha256 "07872d91ffb25da207bd42b6df787f65eae10d92a53dbc3a6af4f2dca97af5af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.0/irrigator-1.2.0-linux-arm64.tar.gz"
      sha256 "f15ac1369bf38654371a27ecbff1aa523c53d80efb379b685c620329b0e44a5c"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.0/irrigator-1.2.0-linux-amd64.tar.gz"
      sha256 "7cc8e9b41f3647fae6aff7de8994ab4766aed47cdf154b76bd03f4d11f1d5804"
    end
  end
  # END GENERATED STABLE RELEASE

  head do
    url "https://github.com/grainulation/irrigator.git", branch: "main"
    depends_on "go" => :build
  end

  def install
    if build.head?
      ENV["GOTOOLCHAIN"] = "local"
      ENV["GOWORK"] = "off"
      ENV["CGO_ENABLED"] = "0"
      ENV["GOFLAGS"] = ""
      system "go", "build", "-buildvcs=false", *std_go_args, "."
    else
      bin.install "irrigator"
      pkgshare.install "provenance.json", "SHA256SUMS"
    end
  end

  test do
    ENV["IRRIGATOR_LAUNCH_CONTEXT"] = ""
    ENV["IRRIGATOR_EXECUTOR"] = "local"
    ENV["IRRIGATOR_UI"] = "plain"
    ENV["IRRIGATOR_SESSION_REGISTRY"] = (testpath/"session.json").to_s
    reported_version = shell_output("#{bin}/irrigator version")
    if build.head?
      assert_match(/\A\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?\n\z/, reported_version)
    else
      assert_equal "#{version}\n", reported_version
    end
    system bin/"irrigator", "demo", "--run", testpath/"demo"
    system bin/"irrigator", "export", testpath/"demo", "--out", testpath/"results.json"
    assert_path_exists testpath/"results.json"
  end
end
