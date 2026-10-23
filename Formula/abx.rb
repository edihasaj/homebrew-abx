class Abx < Formula
  desc "Fast headless browser for AI coding agents"
  homepage "https://github.com/edihasaj/abx"
  url "https://github.com/edihasaj/abx/releases/download/v0.1.15/abx-0.1.15-macos-universal.tar.gz"
  sha256 "fb75b3ec856298e813abfc8a2573b1726b8cbafcaaa9a9f5099f1d31aead27ad"
  version "0.1.15"
  license "MIT"

  depends_on "bun"
  depends_on macos: :ventura
  depends_on "node" # current Node runtime for the live-Chrome driver (libexec/live.mjs)

  # The thin CLI is a compiled universal binary; the server runs under bun from
  # a bundle next to its vendored Playwright (Playwright can't be statically
  # compiled — it reads its package files from node_modules at runtime). The
  # CLI resolves ../libexec/abx-server.js relative to itself.
  def install
    bin.install "abx"
    libexec.install "abx-server.js", "node_modules"
    # live.mjs ships from v0.1.3+; guard so older tarballs still install cleanly.
    libexec.install "live.mjs" if File.exist?("live.mjs")
    # abx >= 0.1.12 runs live.mjs with libexec/node. Link Homebrew's current
    # Node through its opt path so Node upgrades never move it.
    # Absolute link on purpose: install_symlink would store a relative path into
    # the versioned Cellar dir, which a node upgrade deletes.
    (libexec/"node").make_symlink(HOMEBREW_PREFIX/"opt/node/bin/node")
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
    assert_match "0.1.15", shell_output("#{bin}/abx --version")
  end
end
