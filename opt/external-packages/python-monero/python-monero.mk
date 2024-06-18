################################################################################
#
# python-monero
#
################################################################################

PYTHON_MONERO_VERSION = 1.1.1
PYTHON_MONERO_SITE = $(call github,DiosDelRayo,monero-python,v$(PYTHON_MONERO_VERSION))
PYTHON_MONERO_SETUP_TYPE = setuptools
PYTHON_MONERO_LICENSE = MIT

$(eval $(python-package))
