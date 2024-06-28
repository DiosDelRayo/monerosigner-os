################################################################################
#
# monero-wallet-rpc
#
################################################################################

MONERO_WALLET_RPC_VERSION = 0.18.3.3
MONERO_WALLET_RPC_SOURCE = monero-linux-armv7-v$(MONERO_WALLET_RPC_VERSION).tar.bz2
MONERO_WALLET_RPC_SITE = https://downloads.getmonero.org/cli
MONERO_WALLET_RPC_LICENSE = BSD-3-Clause
MONERO_WALLET_RPC_LICENSE_FILES = LICENSE

define MONERO_WALLET_RPC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/monero-wallet-rpc $(TARGET_DIR)/usr/bin/monero-wallet-rpc
endef

$(eval $(generic-package))
