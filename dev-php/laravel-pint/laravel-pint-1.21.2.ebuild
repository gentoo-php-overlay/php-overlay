# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Laravel Pint is an opinionated PHP code style fixer for minimalists"
HOMEPAGE="https://github.com/laravel/pint"
SRC_URI="https://github.com/laravel/pint/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/pint-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="dev-lang/php:*"

src_install() {
	dobin ./builds/pint
}
