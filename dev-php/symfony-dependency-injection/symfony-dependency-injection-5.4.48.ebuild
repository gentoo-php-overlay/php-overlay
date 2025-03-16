# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Allows you to standardize and centralize the way objects are constructed in your application"
HOMEPAGE="https://github.com/symfony/dependency-injection"
SRC_URI="https://github.com/symfony/dependency-injection/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/dependency-injection-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
	dev-php/fedora-autoloader
	dev-php/psr-container
	dev-php/symfony-deprecation-contracts
	dev-php/symfony-polyfill-php80
	dev-php/symfony-polyfill-php81
	dev-php/symfony-service-contracts
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
	"${VENDOR_DIR}/Psr/Container/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/DeprecationContracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php81/autoload.php",
	"${VENDOR_DIR}/Symfony/Contracts/Service/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/DependencyInjection"
	doins -r *.php Argument Attribute Compiler Config Dumper Exception Extension LICENSE LazyProxy Loader ParameterBag
}
