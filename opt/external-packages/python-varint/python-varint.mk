################################################################################
#
# python-varint
#
################################################################################

PYTHON_VARINT_VERSION = 1.0.2
PYTHON_VARINT_SOURCE = varint-$(PYTHON_VARINT_VERSION).tar.gz
PYTHON_VARINT_SITE = https://files.pythonhosted.org/packages/source/v/varint
PYTHON_VARINT_SETUP_TYPE = setuptools
PYTHON_VARINT_LICENSE = MIT
PYTHON_VARINT_LICENSE_FILES = LICENSE

$(eval $(python-package))
