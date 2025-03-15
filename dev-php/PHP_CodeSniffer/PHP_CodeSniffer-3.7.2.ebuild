# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PHP/CodeSniffer"

DESCRIPTION="PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files and detects violations of a defined set of coding standards."
HOMEPAGE="https://github.com/squizlabs/PHP_CodeSniffer"
SRC_URI="https://github.com/squizlabs/PHP_CodeSniffer/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-lang/php[tokenizer,xmlwriter,simplexml]
	dev-php/symfony-yaml"

src_prepare() {
	default

	sed -i "s~@data_dir@\(/PHP_CodeSniffer\)\?~${EPREFIX}/usr/share/php/data/${MY_PN}~" src/Config.php || die

	VENDOR_DIR="${EPREFIX}/usr/share/php"

	# Yaml support is expected by Drupal Coder
	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

require_once '/usr/share/php/Fedora/Autoloader/autoload.php';

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	"${VENDOR_DIR}/Symfony/Component/Yaml/autoload.php",
]);
EOF
}

src_install() {
	local SCRIPT
	# The PEAR eclass would install everything into the wrong location.
	insinto "/usr/share/php/${MY_PN}"
	doins -r src autoload.php

	insinto "/usr/share/php/data/${MY_PN}"
	doins CodeSniffer.conf.dist
	# These load code via relative paths, so they have to be symlinked
	# and not dobin'd.
	exeinto "/usr/share/php/${MY_PN}/bin"
	for SCRIPT in phpcbf phpcs; do
		doexe "bin/${SCRIPT}"
		dosym "../share/php/${MY_PN}/bin/${SCRIPT}" "/usr/bin/${SCRIPT}"
	done
}
