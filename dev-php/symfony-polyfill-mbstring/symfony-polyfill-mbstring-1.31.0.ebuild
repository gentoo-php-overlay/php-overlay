# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Symfony polyfill for the Mbstring extension"
HOMEPAGE="https://github.com/symfony/polyfill-mbstring"
SRC_URI="https://github.com/symfony/polyfill-mbstring/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/polyfill-mbstring-${PV}"

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
	insinto "/usr/share/php/Symfony/Polyfill/Mbstring"
	doins -r *.php Resources
}
