# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Assertions to validate method input/output with nice error messages."
HOMEPAGE="https://github.com/webmozarts/assert"
SRC_URI="https://github.com/webmozarts/assert/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/assert-${PV}"

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
		--basedir . \
		. \
		|| die
}

src_install() {
	insinto "/usr/share/php/Webmozart/Assert"
	doins -r *.php src src/*
}
