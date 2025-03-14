# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GraPHP is the mathematical graph/network library written in PHP."
HOMEPAGE="https://github.com/graphp/graph"
SRC_URI="https://github.com/graphp/graph/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/graph-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-5.3:*
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
}

src_install() {
	insinto "/usr/share/php/Fhaculty/Graph"
	doins -r *.php src src/*
}
