OS_ARCH=darwin_amd64
NAME=sts
HOSTNAME=github.com
NAMESPACE=brodster22
VERSION=0.1
BINARY=terraform-provider-${NAME}

build:
	go build -o ${BINARY}

install: build
	mkdir -p ~/.terraform.d/plugins/${HOSTNAME}/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}
	mv ${BINARY} ~/.terraform.d/plugins/${HOSTNAME}/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}