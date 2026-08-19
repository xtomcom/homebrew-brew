class Rdap < Formula
  desc "A command-line RDAP client for querying domain, IP, and ASN information"
  homepage "https://github.com/xtomcom/rdap"
  version "1.0.7"
  if Hardware::CPU.arm?
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-aarch64"
    sha256 "b7a1c93c7c61bf7766b6e61cdac8d2171a76976e4659522975a6abf95978030f"
  else
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-x86_64"
    sha256 "1bdb29c4df5a786eeeaa3250ecd1f6fbef8f40e9dc8295dd72198039922ac4d2"
  end
  license "MIT"

  def install
    if Hardware::CPU.arm?
      bin.install "rdap-#{version}-macos-aarch64" => "rdap"
    else
      bin.install "rdap-#{version}-macos-x86_64" => "rdap"
    end
  end

  test do
    system "#{bin}/rdap", "--help"
  end
end
