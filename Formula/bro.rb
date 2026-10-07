class Bro < Formula
  desc "Agent's sidekick — CLI carrying agent-workflow mechanics"
  homepage "https://github.com/ThePlenkov/bro"
  url "https://github.com/ThePlenkov/bro/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "5e8f85bc0ee9250351e526acb4c33b11f8667939d7662af904cd65ab6eefbbe0"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "build"

    cd "packages/cli" do
      libexec.install "dist"
      # dist is bundled except smol-toml; workspace deps are inlined, so
      # ship a pruned package.json and resolve just the external dep
      require "json"
      pkg = JSON.parse(File.read("package.json"))
      pkg["dependencies"].select! { |name, _| name == "smol-toml" }
      File.write(libexec/"package.json", JSON.pretty_generate(pkg))
    end

    cd libexec do
      system "npm", "install", "--omit=dev", "--ignore-scripts"
    end

    (bin/"bro").write_env_script libexec/"dist/index.js", PATH: "#{Formula["node"].opt_bin}:$PATH"
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
