# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Subtree split of the Symfony Filesystem Component"
HOMEPAGE="https://github.com/symfony/filesystem"
SRC_URI="https://github.com/symfony/filesystem/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	>=dev-php/symfony-deprecation-contracts-2.1
	>=dev-php/symfony-polyfill-ctype-1.8
	>=dev-php/symfony-polyfill-mbstring-1.8
	>=dev-php/symfony-polyfill-php80-1.16
	dev-php/fedora-autoloader"

S="${WORKDIR}/filesystem-${PV}"

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
	insinto '/usr/share/php/Symfony/Component/Filesystem'
	doins -r Exception *.php

	einstalldocs
}
