# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Restarts a process without Xdebug."
HOMEPAGE="https://github.com/composer/xdebug-handler"
SRC_URI="https://github.com/composer/xdebug-handler/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/psr-log
	dev-php/pcre"

src_prepare() {
	default

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
	'${VENDOR_DIR}/Fedora/Autoloader/autoload.php',
	'${VENDOR_DIR}/Psr/Log/autoload.php',
	'${VENDOR_DIR}/Composer/Pcre/autoload.php'
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Composer/XdebugHandler"
	doins -r  autoload.php src/*
}
