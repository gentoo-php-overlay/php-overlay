# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Handles serializing and deserializing data structures, including object graphs, into array structures or other formats like XML and JSON."
HOMEPAGE="https://github.com/symfony/serializer"
SRC_URI="https://github.com/symfony/serializer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/serializer-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
	dev-php/fedora-autoloader
	dev-php/symfony-deprecation-contracts
	dev-php/symfony-polyfill-ctype
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
	"${VENDOR_DIR}/Symfony/Component/DeprecationContracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Serializer"
	doins -r *.php Annotation CacheWarmer DependencyInjection Encoder Exception Extractor Mapping NameConverter Normalizer
}
