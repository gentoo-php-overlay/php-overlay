# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library to validate a json schema."
HOMEPAGE="https://github.com/jsonrainbow/json-schema"
SRC_URI="https://github.com/jsonrainbow/json-schema/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/json-schema-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.4:*
	dev-php/fedora-autoloader
	dev-php/marc-mabe-php-enum
"

src_prepare() {
	default

	phpab \
		--quiet \
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
	"${VENDOR_DIR}/MabeEnum/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/JsonSchema"
	doins -r *.php LICENSE bin dist src

	exeinto "/usr/share/php/JsonSchema/bin"
	doexe "bin/validate-json"
	dosym "/usr/share/php/JsonSchema/bin/validate-json" "/usr/bin/validate-json"
}
