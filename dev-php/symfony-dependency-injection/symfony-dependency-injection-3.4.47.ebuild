# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Symfony DependencyInjection Component"
HOMEPAGE="https://github.com/symfony/dependency-injection"
SRC_URI="https://github.com/symfony/dependency-injection/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	<dev-php/psr-container-2"

S="${WORKDIR}/dependency-injection-${PV}"

src_prepare() {
	default

	# Delete tests as autoload.php creation would fail
	rm -R "${S}/Tests"

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
	'/usr/share/php/PSR/Container/autoload.php',
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/DependencyInjection"
	doins -r Argument Exception ParameterBag Compiler Extension Config LazyProxy Dumper Loader *.php
}
