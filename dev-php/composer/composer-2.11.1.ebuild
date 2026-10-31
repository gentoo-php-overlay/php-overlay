# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Dependency manager for PHP"
HOMEPAGE="https://getcomposer.org/ https://github.com/composer/composer"
SRC_URI="https://getcomposer.org/download/${PV}/composer.phar -> ${P}.phar"
S="${WORKDIR}"

# The upstream PHAR includes its PHP libraries and Mozilla's CA bundle.
LICENSE="MIT BSD MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# hash and json are built into current PHP versions; older versions have USE flags.
RDEPEND=">=dev-lang/php-7.2.5:*[cli,filter,hash(+),json(+),phar,ssl]"

src_unpack() {
	# Keep the upstream PHAR intact.
	:
}

src_install() {
	insinto /usr/share/composer
	newins "${DISTDIR}/${P}.phar" composer.phar

	cat > "${T}/composer" <<-EOF || die "Failed to create Composer launcher"
		#!/bin/sh
		exec php "${EPREFIX}/usr/share/composer/composer.phar" "\$@"
	EOF
	dobin "${T}/composer"
}

pkg_postinst() {
	optfeature "parallel HTTP downloads" "dev-lang/php[curl]"
	optfeature "gzip-compressed HTTP responses" "dev-lang/php[zlib]"
	optfeature "ZIP archive extraction" "dev-lang/php[zip]" app-arch/unzip app-arch/7zip
	optfeature "Git repository support" dev-vcs/git

	elog "Update this installation through Portage, not 'composer self-update'."
}
