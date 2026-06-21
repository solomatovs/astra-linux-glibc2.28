ARTIFACTS     ?= artifacts
BUILD_CONTEXT ?= .

ASTRA_VERSION ?= 2.12
GLIBC_VERSION ?= 2.28

OREL_IMAGE    ?= registry.astralinux.ru/library/orel:$(ASTRA_VERSION)
OREL_TAR      ?= $(ARTIFACTS)/orel-$(ASTRA_VERSION).tar
IMAGE         ?= astra-linux:$(ASTRA_VERSION)-glibc$(GLIBC_VERSION)

.DEFAULT_GOAL := help
.PHONY: help sources image build

help:
	@echo "  make sources   скачать исходники glibc $(GLIBC_VERSION) (базовый образ astra — tar в $(ARTIFACTS)/)"
	@echo "  make image  скачать образ astra-linux с офф. репозитория $(OREL_IMAGE) -> $(OREL_TAR)"
	@echo "  make build     собрать базовый образ glibc $(GLIBC_VERSION): $(IMAGE)"

sources:
	@mkdir -p $(ARTIFACTS)/glibc-src
	@dest="$(ARTIFACTS)/glibc-src/glibc-$(GLIBC_VERSION).tar.xz"; \
	if [ -f "$$dest" ]; then echo "  ✓ $$dest"; \
	else url="https://ftp.gnu.org/gnu/glibc/glibc-$(GLIBC_VERSION).tar.xz"; \
	  echo ">>> $$url"; curl -fSL -o "$$dest" "$$url"; fi
	@if [ -f "$(OREL_TAR)" ]; then echo "  ✓ $(OREL_TAR)"; \
	else echo "  ! нет $(OREL_TAR) — положи tar-архив базового образа astra в $(ARTIFACTS)/ вручную"; fi

build:
	docker build -f Dockerfile --target glibc -t $(IMAGE) $(BUILD_CONTEXT) --progress plain
	@docker images $(IMAGE)

image:
	@mkdir -p $(ARTIFACTS)
	@if [ -f "$(OREL_TAR)" ]; then echo "  ✓ $(OREL_TAR)"; \
	else echo ">>> docker pull $(OREL_IMAGE)"; docker pull $(OREL_IMAGE); \
	  echo ">>> docker save -> $(OREL_TAR)"; docker save -o "$(OREL_TAR)" $(OREL_IMAGE); \
	  echo "  ✓ $(OREL_TAR)"; fi
