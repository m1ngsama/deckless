# Maintainer: m1ngsama <contact@m1ng.space>

pkgname=deckless-git
pkgver=0.1.0.r0.g089aa68
pkgrel=1
pkgdesc='Keep official Steam intact while fixing proxy split, Big Picture rendering, and i3 couch-mode handoff on Linux'
arch=('any')
url='https://github.com/m1ngsama/deckless'
license=('GPL-3.0-or-later')
depends=('bash' 'jq' 'steam')
makedepends=('git')
optdepends=(
  'gamescope: run Big Picture inside gamescope'
  'gamemode: enable gamemode for Big Picture sessions'
  'i3-wm: enable fullscreen handoff between Big Picture and launched games'
)
provides=('deckless')
conflicts=('deckless')
source=('git+https://github.com/m1ngsama/deckless.git')
sha256sums=('SKIP')

pkgver() {
  cd deckless
  git describe --long --tags --abbrev=7 | sed 's/^v//; s/-/.r/; s/-/./'
}

package() {
  cd deckless

  install -d "${pkgdir}/usr/share/deckless"
  cp -a \
    LICENSE \
    README.md \
    CHANGELOG.md \
    CONTRIBUTING.md \
    install.sh \
    uninstall.sh \
    bin \
    config \
    docs \
    "${pkgdir}/usr/share/deckless/"

  install -Dm755 /dev/stdin "${pkgdir}/usr/bin/deckless-install" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

exec /usr/share/deckless/install.sh "$@"
EOF

  install -Dm755 /dev/stdin "${pkgdir}/usr/bin/deckless-uninstall" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

exec /usr/share/deckless/uninstall.sh "$@"
EOF
}
