# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Finds files and directories via an intuitive fluent interface"
HOMEPAGE="https://github.com/symfony/finder"
SRC_URI="https://github.com/symfony/finder/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/finder-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-8.1:*
	dev-php/fedora-autoloader
"

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
	insinto "/usr/share/php/Symfony/Component/Finder"
	doins -r *.php Comparator Exception Iterator LICENSE
}
