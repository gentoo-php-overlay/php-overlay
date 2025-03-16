# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PHPMD is a spin-off project of PHP Depend and aims to be a PHP equivalent of the well known Java tool PMD."
HOMEPAGE="https://github.com/phpmd/phpmd"
SRC_URI="https://github.com/phpmd/phpmd/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*[xml]
	dev-php/fedora-autoloader
	dev-php/pdepend
	dev-php/xdebug-handler"

src_prepare() {
	default

	sed -i "s/\/\.\.\/\.\.\/vendor/\/..\//g" src/bin/phpmd || die

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die

	VENDOR_DIR="${EPREFIX}/usr/share/php"
	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	"${VENDOR_DIR}/Fedora/Autoloader/autoload.php",
	"${VENDOR_DIR}/PDepend/autoload.php",
	"${VENDOR_DIR}/Composer/XdebugHandler/autoload.php"
]);
EOF

}

src_install() {
	insinto "/usr/share/php/phpmd"
	doins -r autoload.php src/main

	exeinto "/usr/share/php/phpmd/bin"
	doexe "src/bin/phpmd"
	dosym "/usr/share/php/phpmd/bin/phpmd" "/usr/bin/phpmd"
}
