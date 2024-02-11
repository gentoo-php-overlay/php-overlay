# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Symfony polyfill for intl's grapheme_* functions"
HOMEPAGE="https://github.com/symfony/polyfill-intl-grapheme"
SRC_URI="https://github.com/symfony/polyfill-intl-grapheme/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"

S="${WORKDIR}/polyfill-intl-grapheme-${PV}"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		. \
		|| die
	echo "\Fedora\Autoloader\Dependencies::required([__DIR__ . '/bootstrap.php']);" >> autoload.php
}

# TODO: Check if README.md is installed twice
src_install() {
	insinto '/usr/share/php/Symfony/Component/PolyfillIntlGrapheme'
	doins -r *

	einstalldocs
}
