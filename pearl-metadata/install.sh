post_install() {
    # cask
    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
    # update
    pushd "$PEARL_PKGDIR"
    export PATH="/home/freakhill/.cask/bin:$PATH"
    cask install # install new emacs packages
    cask update  # update all packages
    popd
    rm -fr ~/.emacs ~/.emacs.d
    ln -s "$PEARL_PKGDIR" ~/.emacs.d
}

pre_update() {
    echo "nothing yet in pre-update..."
}

post_update() {
    cask upgrade # cask itself
    pushd "$PEARL_PKGDIR"
    cask install # installs new packages
    cask update  # updates old
    popd
}

pre_remove() {
    echo "nothing yet in pre-remove..."
}

post_remove() {
    echo "nothing yet in post-remove..."
}
