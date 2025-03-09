# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A lightweight implementation of CommonJS Promises/A for PHP"
HOMEPAGE="https://github.com/reactphp/promise"
SRC_URI="https://github.com/reactphp/promise/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/promise-${PV}"

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

	phpab \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		. \
		|| die
	echo "require_once __DIR__ . \"/src/functions_include.php\";" >> autoload.php

}

src_install() {
	insinto "/usr/share/php/React/Promise"
	doins -r *.php src src/*
}
