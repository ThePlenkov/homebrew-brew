class Bro < Formula
  desc "Agent's sidekick — CLI carrying agent-workflow mechanics"
  homepage "https://github.com/ThePlenkov/bro"
  url "https://registry.npmjs.org/@broject/bro/-/bro-0.2.5.tgz"
  sha256 "734548d262180514cce1691c4fe811a74fb844103bf78fd984e9f1264987bdbb"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    (bin/"bro").write_env_script libexec/"bin/bro", PATH: "#{Formula["node"].opt_bin}:$PATH"
    chmod 0755, bin/"bro"
  end

  def caveats
    <<~EOS
      bro drives bd (beads), git, and gh as child processes:
        brew install bd        # or: https://github.com/gastownhall/beads
        brew install gh && gh auth login
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bro --version")
  end
end
