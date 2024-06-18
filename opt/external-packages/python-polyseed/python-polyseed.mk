################################################################################
#
# python-polyseed
#
################################################################################

PYTHON_POLYSEED_VERSION = 0.1.0
PYTHON_POLYSEED_SITE = $(call github,DiosDelRayo,polyseed-python,v$(PYTHON_POLYSEED_VERSION))
PYTHON_POLYSEED_SETUP_TYPE = setuptools
PYTHON_POLYSEED_LICENSE = MIT

$(eval $(python-package))
