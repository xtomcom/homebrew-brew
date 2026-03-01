class Rdap < Formula
  desc "A command-line RDAP client for querying domain, IP, and ASN information"
  homepage "https://github.com/xtomcom/rdap"
  version "1.0.4"
  if Hardware::CPU.arm?
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-aarch64"
    sha256 "26c9c4246c9deb64d5833b68e5d0b7d1ee0585f5250b869491065ebeeb86897a"
  else
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-x86_64"
    sha256 "f131a55c90a56b5367ded781c9feb01f345bcd8644d82cee05acbd37abb77b9d"
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
