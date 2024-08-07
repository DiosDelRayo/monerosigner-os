################################################################################
#
# monero-wallet-rpc-xmrsigner
#
################################################################################

MONERO_WALLET_RPC_XMRSIGNER_VERSION = 0.18.3.3-xmrsigner
MONERO_WALLET_RPC_XMRSIGNER_SOURCE = monero-wallet-rpc_linux_armv6_static.tar.bz2
MONERO_WALLET_RPC_XMRSIGNER_SITE = https://github.com/DiosDelRayo/monero/releases/download/v$(MONERO_WALLET_RPC_XMRSIGNER_VERSION)
MONERO_WALLET_RPC_XMRSIGNER_LICENSE = BSD-3-Clause
MONERO_WALLET_RPC_XMRSIGNER_LICENSE_FILES = LICENSE

define MONERO_WALLET_RPC_XMRSIGNER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/monero-wallet-rpc $(TARGET_DIR)/usr/bin/monero-wallet-rpc
endef

$(eval $(generic-package))
