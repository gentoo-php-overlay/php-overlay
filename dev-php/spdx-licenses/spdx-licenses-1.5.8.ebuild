# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SPDX licenses list and validation library."
HOMEPAGE="https://github.com/composer/spdx-licenses"
SRC_URI="https://github.com/composer/spdx-licenses/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/spdx-licenses-${PV}"

LICENSE="MIT"
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
		--output autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die
}

src_install() {
	insinto "/usr/share/php/Composer/Spdx"
	doins -r *.php .github res src/*
}
