# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="memprof"
USE_PHP="php7-4 php8-0 php8-1 php8-2"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_ECONF_ARGS=()
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="Memory profiler for PHP. Helps finding memory leaks in PHP scripts."
HOMEPAGE="https://github.com/arnaud-lb/php-memory-profiler"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

DEPEND="=dev-libs/judy-1.0*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
