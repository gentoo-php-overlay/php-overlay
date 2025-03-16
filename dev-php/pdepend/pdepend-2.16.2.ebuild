# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official version of pdepend to be handled with Composer"
HOMEPAGE="https://github.com/pdepend/pdepend"
SRC_URI="https://github.com/pdepend/pdepend/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/pdepend-${PV}"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-5.3:*
	dev-php/fedora-autoloader
	dev-php/symfony-config
	dev-php/symfony-dependency-injection
	dev-php/symfony-filesystem
	dev-php/symfony-polyfill-mbstring
"

PATCHES=(
	"${FILESDIR}"/fix-default-include-path.patch
	"${FILESDIR}"/fix-duplicated-abstract-configuration-class.patch
)

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
	"${VENDOR_DIR}/Symfony/Component/Config/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/DependencyInjection/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/DeprecationContracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/Filesystem/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Mbstring/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php81/autoload.php",
	"${VENDOR_DIR}/Symfony/Contracts/Service/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/PDepend"
	doins -r *.php LICENSE src

	exeinto "/usr/share/php/PDepend/bin"
	doexe "src/bin/pdepend"
	dosym "/usr/share/php/PDepend/bin/pdepend" "/usr/bin/pdepend"
}
