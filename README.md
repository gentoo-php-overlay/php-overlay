# PHP Overlay

Unofficial PHP Overlay for Gentoo Linux

## Install

Install using Eselect Repository:

    eselect repository enable php-overlay

Install using Layman:

    layman -a php-overlay

## Composer

To help you with unmasking the testing marked composer packages, you might want to symlink the provided package list
from our keywords directory:
```
ln -s /var/db/repos/php-overlay/keywords/package.accept_keywords/composer /etc/portage/package.accept_keywords/composer
```

