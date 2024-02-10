# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Symfony polyfill backporting some PHP 8.1+ features to lower PHP versions"
HOMEPAGE="https://github.com/symfony/polyfill-php81"
SRC_URI="https://github.com/symfony/polyfill-php81/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"

S="${WORKDIR}/polyfill-php81-${PV}"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		. \
		|| die
	echo "\Fedora\Autoloader\Dependencies::required([__DIR__ . '/bootstrap.php']);" >> autoload.php
}

src_install() {
	insinto '/usr/share/php/Symfony/Component/Polyfill-php81'
	doins -r *

	einstalldocs
}
