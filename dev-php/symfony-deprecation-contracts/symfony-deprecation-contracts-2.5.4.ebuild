# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A generic function and convention to trigger deprecation notices"
HOMEPAGE="https://github.com/symfony/deprecation-contracts"
SRC_URI="https://github.com/symfony/deprecation-contracts/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/deprecation-contracts-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.1:*
	dev-php/fedora-autoloader
"

src_prepare() {
	default

	echo "<?php" > autoload.php
	echo "require_once \"${EPREFIX}/usr/share/php/Fedora/Autoloader/autoload.php\";" >> autoload.php

	echo "require_once __DIR__ . \"/function.php\";" >> autoload.php

}

src_install() {
	insinto "/usr/share/php/Symfony/Component/DeprecationContracts"
	doins -r *.php LICENSE
}
