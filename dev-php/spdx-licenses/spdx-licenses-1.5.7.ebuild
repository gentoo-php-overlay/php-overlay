# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SPDX licenses list and validation library."
HOMEPAGE="https://github.com/composer/spdx-licenses"
SRC_URI="https://github.com/composer/spdx-licenses/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die
}

src_install() {
	insinto "/usr/share/php/Composer/res"
	doins -r res/.

	insinto "/usr/share/php/Composer/Spdx"
	doins -r autoload.php src/*
}
