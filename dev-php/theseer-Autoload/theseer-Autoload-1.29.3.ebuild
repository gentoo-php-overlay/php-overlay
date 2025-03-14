# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Autoload"

DESCRIPTION="PHP Autoload Builder"
HOMEPAGE="https://github.com/theseer/Autoload"
SRC_URI="https://github.com/theseer/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="dev-lang/php:*[cli,fileinfo(-),tokenizer(-)]
	>=dev-php/theseer-DirectoryScanner-1.3
	>=dev-php/zetacomponents-ConsoleTools-1.7.1"

PATCHES=( "${FILESDIR}"/${PN}-1.29.0-autoload.php.patch )

src_prepare() {
	default

	# Set version
	sed -i \
		-e "s/%development%/${PV}/" \
		phpab.php \
		composer/bin/phpab \
		|| die

	cp --target-directory src/templates/ci \
		"${FILESDIR}"/fedora.php.tpl \
		"${FILESDIR}"/fedora2.php.tpl \
		|| die

	# Mimick layout to bootstrap phpab
	mkdir --parents \
		vendor/theseer/directoryscanner \
		vendor/zetacomponents/console-tools \
		|| die

	ln -s "${EPREFIX}/usr/share/php/TheSeer/DirectoryScanner" vendor/theseer/directoryscanner/src || die
	ln -s "${EPREFIX}/usr/share/php/ezc/ConsoleTools" vendor/zetacomponents/console-tools/src  || die

	./phpab.php \
		--output src/autoload.php \
		--template "${FILESDIR}"/autoload.php.tpl \
		--basedir src \
		src || die
}

src_install() {
	insinto /usr/share/php/TheSeer/${MY_PN}
	doins -r src/*

	dobin "${S}"/composer/bin/phpab

	einstalldocs
}
