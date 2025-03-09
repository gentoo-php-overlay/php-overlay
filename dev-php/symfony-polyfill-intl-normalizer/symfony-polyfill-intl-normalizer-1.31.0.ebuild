# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Symfony polyfill for intl's Normalizer class and related functions"
HOMEPAGE="https://github.com/symfony/polyfill-intl-normalizer"
SRC_URI="https://github.com/symfony/polyfill-intl-normalizer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/polyfill-intl-normalizer-${PV}"

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
	insinto "/usr/share/php/Symfony/Polyfill/Intl/Normalizer"
	doins -r *.php Resources
}
