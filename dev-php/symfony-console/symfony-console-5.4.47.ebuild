# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Eases the creation of beautiful and testable command line interfaces"
HOMEPAGE="https://github.com/symfony/console"
SRC_URI="https://github.com/symfony/console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/console-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
	dev-php/fedora-autoloader
	dev-php/symfony-deprecation-contracts
	dev-php/symfony-polyfill-mbstring
	dev-php/symfony-polyfill-php73
	dev-php/symfony-polyfill-php80
	dev-php/symfony-service-contracts
	dev-php/symfony-string
"

src_prepare() {
	default

	phpab \
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
	"${VENDOR_DIR}/Psr/Container/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/DeprecationContracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Intl/Grapheme/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Intl/Normalizer/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Mbstring/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php73/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php",
	"${VENDOR_DIR}/Symfony/Contracts/Service/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/String/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Console"
	doins -r *.php Attribute CI Command CommandLoader Completion DependencyInjection Descriptor Event EventListener Exception Formatter Helper Input Logger Output Question Resources SignalRegistry Style Tester
}
