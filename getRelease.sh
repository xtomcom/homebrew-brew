#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Cross-platform sed -i
sedi() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

# Cross-platform sha256
sha256() {
    if command -v sha256sum &>/dev/null; then
        sha256sum "$1" | cut -d ' ' -f 1
    else
        shasum -a 256 "$1" | cut -d ' ' -f 1
    fi
}

update_rdap(){
    echo "Checking rdap..."

    # Get the latest version from GitHub API
    last_version=$(curl -Ls "https://api.github.com/repos/xtomcom/rdap/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//g')

    # Get current version from formula
    current_version=$(grep 'version "' Formula/rdap.rb | sed -E 's/.*version "([^"]+)".*/\1/')

    # Compare versions
    if [ "$current_version" = "$last_version" ]; then
        echo -e "${GREEN}✓ rdap is already up to date (v${current_version})${NC}"
        return 0
    fi

    echo -e "${YELLOW}→ Updating rdap from v${current_version} to v${last_version}${NC}"

    # Update version in the formula
    sedi "s/version \".*\"/version \"${last_version}\"/" Formula/rdap.rb

    # Download the new binaries
    wget -q -O rdap_macos_aarch64 "https://github.com/xtomcom/rdap/releases/download/v${last_version}/rdap-${last_version}-macos-aarch64"
    wget -q -O rdap_macos_x86_64 "https://github.com/xtomcom/rdap/releases/download/v${last_version}/rdap-${last_version}-macos-x86_64"

    # Calculate the SHA256 hash for the new binaries
    aarch64_sha256=$(sha256 rdap_macos_aarch64)
    x86_64_sha256=$(sha256 rdap_macos_x86_64)

    # Update the SHA256 hashes in the formula
    sedi "7s/.*/    sha256 \"${aarch64_sha256}\"/" Formula/rdap.rb
    sedi "10s/.*/    sha256 \"${x86_64_sha256}\"/" Formula/rdap.rb

    # Delete the new binaries
    rm -f rdap_macos*

    echo -e "${GREEN}✓ rdap updated successfully${NC}"
}

echo "======================================"
echo "  Homebrew Formula Update Script"
echo "======================================"
echo ""

update_rdap

echo ""
echo "======================================"
echo "  Update Check Complete"
echo "======================================"
