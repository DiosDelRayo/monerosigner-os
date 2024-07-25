################################################################################
#
# python-monero
#
################################################################################

PYTHON_MONERO_VERSION = 1.2.3
PYTHON_MONERO_SITE = $(call github,DiosDelRayo,monero-python,v$(PYTHON_MONERO_VERSION))
PYTHON_MONERO_DEPENDENCIES = python-pynacl python-pycryptodomex python-requests python-varint zlib
PYTHON_MONERO_SETUP_TYPE = setuptools
PYTHON_MONERO_LICENSE = MIT

$(eval $(python-package))
