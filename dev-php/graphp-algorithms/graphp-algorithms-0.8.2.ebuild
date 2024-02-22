# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common mathematical graph algorithms implemented in PHP"
HOMEPAGE="https://github.com/graphp/algorithms"
SRC_URI="https://github.com/graphp/algorithms/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
         dev-php/clue-graph
"

S="${WORKDIR}/algorithms-${PV}"

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
	insinto '/usr/share/php/graphp-algorithms/'
	doins -r src *.php

	einstalldocs
}
