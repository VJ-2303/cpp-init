# Makefile for the cpp-init tool

# Variables
BINARY_NAME=cpp-init
INSTALL_PATH=/usr/local/bin
VERSION=v1.0.0 # It's good practice to version your releases

# Default command to run when you just type "make"
all: build

# Builds the Go binary for your local machine
build:
	@echo "Building $(BINARY_NAME) for local use..."
	@go build -o $(BINARY_NAME) main.go
	@echo "$(BINARY_NAME) built successfully."

# Cross-compiles the binary for Linux releases
release:
	@echo "Building releases for Linux..."
	@mkdir -p dist
	@GOOS=linux GOARCH=amd64 go build -o dist/$(BINARY_NAME)-linux-amd64 main.go
	@GOOS=linux GOARCH=arm64 go build -o dist/$(BINARY_NAME)-linux-arm64 main.go
	@echo "✅ Release builds are ready in the 'dist/' directory."

# Installs the locally built binary (for your own testing)
install: build
	@echo "Installing $(BINARY_NAME) to $(INSTALL_PATH)..."
	@sudo mv $(BINARY_NAME) $(INSTALL_PATH)/$(BINARY_NAME)
	@echo "✅ Installation complete! You can now run '$(BINARY_NAME)' from anywhere."

# Uninstalls the binary
uninstall:
	@echo "Uninstalling $(BINARY_NAME) from $(INSTALL_PATH)..."
	@sudo rm -f $(INSTALL_PATH)/$(BINARY_NAME)
	@echo "Uninstallation complete."

# Cleans up build artifacts
clean:
	@echo "Cleaning up..."
	@rm -f $(BINARY_NAME)
	@rm -rf dist

.PHONY: all build release install uninstall clean
