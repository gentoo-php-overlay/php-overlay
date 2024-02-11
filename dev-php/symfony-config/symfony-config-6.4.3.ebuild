# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Helps you find, load, combine, autofill and validate configuration values of any kind"
HOMEPAGE="https://github.com/symfony/config"
SRC_URI="https://github.com/symfony/config/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/symfony-deprecation-contracts
	dev-php/symfony-filesystem
	dev-php/symfony-polyfill-ctype
	dev-php/symfony-polyfill-php81"

S="${WORKDIR}/config-${PV}"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		.\
		|| die
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Config"
	doins -r Builder Loader Definition Resource Exception Util *.php
}
