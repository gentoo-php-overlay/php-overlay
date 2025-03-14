# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A robust cross-platform utility for normalizing, comparing and modifying file paths."
HOMEPAGE="https://github.com/webmozart/path-util"
SRC_URI="https://github.com/webmozart/path-util/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/path-util-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-5.3:*
	dev-php/fedora-autoloader
	dev-php/webmozart-assert
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
	"${VENDOR_DIR}/Webmozart/Assert/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Webmozart/PathUtil"
	doins -r *.php docs src src/* tests
}
