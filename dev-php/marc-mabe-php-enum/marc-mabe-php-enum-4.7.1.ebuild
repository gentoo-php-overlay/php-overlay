# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple and fast implementation of enumerations with native PHP"
HOMEPAGE="https://github.com/marc-mabe/php-enum"
SRC_URI="https://github.com/marc-mabe/php-enum/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/php-enum-${PV}"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.4:*
	dev-php/fedora-autoloader
"

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
	insinto "/usr/share/php/MabeEnum"
	doins -r *.php src src/* stubs
}
