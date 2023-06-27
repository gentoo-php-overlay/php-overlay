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

	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/Fedora/Autoloader/autoload.php',
	'/usr/share/php/Psr/Log/autoload.php',
	'/usr/share/php/Composer/Pcre/autoload.php'
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Composer/XdebugHandler"
	doins -r  autoload.php src/*
}
