# Makefile for kbot project
REGISTRY ?= ghcr.io
USERNAME ?= kylib4444
APP := kbot
# Application name and registry configuration
# APP := $(shell basename $(shell git remote get-url origin))
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")-$(shell git rev-parse --short HEAD)

# Build configuration
TARGETOS ?= linux
TARGETARCH ?= amd64
CGO_ENABLED ?= 0

# Full image tag
# v1.0.0-106879e-linux-amd64
FULL_TAG := $(VERSION)-$(TARGETOS)-$(TARGETARCH)
IMAGE := $(REGISTRY)/$(USERNAME)/$(APP):$(FULL_TAG)

# Validate environment variables
ifeq ($(TARGETOS),)
$(error TARGETOS is not set)
endif
ifeq ($(TARGETARCH),)
$(error TARGETARCH is not set)
endif

# Phony targets
.PHONY: help format lint test get build image push clean dev release

# Help target
help:
	@echo "Available targets:"
	@echo "  help     - Show this help message"
	@echo "  format   - Format Go code"
	@echo "  lint     - Run golangci-lint"
	@echo "  test     - Run tests"
	@echo "  get      - Get dependencies"
	@echo "  build    - Build the application"
	@echo "  image    - Build Docker image"
	@echo "  push     - Push Docker image to registry"
	@echo "  clean    - Clean build artifacts"
	@echo "  dev      - Development build (with debug info)"
	@echo "  release  - Production build (optimized)"
	@echo ""
	@echo "Configuration:"
	@echo "  TARGETOS   - Target OS (linux, darwin, windows) [$(TARGETOS)]"
	@echo "  TARGETARCH - Target architecture (amd64, arm64) [$(TARGETARCH)]"
	@echo "  CGO_ENABLED - Enable CGO (0 or 1) [$(CGO_ENABLED)]"

# Format Go code
format:
	@echo "Formatting Go code..."
	@gofmt -s -w ./

# Install golangci-lint if not present
.PHONY: install-lint
install-lint:
	@which golangci-lint >/dev/null || (echo "Installing golangci-lint..." && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest)

# Run linter
lint: install-lint
	@echo "Running linter..."
	@golangci-lint run ./...

# Run tests
test:
	@echo "Running tests..."
	@go test -v -cover ./...

# Get dependencies
get:
	@echo "Getting dependencies..."
	@go mod tidy
	@go mod download

# Development build
dev: format get
	@echo "Building development version..."
	@CGO_ENABLED=$(CGO_ENABLED) GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) \
		go build -v -o kbot -ldflags "-X=github.com/den-vasyliev/kbot/cmd.appVersion=$(VERSION)-dev"

# Production build
build: format get
	@echo "Building production version..."
	@CGO_ENABLED=$(CGO_ENABLED) GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) \
		go build -v -o kbot -ldflags "-X=github.com/den-vasyliev/kbot/cmd.appVersion=$(VERSION) -w -s"

# Build Docker image
image:
	@echo "Building Docker image for $(TARGETARCH)..."
	 docker build . -t $(IMAGE) \
		--build-arg TARGETARCH=$(TARGETARCH) \
		--build-arg VERSION=$(VERSION)

# Push Docker image
push:
	@echo "DEBUG: Registry is $(REGISTRY)"
	@echo "DEBUG: Image name is $(IMAGE)"
	@echo "Pushing Docker image..."
	 docker push $(IMAGE)

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf kbot
	@docker rmi $(IMAGE) || true

# Release target
release: clean test build image push
	@echo "Release $(VERSION) completed successfully!"
