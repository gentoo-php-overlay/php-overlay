# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple unix signal handler that silently fails where signals are not supported for easy cross-platform development"
HOMEPAGE="https://github.com/Seldaek/signal-handler"
SRC_URI="https://github.com/Seldaek/signal-handler/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/signal-handler-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.2:*
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
	insinto "/usr/share/php/Seld/Signal"
	doins -r *.php src src/*
}
