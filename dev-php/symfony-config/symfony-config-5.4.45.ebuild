# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Helps you find, load, combine, autofill and validate configuration values of any kind"
HOMEPAGE="https://github.com/symfony/config"
SRC_URI="https://github.com/symfony/config/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/config-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
	dev-php/fedora-autoloader
	dev-php/symfony-deprecation-contracts
	dev-php/symfony-filesystem
	dev-php/symfony-polyfill-ctype
	dev-php/symfony-polyfill-php80
	dev-php/symfony-polyfill-php81
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
	"${VENDOR_DIR}/Symfony/Component/DeprecationContracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/Filesystem/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Mbstring/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php81/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Config"
	doins -r *.php Builder Definition Exception LICENSE Loader Resource Util
}
