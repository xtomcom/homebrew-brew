class Rdap < Formula
  desc "A command-line RDAP client for querying domain, IP, and ASN information"
  homepage "https://github.com/xtomcom/rdap"
  version "1.0.8"
  if Hardware::CPU.arm?
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-aarch64"
    sha256 "b117ee50f1fbbeee55273ba26ae19f02f412221e077dea82f78f91ee273971bd"
  else
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-x86_64"
    sha256 "a533a7b22a190dead7368888aebf1a609a08578a77498541c8c79902ab941582"
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
