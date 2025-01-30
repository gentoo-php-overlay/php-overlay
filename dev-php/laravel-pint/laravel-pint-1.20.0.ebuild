# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Laravel Pint is an opinionated PHP code style fixer for minimalists"
HOMEPAGE="https://github.com/laravel/pint"
SRC_URI="https://github.com/laravel/pint/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND=""

RDEPEND="dev-lang/php:*"

S="${WORKDIR}/pint-${PV}"

src_install() {
	dobin ./builds/pint
}
