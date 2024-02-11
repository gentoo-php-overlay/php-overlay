# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Subtree split of the Symfony Console Component"
HOMEPAGE="https://github.com/symfony/console"
SRC_URI="https://github.com/symfony/console/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	>=dev-php/symfony-deprecation-contracts-2.1
	>=dev-php/symfony-polyfill-mbstring-1.0
	>=dev-php/symfony-polyfill-php80-1.16
	>=dev-php/symfony-service-contracts-1.1
	>=dev-php/symfony-string-5.1
	>=dev-php/psr-log-1.0.2
	dev-php/fedora-autoloader"

S="${WORKDIR}/console-${PV}"

# dependency to >=dev-php/symfony-polyfill-php73-1.24 dropped, because PHP 7.3 is not longer in portage

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
	insinto '/usr/share/php/Symfony/Component/Console'
	doins -r *

	einstalldocs
}
