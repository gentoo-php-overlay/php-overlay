# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Composer helps you declare, manage and install dependencies of PHP projects. It ensures you have the right stack everywhere."
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="https://github.com/composer/composer/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/composer-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.4:*
	dev-php/fedora-autoloader
	dev-php/ca-bundle
	dev-php/class-map-generator
	dev-php/justinrainbow-json-schema
	dev-php/metadata-minifier
	dev-php/pcre
	dev-php/psr-log
	dev-php/react-promise
	dev-php/seld-jsonlint
	dev-php/seld-phar-utils
	dev-php/seld-signal-handler
	dev-php/semver
	dev-php/spdx-licenses
	dev-php/symfony-console
	dev-php/symfony-filesystem
	dev-php/symfony-finder
	dev-php/symfony-polyfill-php73
	dev-php/symfony-polyfill-php80
	dev-php/symfony-polyfill-php81
	dev-php/symfony-process
	dev-php/xdebug-handler
"

PATCHES=(
	"${FILESDIR}"/autoload.patch
	"${FILESDIR}"/explain-non-standard-install.patch
)

src_prepare() {
	default

	mkdir vendor || die

	phpab \
		--output vendor/autoload.php \
		--template "${FILESDIR}"/autoload.php.tpl \
		--basedir src \
		src \
		|| die

	VENDOR_DIR="${EPREFIX}/usr/share/php"
	cat >> vendor/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	"${VENDOR_DIR}/Fedora/Autoloader/autoload.php",
	"${VENDOR_DIR}/Composer/CaBundle/autoload.php",
	"${VENDOR_DIR}/Composer/ClassMapGenerator/autoload.php",
	"${VENDOR_DIR}/JsonSchema/autoload.php",
	"${VENDOR_DIR}/Composer/MetadataMinifier/autoload.php",
	"${VENDOR_DIR}/Composer/Pcre/autoload.php",
	"${VENDOR_DIR}/Psr/Container/autoload.php",
	"${VENDOR_DIR}/Psr/Log/autoload.php",
	"${VENDOR_DIR}/React/Promise/autoload.php",
	"${VENDOR_DIR}/Seld/JsonLint/autoload.php",
	"${VENDOR_DIR}/Seld/PharUtils/autoload.php",
	"${VENDOR_DIR}/Seld/Signal/autoload.php",
	"${VENDOR_DIR}/Composer/Semver/autoload.php",
	"${VENDOR_DIR}/Composer/Spdx/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/Console/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/DeprecationContracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/Filesystem/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/Finder/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Intl/Grapheme/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Intl/Normalizer/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Mbstring/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php73/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill/Php81/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/Process/autoload.php",
	"${VENDOR_DIR}/Symfony/Contracts/Service/autoload.php",
	"${VENDOR_DIR}/Symfony/Component/String/autoload.php",
	"${VENDOR_DIR}/Composer/XdebugHandler/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/${PN}"

	# Composer expects the LICENSE file to be there, and the
	# easiest thing to do is to give it what it wants.
	doins -r LICENSE res src vendor

	exeinto "/usr/share/${PN}/bin"
	doexe "bin/${PN}"
	dosym "../share/${PN}/bin/${PN}" "/usr/bin/${PN}"
}
