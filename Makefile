
# =============================================================================
# CONFIG
# =============================================================================

# Boot2docker configuration
B2D_VERSION := 1.12.5
B2D_BOX_VERSION := 1.12.5
B2D_ISO_FILE := boot2docker.iso
B2D_ISO_URL := https://github.com/boot2docker/boot2docker/releases/download/v$(B2D_VERSION)/boot2docker.iso
B2D_ISO_CHECKSUM := ac45773d50ce4882643844f801806e8b

# Packer configuration
PACKER_TEMPLATE := template.json

# Atlas configuration
ATLAS_USERNAME="AlbanMontaigu"
ATLAS_NAME="boot2docker"


# =============================================================================
# GOALS
# =============================================================================

all: virtualbox


# -----------------------------------------------------------------------------
# PACKER
# -----------------------------------------------------------------------------

packer-file:
	ATLAS_USERNAME=${ATLAS_USERNAME} \
	ATLAS_NAME=${ATLAS_NAME} \
	B2D_BOX_VERSION=${B2D_BOX_VERSION} \
	B2D_ISO_VERSION=${B2D_VERSION} \
	B2D_ISO_URL=${B2D_ISO_URL} \
	B2D_ISO_CHECKSUM=${B2D_ISO_CHECKSUM} \
		m4 template.json.m4 > template.json

packer-validate:
	packer validate ${PACKER_TEMPLATE}


# -----------------------------------------------------------------------------
# VIRTUALBOX
# -----------------------------------------------------------------------------

virtualbox:	virtualbox-clean virtualbox-build

$(B2D_ISO_FILE):
	curl -L -o ${B2D_ISO_FILE} ${B2D_ISO_URL}

$(PRL_B2D_ISO_FILE):
	curl -L -o ${PRL_B2D_ISO_FILE} ${PRL_B2D_ISO_URL}

virtualbox-clean:
	rm -f *.box $(B2D_ISO_FILE)

virtualbox-build: $(B2D_ISO_FILE) packer-file packer-validate
	packer build -only=x64-virtualbox \
		${PACKER_TEMPLATE}

atlas-destroy-version:
	curl https://atlas.hashicorp.com/api/v1/box/AlbanMontaigu/boot2docker/version/${B2D_BOX_VERSION} \
		-X DELETE \
		-d access_token='${ATLAS_TOKEN}'

atlas-push: packer-file packer-validate
	packer push \
		-name ${ALTAS_USERNAME}/${ATLAS_NAME} \
		${PACKER_TEMPLATE}

atlas-virtualbox-test:
	@cd tests/virtualbox; \
		ATLAS_USERNAME=${ATLAS_USERNAME} \
		ATLAS_NAME=${ATLAS_NAME} \
		B2D_VERSION=${B2D_VERSION} \
		B2D_BOX_VERSION=${B2D_BOX_VERSION} \
		bats --tap *.bats


# -----------------------------------------------------------------------------
# PHONY
# -----------------------------------------------------------------------------

.PHONY: all virtualbox \
	virtualbox-clean virtualbox-build
