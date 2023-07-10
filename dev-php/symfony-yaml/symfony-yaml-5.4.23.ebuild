# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Loads and dumps YAML files"
HOMEPAGE="https://github.com/symfony/yaml/archive/refs/tags/v5.4.19.tar.gz"
SRC_URI="https://github.com/symfony/yaml/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/symfony-deprecation-contracts
	dev-php/symfony-polyfill-ctype"

S="${WORKDIR}/yaml-${PV}"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		.\
		|| die

	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/Fedora/Autoloader/autoload.php',
	'/usr/share/php/Symfony/Component/DeprecationContracts/autoload.php',
	'/usr/share/php/Symfony/Component/PolyfillCtype/autoload.php',
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Yaml"
	doins -r  *.php Tag Resources Exception Command
}
