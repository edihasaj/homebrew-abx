class Abx < Formula
  desc "Fast headless browser for AI coding agents"
  homepage "https://github.com/edihasaj/abx"
  url "https://github.com/edihasaj/abx/releases/download/v0.1.0/abx-0.1.0-macos-universal.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  version "0.1.0"
  license "MIT"

  depends_on macos: :ventura

  def install
    bin.install "abx", "abx-server"
  end

  def caveats
    <<~EOS
      abx drives Playwright's Chromium. Fetch it once after install:

        abx install-browser

      That needs bun or node on PATH (brew install bun). Or point abx at an
      existing browser instead:

        export ABX_CHROMIUM_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/abx --version")
  end
end
