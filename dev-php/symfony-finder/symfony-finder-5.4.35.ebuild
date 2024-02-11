# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Finds files and directories via an intuitive fluent interface"
HOMEPAGE="https://github.com/symfony/finder"
SRC_URI="https://github.com/symfony/finder/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	>=dev-php/symfony-deprecation-contracts-2.1
	>=dev-php/symfony-polyfill-php80-1.16
	dev-php/fedora-autoloader"

S="${WORKDIR}/finder-${PV}"

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
	insinto '/usr/share/php/Symfony/Component/Finder'
	doins -r Comparator Exception Iterator *.php

	einstalldocs
}
