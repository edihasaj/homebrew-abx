class Abx < Formula
  desc "Fast headless browser for AI coding agents"
  homepage "https://github.com/edihasaj/abx"
  url "https://github.com/edihasaj/abx/releases/download/v0.1.10/abx-0.1.10-macos-universal.tar.gz"
  sha256 "b5bc28e87d8f491d43e9ba4dbd9b5321aa9991ab87009dd484992f7077c906c2"
  version "0.1.10"
  license "MIT"

  depends_on "bun"
  depends_on "node" # runtime for the live-Chrome driver (libexec/live.mjs)
  depends_on macos: :ventura

  # The thin CLI is a compiled universal binary; the server runs under bun from
  # a bundle next to its vendored Playwright (Playwright can't be statically
  # compiled — it reads its package files from node_modules at runtime). The
  # CLI resolves ../libexec/abx-server.js relative to itself.
  def install
    bin.install "abx"
    libexec.install "abx-server.js", "node_modules"
    # live.mjs ships from v0.1.3+; guard so older tarballs still install cleanly.
    libexec.install "live.mjs" if File.exist?("live.mjs")
  end

  def caveats
    <<~EOS
      abx drives Playwright's Chromium. Fetch it once after install:

        abx install-browser

      Or point abx at an existing browser instead:

        export ABX_CHROMIUM_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    EOS
  end

  test do
    assert_match "0.1.10", shell_output("#{bin}/abx --version")
  end
end
