class Irrigator < Formula
  desc "Durable local workflows for coding agents"
  homepage "https://irrigator.dev"
  license "MIT"

  # BEGIN GENERATED STABLE RELEASE
  # Frozen runtime commit: afc3338cb1f43dc0feac1901f83474d7befc0763
  # Source SHA-256: fb969ec14132232da7870bea686d2ae088a2adaf86ba6d8bbf0ad4c588b8824a
  version "1.2.1"

  on_macos do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.1/irrigator-1.2.1-darwin-arm64.tar.gz"
      sha256 "c40270c0216b133da353c20230470053bb8e9ac25769094b932fcbef88a258f9"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.1/irrigator-1.2.1-darwin-amd64.tar.gz"
      sha256 "70b3a5ba0ab8a8d256593656762f62eb0872252f21b2a219e259af5db33d010a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.1/irrigator-1.2.1-linux-arm64.tar.gz"
      sha256 "3c184edb8a9dac12b04775c5c1fb910ca7786294adfb13ce8e913b2b6de52dce"
    end
    on_intel do
      url "https://github.com/grainulation/irrigator/releases/download/v1.2.1/irrigator-1.2.1-linux-amd64.tar.gz"
      sha256 "76c8b7bb356db9daad8ea64c3e63f3232302cf2837e58c21e874d3a2bb880333"
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
