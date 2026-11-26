class Irrigator < Formula
  desc "Durable local workflows for coding agents"
  homepage "https://irrigator.dev"
  license "MIT"

  # BEGIN GENERATED STABLE RELEASE
  # Frozen runtime commit: 64b45d99235615a723354f07cde51bfb5273fe28
  # Source SHA-256: 5a2fb99903ae839d277a12593d0e6f99e8ae96af0abbd32fb34b39b0f65b9131
  version "1.3.2"

  on_macos do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.2/irrigator-1.3.2-darwin-arm64.tar.gz"
      sha256 "46741003269cbaff4b582d92bc811c96ae648621a3290bd2e610e69720fd5b06"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.2/irrigator-1.3.2-darwin-amd64.tar.gz"
      sha256 "fa72348569c8b83c1cb0e813dad29552047832a4c28d1959a4cabe10fb37befd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.2/irrigator-1.3.2-linux-arm64.tar.gz"
      sha256 "e20bb1ab22c28fc4d054d411fb64f6ba9eacb0216f8900318e8fe0b1f0b791fc"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.2/irrigator-1.3.2-linux-amd64.tar.gz"
      sha256 "c1c8b984a736d08b67ee145cf220e5c04fb06e2d33d80e18beeac0c4a3faef01"
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
