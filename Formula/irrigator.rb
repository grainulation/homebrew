class Irrigator < Formula
  desc "Durable local workflows for coding agents"
  homepage "https://irrigator.dev"
  license "MIT"

  # BEGIN GENERATED STABLE RELEASE
  # Frozen runtime commit: 1922e619cf73c00350bd2fa806ff55797a4792fc
  # Source SHA-256: 6967fb6720105bbd712f4f4723350b92813ddcd615baea99c126873f13e1def5
  version "1.3.1"

  on_macos do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.1/irrigator-1.3.1-darwin-arm64.tar.gz"
      sha256 "ce99cb57d16e887e3f3622a56e8195cc2f0034ac1707d28efb86e7f9331c4b3d"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.1/irrigator-1.3.1-darwin-amd64.tar.gz"
      sha256 "9bf1be99ec20fb5bf590539ba97d1e3206a821ab90f2c168de98521db6c849eb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.1/irrigator-1.3.1-linux-arm64.tar.gz"
      sha256 "3e19da460c19f5dee52d4b089c78ea867da6e308aa2748c628ffd505b1bedc85"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.3.1/irrigator-1.3.1-linux-amd64.tar.gz"
      sha256 "39adbb82eba151396fa6a21cb73fdccd57a0b4ae2994c25e797bf43ff879afee"
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
