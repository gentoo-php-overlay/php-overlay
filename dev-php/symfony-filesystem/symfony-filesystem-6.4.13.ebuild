# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Provides basic utilities for the filesystem"
HOMEPAGE="https://github.com/symfony/filesystem"
SRC_URI="https://github.com/symfony/filesystem/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/filesystem-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-8.1:*
	dev-php/fedora-autoloader
	dev-php/symfony-polyfill-ctype
	dev-php/symfony-polyfill-mbstring
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

	VENDOR_DIR="${EPREFIX}/usr/share/php"
	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	"${VENDOR_DIR}/Fedora/Autoloader/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Mbstring/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Filesystem"
	doins -r *.php Exception LICENSE
}
