# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A robust cross-platform utility for normalizing, comparing and modifying file paths."
HOMEPAGE="https://github.com/webmozart/path-util"
SRC_URI="https://github.com/webmozart/path-util/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/assert"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die

	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/Webmozart/Assert/autoload.php',
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Webmozart/PathUtil"
	doins -r autoload.php src/*
}
