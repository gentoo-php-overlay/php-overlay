# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Executes commands in sub-processes"
HOMEPAGE="https://github.com/symfony/process"
SRC_URI="https://github.com/symfony/process/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/process-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
	dev-php/fedora-autoloader
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
	"${VENDOR_DIR}/Symfony/Polyfill/Php80/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Process"
	doins -r *.php Exception Pipes
}
