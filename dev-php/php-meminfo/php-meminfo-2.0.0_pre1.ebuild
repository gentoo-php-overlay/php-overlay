# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_PHP="php7-4 php8-0 php8-1 php8-2 php8-3"
PHP_EXT_NAME="meminfo"
PHP_EXT_S=${S}/extension

inherit php-ext-source-r3

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="Extension exposing memory information"
LICENSE="MIT"
SLOT="0"
IUSE="+analyzer"
SRC_URI="https://github.com/BitOne/php-meminfo/archive/v${PV}.tar.gz -> ${P}.tgz"

if [ "$(ver_cut 4-5)" = "pre1" ];
then
	SRC_URI="https://github.com/BitOne/php-meminfo.git"
	EGIT_REPO_URI="https://github.com/BitOne/php-meminfo.git"
	EGIT_COMMIT="0ab7f5a" #HEAD
	inherit git-r3
fi

RDEPEND="
        dev-lang/php:*[xml]
        analyzer? (
                dev-php/fedora-autoloader
                >=dev-php/symfony-polyfill-php80-1.27
                >=dev-php/symfony-console-5.4.11
                >=dev-php/symfony-filesystem-5.4
                >=dev-php/symfony-serializer-5.4
                >=dev-php/symfony-string-5.4
                >=dev-php/clue-graph-0.9.0
                >=dev-php/graphp-algorithms-0.8.1
                dev-php/xdebug-handler
        )
"

src_prepare() {
        # Module part
        php-ext-source-r3_src_prepare
        if ! use analyzer ;
        then
            return
        fi
        # application part
        cd $S

        mkdir analyzer/vendor

        phpab \
            --quiet \
            --output analyzer/vendor/autoload.php \
            --template fedora2 \
            --basedir analyzer/vendor \
            analyzer/composer.json \
            || die

        VENDOR_DIR="${EPREFIX}/usr/share/php"
        cat >> analyzer/vendor/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
        '${VENDOR_DIR}/Fedora/Autoloader/autoload.php',
        '${VENDOR_DIR}/Symfony/Component/ServiceContracts/autoload.php',
        '${VENDOR_DIR}/Symfony/Component/Polyfill-php80/autoload.php',
        '${VENDOR_DIR}/Symfony/Component/Console/autoload.php',
        '${VENDOR_DIR}/Symfony/Component/Filesystem/autoload.php',
        '${VENDOR_DIR}/Symfony/Component/Serializer/autoload.php',
        '${VENDOR_DIR}/Symfony/Component/String/autoload.php',
        '${VENDOR_DIR}/clue-graph/autoload.php',
        '${VENDOR_DIR}/graphp-algorithms/autoload.php',
]);
EOF

}

src_install() {
        # Module part
        php-ext-source-r3_src_install
        if ! use analyzer ;
        then
            return
        fi

        # Application part
        cd $S/

        insinto "/usr/share/${PN}"
        doins -r analyzer

        exeinto "/usr/share/${PN}/analyzer/bin"
        doexe "analyzer/bin/analyzer"
        dosym "../share/${PN}/analyzer/bin/analyzer" "/usr/bin/analyzer"
}
