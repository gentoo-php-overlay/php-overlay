# PHP Overlay

Unofficial PHP Overlay for Gentoo Linux

## Install

Install using Eselect Repository:

    eselect repository enable php-overlay

Install using Layman:

    layman -a php-overlay

## Composer

Composer 2.11.1 and later use the official release PHAR from getcomposer.org.
The PHAR bundles Composer's PHP libraries, so these versions do not depend on
the separately packaged `dev-php` libraries or Fedora autoloader. PHP itself
continues to be managed by Portage.

Accept the testing keyword for Composer in
`/etc/portage/package.accept_keywords/composer` (replace `~amd64` with your
architecture's testing keyword):

```text
dev-php/composer ~amd64
```

If you already use the overlay's Composer keyword-list symlink, it includes
this entry and can be kept; there is no need to edit its target.

Then review and install the package:

```sh
emerge --ask --verbose --update dev-php/composer::php-overlay
composer --version
```

Use Portage to update Composer; do not use `composer self-update` for this
installation. PHP needs the `cli`, `filter`, `phar`, and `ssl` USE flags.
ZIP downloads also need PHP's `zip` extension, `unzip`, or `7zip`; `curl` and
`zlib` improve download support.

### Upgrading from the source package

The previous source package could combine overlay libraries with older Gentoo
libraries that used different autoloader paths. For example, Composer expected
`Composer/Ca-Bundle/autoload.php`, while Gentoo's `ca-bundle-1.3.1` installed
`Composer/CaBundle/autoload.php`. Unversioned dependencies allowed that
incompatible combination. The bundled PHAR avoids those system autoloaders.

There is no need to unmask the retired libraries just to run the new Composer
package. After upgrading and verifying Composer, preview dependency cleanup:

```sh
emerge --pretend --verbose --depclean
```

Review the result before removing anything: other applications may still use
the old libraries, and packages explicitly recorded in the world set remain
selected. Existing keyword entries do not install packages on their own.

The legacy source package and its keyword list are retained for existing users.
Accepting testing keywords does not override a `package.mask`; the legacy
package can still be blocked by Gentoo's retirement masks.

