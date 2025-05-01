# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )

inherit distutils-r1

DESCRIPTION="Composer Ebuild"
HOMEPAGE="https://github.com/gentoo-php-overlay/composer-ebuild"
SRC_URI="https://github.com/gentoo-php-overlay/composer-ebuild/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-php/composer
	dev-python/packaging
	dev-python/pygithub
	dev-python/requests
"

src_install() {

	distutils-r1_src_install

	local INSTALL_DIR="/usr/share/${PN}"

	insinto ${INSTALL_DIR}
	doins -r templates

}
