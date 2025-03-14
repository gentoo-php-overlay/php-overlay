# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Lets you find a path to the system CA bundle, and includes a fallback to the Mozilla CA bundle."
HOMEPAGE="https://github.com/composer/ca-bundle"
SRC_URI="https://github.com/composer/ca-bundle/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/ca-bundle-${PV}"

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
	insinto "/usr/share/php/Composer/CaBundle"
	doins -r *.php res src/*
}
