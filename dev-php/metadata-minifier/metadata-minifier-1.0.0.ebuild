# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small utility library that handles metadata minification and expansion."
HOMEPAGE="https://github.com/composer/metadata-minifier"
SRC_URI="https://github.com/composer/metadata-minifier/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/metadata-minifier-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.4:*
	dev-php/fedora-autoloader
"

src_prepare() {
	default

	phpab \
		--output autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die
}

src_install() {
	insinto "/usr/share/php/Composer/MetadataMinifier"
	doins -r *.php src/*
}
