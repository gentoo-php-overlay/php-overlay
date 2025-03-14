# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Restarts a process without Xdebug."
HOMEPAGE="https://github.com/composer/xdebug-handler"
SRC_URI="https://github.com/composer/xdebug-handler/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/xdebug-handler-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.4:*
	dev-php/fedora-autoloader
	dev-php/pcre
	dev-php/psr-log
"

src_prepare() {
	default

	phpab \
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
	"${VENDOR_DIR}/Composer/Pcre/autoload.php",
	"${VENDOR_DIR}/Psr/Log/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Composer/XdebugHandler"
	doins -r *.php src/*
}
