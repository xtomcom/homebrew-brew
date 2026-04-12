class Rdap < Formula
  desc "A command-line RDAP client for querying domain, IP, and ASN information"
  homepage "https://github.com/xtomcom/rdap"
  version ""
  if Hardware::CPU.arm?
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-aarch64"
    sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  else
    url "https://github.com/xtomcom/rdap/releases/download/v#{version}/rdap-#{version}-macos-x86_64"
    sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
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
