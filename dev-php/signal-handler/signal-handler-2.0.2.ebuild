# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple unix signal handler that silently fails on windows for easy cross-platform development"
HOMEPAGE="https://github.com/Seldaek/signal-handler"
SRC_URI="https://github.com/Seldaek/signal-handler/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"

src_prepare() {
	default

	phpab \
		--quiet \
		--output src/autoload.php \
		--template fedora2 \
		--basedir src/ \
		src \
		|| die
}

src_install() {
	insinto "/usr/share/php/Seld/SignalHandler"
	doins -r src/.

	einstalldocs
}
