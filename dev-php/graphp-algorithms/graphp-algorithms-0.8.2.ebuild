# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common mathematical graph algorithms implemented in PHP"
HOMEPAGE="https://github.com/graphp/algorithms"
SRC_URI="https://github.com/graphp/algorithms/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/algorithms-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-5.3:*
	dev-php/fedora-autoloader
	dev-php/clue-graph
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
	"${VENDOR_DIR}/Fhaculty/Graph/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Graphp/Algorithms"
	doins -r *.php src src/* tests
}
