#!/bin/sh

# This script downloads and installs the cpp-init CLI tool.
# It automatically detects the user's architecture and downloads the correct binary.

# --- Configuration ---
# IMPORTANT: Change these to your own GitHub username and repository name!
GITHUB_USER="vj-2303"
GITHUB_REPO="cpp-init"
BINARY_NAME="cpp-init"
INSTALL_PATH="/usr/local/bin"
# ---------------------

set -e # Exit immediately if a command exits with a non-zero status.

# --- Helper Functions ---
echo_info() {
    echo "INFO: $1"
}

echo_error() {
    echo "ERROR: $1" >&2
    exit 1
}

# --- Main Logic ---
echo_info "Starting installation of ${BINARY_NAME}..."

# 1. Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64 | arm64)
        ARCH="arm64"
        ;;
    *)
        echo_error "Unsupported architecture: ${ARCH}. Only x86_64 and arm64 are supported."
        ;;
esac
echo_info "Detected architecture: ${ARCH}"

# 2. Construct download URL
# This fetches the URL for the latest release asset.
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/latest" | grep "browser_download_url.*${BINARY_NAME}-linux-${ARCH}" | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo_error "Could not find a download URL for the latest release. Please check the GitHub repository."
fi
echo_info "Downloading from: ${DOWNLOAD_URL}"

# 3. Download the binary to a temporary file
TEMP_FILE=$(mktemp)
curl -L --progress-bar -o "$TEMP_FILE" "$DOWNLOAD_URL"

# 4. Make it executable
chmod +x "$TEMP_FILE"
echo_info "Binary downloaded and made executable."

# 5. Move to installation path (requires sudo)
echo_info "Moving binary to ${INSTALL_PATH}. You may be asked for your password."
if sudo mv "$TEMP_FILE" "${INSTALL_PATH}/${BINARY_NAME}"; then
    echo_info "✅ Successfully installed ${BINARY_NAME} to ${INSTALL_PATH}/${BINARY_NAME}"
    echo "You can now run '${BINARY_NAME}' from anywhere!"
else
    echo_error "Failed to move binary to ${INSTALL_PATH}. Please check your permissions."
fi
