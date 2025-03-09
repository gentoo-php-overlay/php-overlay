# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library to validate a json schema."
HOMEPAGE="https://github.com/jsonrainbow/json-schema"
SRC_URI="https://github.com/jsonrainbow/json-schema/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/json-schema-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="
	>=dev-lang/php-7.1:*
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
	insinto "/usr/share/php/JsonSchema"
	doins -r *.php bin dist src src/JsonSchema
}
