# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Provides an object-oriented API to strings and deals with bytes, UTF-8 code points and grapheme clusters in a unified way"
HOMEPAGE="https://github.com/symfony/string"
SRC_URI="https://github.com/symfony/string/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/string-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
	dev-php/fedora-autoloader
	dev-php/symfony-polyfill-ctype
	dev-php/symfony-polyfill-intl-grapheme
	dev-php/symfony-polyfill-intl-normalizer
	dev-php/symfony-polyfill-mbstring
	dev-php/symfony-polyfill-php80
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
	"${VENDOR_DIR}/Symfony/Polyfill/Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Intl/Grapheme/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Intl/Normalizer/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Mbstring/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php"
]);
EOF
	echo "require_once __DIR__ . \"/Resources/functions.php\";" >> autoload.php

}

src_install() {
	insinto "/usr/share/php/Symfony/Component/String"
	doins -r *.php Exception Inflector Resources Slugger
}
