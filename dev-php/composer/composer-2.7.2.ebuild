# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="https://github.com/composer/composer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*[curl]
	>=dev-php/ca-bundle-1.0
	>=dev-php/class-map-generator-1.0
	>=dev-php/metadata-minifier-1.0
	>=dev-php/pcre-2.1
	>=dev-php/semver-3.2
	>=dev-php/spdx-licenses-1.5
	>=dev-php/xdebug-handler-2
	>=dev-php/json-schema-5.2.11
	>=dev-php/psr-log-1.0
	>=dev-php/jsonlint-1.4
	>=dev-php/phar-utils-1.2
	>=dev-php/symfony-console-5.4.11
	>=dev-php/symfony-filesystem-5.4
	>=dev-php/symfony-finder-5.4
	>=dev-php/symfony-process-5.4
	>=dev-php/reactphp-promise-2.8
	>=dev-php/symfony-polyfill-php80-1.24
	>=dev-php/symfony-polyfill-php81-1.24
	>=dev-php/signal-handler-2
	dev-php/fedora-autoloader"

# dependency to >=dev-php/symfony-polyfill-php73-1.24 dropped, because PHP 7.3 is not longer in portage

PATCHES=(
	"${FILESDIR}"/autoload.patch
)

src_prepare() {
	default

	mkdir vendor || die

	phpab \
		--quiet \
		--output vendor/autoload.php \
		--template "${FILESDIR}"/autoload.php.tpl \
		--basedir src \
		src \
		|| die

	VENDOR_DIR="${EPREFIX}/usr/share/php"
	cat >> vendor/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'${VENDOR_DIR}/Composer/CaBundle/autoload.php',
	'${VENDOR_DIR}/Composer/ClassMapGenerator/autoload.php',
	'${VENDOR_DIR}/Composer/MetadataMinifier/autoload.php',
	'${VENDOR_DIR}/Composer/Pcre/autoload.php',
	'${VENDOR_DIR}/Composer/Semver/autoload.php',
	'${VENDOR_DIR}/Composer/XdebugHandler/autoload.php',
	'${VENDOR_DIR}/Composer/Spdx/autoload.php',
	'${VENDOR_DIR}/Psr/Log/autoload.php',
	'${VENDOR_DIR}/Seld/PharUtils/autoload.php',
	'${VENDOR_DIR}/Seld/JsonLint/autoload.php',
	'${VENDOR_DIR}/Seld/SignalHandler/autoload.php',
	'${VENDOR_DIR}/Fedora/Autoloader/autoload.php',
	'${VENDOR_DIR}/JsonSchema/autoload.php',
	'${VENDOR_DIR}/React/Promise/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/PolyfillCtype/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/DeprecationContracts/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/ServiceContracts/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/PolyfillIntlNormalizer/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/Filesystem/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/Finder/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/Console/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/PolyfillMbstring/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/Process/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/PolyfillIntlGrapheme/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/Polyfill-php80/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/Polyfill-php81/autoload.php',
	'${VENDOR_DIR}/Symfony/Component/String/autoload.php',
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
