# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PHAR file format utilities, for when PHP phars you up"
HOMEPAGE="https://github.com/Seldaek/phar-utils"
SRC_URI="https://github.com/Seldaek/phar-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*[phar]
	dev-php/fedora-autoloader"

src_prepare() {
	default

	phpab \
		--quiet \
		--output src/autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die
}

src_install() {
	insinto '/usr/share/php/Seld/PharUtils'
	doins -r src/*

	einstalldocs
}
