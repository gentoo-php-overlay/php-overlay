# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="API to strings and deals with bytes, UTF-8 code points and grapheme clusters"
HOMEPAGE="https://github.com/symfony/string"
SRC_URI="https://github.com/symfony/string/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	>=dev-php/symfony-polyfill-ctype-1.8
	>=dev-php/symfony-polyfill-intl-grapheme-1.0
	>=dev-php/symfony-polyfill-intl-normalizer-1.0
	>=dev-php/symfony-polyfill-mbstring-1.0
	>=dev-php/symfony-polyfill-php80-1.15
	dev-php/fedora-autoloader"

S="${WORKDIR}/string-${PV}"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		. \
		|| die
}

src_install() {
	insinto '/usr/share/php/Symfony/Component/String'
	doins -r *

	einstalldocs
}
