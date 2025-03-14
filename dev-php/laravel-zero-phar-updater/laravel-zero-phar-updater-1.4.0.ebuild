# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A thing to make PHAR self-updating easy and secure."
HOMEPAGE="https://github.com/laravel-zero/phar-updater"
SRC_URI="https://github.com/laravel-zero/phar-updater/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/phar-updater-${PV}"

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
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		. \
		|| die
}

src_install() {
	insinto "/usr/share/php/Humbug/SelfUpdate"
	doins -r *.php src src/*
}
