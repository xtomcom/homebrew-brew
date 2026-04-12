#!/bin/bash

# Colors for output
RED='\033[0;31m'
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

    # Get the latest version from GitHub API (retry up to 3 times)
    last_version=""
    for attempt in 1 2 3; do
        api_response=$(curl -Ls --max-time 30 "https://api.github.com/repos/xtomcom/rdap/releases/latest")
        last_version=$(echo "$api_response" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//g')
        if [ -n "$last_version" ]; then
            break
        fi
        echo -e "${YELLOW}⚠ GitHub API request failed (attempt ${attempt}/3), retrying in 5s...${NC}"
        sleep 5
    done

    if [ -z "$last_version" ]; then
        echo -e "${RED}✗ Failed to fetch latest version from GitHub API after 3 attempts, skipping rdap${NC}"
        return 1
    fi

    # Validate version format (e.g. 1.0.2, 2.1.0)
    if ! echo "$last_version" | grep -qE '^[0-9]+\.[0-9]+(\.[0-9]+)*$'; then
        echo -e "${RED}✗ Invalid version format: '${last_version}', skipping rdap${NC}"
        return 1
    fi

    # Get current version from formula
    current_version=$(grep 'version "' Formula/rdap.rb | sed -E 's/.*version "([^"]+)".*/\1/')

    # Compare versions
    if [ "$current_version" = "$last_version" ]; then
        echo -e "${GREEN}✓ rdap is already up to date (v${current_version})${NC}"
        return 0
    fi

    echo -e "${YELLOW}→ Updating rdap from v${current_version} to v${last_version}${NC}"

    # Download the new binaries
    if ! curl -Ls --max-time 120 --fail -o rdap_macos_aarch64 "https://github.com/xtomcom/rdap/releases/download/v${last_version}/rdap-${last_version}-macos-aarch64"; then
        echo -e "${RED}✗ Failed to download aarch64 binary, skipping rdap${NC}"
        rm -f rdap_macos_aarch64
        return 1
    fi

    if ! curl -Ls --max-time 120 --fail -o rdap_macos_x86_64 "https://github.com/xtomcom/rdap/releases/download/v${last_version}/rdap-${last_version}-macos-x86_64"; then
        echo -e "${RED}✗ Failed to download x86_64 binary, skipping rdap${NC}"
        rm -f rdap_macos_aarch64 rdap_macos_x86_64
        return 1
    fi

    # Calculate the SHA256 hash for the new binaries
    aarch64_sha256=$(sha256 rdap_macos_aarch64)
    x86_64_sha256=$(sha256 rdap_macos_x86_64)

    if [ -z "$aarch64_sha256" ] || [ -z "$x86_64_sha256" ]; then
        echo -e "${RED}✗ Failed to calculate SHA256 hashes, skipping rdap${NC}"
        rm -f rdap_macos_aarch64 rdap_macos_x86_64
        return 1
    fi

    # Update version in the formula
    sedi "s/version \".*\"/version \"${last_version}\"/" Formula/rdap.rb

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
