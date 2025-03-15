# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="spx"
USE_PHP="php5-4 php7-4 php8-0 php8-1 php8-2 php8-3"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_ECONF_ARGS=()
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"
PHP_EXT_NEEDED_USE="-threads"

inherit php-ext-source-r3

DESCRIPTION="A simple & straight-to-the-point PHP profiling extension with its built-in web UI"
HOMEPAGE="https://github.com/NoiseByNorthwest/php-spx"
SRC_URI="https://github.com/NoiseByNorthwest/php-spx/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"

DEPEND=">=sys-libs/zlib-1.2"
RDEPEND="${DEPEND}"

src_install() {
	php-ext-source-r3_src_install

	php-ext-source-r3_addtoinifiles ";spx.data_dir" "/tmp/spx"
	php-ext-source-r3_addtoinifiles ";spx.http_enabled" "1"
	php-ext-source-r3_addtoinifiles ";spx.http_key" ""
	php-ext-source-r3_addtoinifiles ";spx.http_ip_var" ""
	php-ext-source-r3_addtoinifiles ";spx.http_trusted_proxies" ""
	php-ext-source-r3_addtoinifiles "spx.http_ip_whitelist" "127.0.0.1,::1"
	php-ext-source-r3_addtoinifiles ";spx.http_profiling_enabled" "NULL"
	php-ext-source-r3_addtoinifiles ";spx.http_profiling_auto_start" "NULL"
	php-ext-source-r3_addtoinifiles ";spx.http_profiling_builtins" "NULL"
	php-ext-source-r3_addtoinifiles ";spx.http_profiling_sampling_period" "NULL"
	php-ext-source-r3_addtoinifiles ";spx.http_profiling_depth" "NULL"
	php-ext-source-r3_addtoinifiles ";spx.http_profiling_metrics" "NULL"
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		for file in $(php_slot_ini_files "${slot}") ; do
			php-ext-source-r3_addtoinifile "${file}" ";spx.http_ui_assets_dir" "$PHPPREFIX/share/misc/php-spx/assets/web-ui"
		done

		insinto $PHPPREFIX/share/misc/php-spx/
		doins -r assets
	done
}
