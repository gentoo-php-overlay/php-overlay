# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Symfony polyfill for ctype functions"
HOMEPAGE="https://github.com/symfony/polyfill-ctype"
SRC_URI="https://github.com/symfony/polyfill-ctype/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/polyfill-ctype-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
	dev-php/fedora-autoloader
"

src_prepare() {
	default

	phpab \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		. \
		|| die
	echo "require_once __DIR__ . \"/bootstrap.php\";" >> autoload.php

}

src_install() {
	insinto "/usr/share/php/Symfony/Polyfill/Ctype"
	doins -r *.php
}
