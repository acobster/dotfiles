# My dotfiles.

## TODO

* audit vim config
    * color
    * syntastic
    * racket
* port vim config to Lua
* Lando?
* GNOME Dock
* Fix Keybase
* Setup environmnets:
    * Generic server
    * Plex
    * Concierge
* Fix rainbow + solarized light theme
* Consider some [themes](https://determinate.systems/posts/declarative-gnome-configuration-with-nixos)!
    * themechanger?
    * [graphite-gtk-theme](https://github.com/vinceliuice/Graphite-gtk-theme) and [graphite-cursor-theme](https://github.com/vinceliuice/Graphite-cursors)
    * [numix-solarized-gtk-theme](https://github.com/Ferdi265/numix-solarized-gtk-theme) (unmaintained)
    * [omni-gtk-theme](https://github.com/getomni/gtk) (meh)
    * [layan-gtk-theme](https://github.com/vinceliuice/Layan-gtk-theme)
    * [rose-pine-gtk-theme](https://github.com/rose-pine/gtk)
    * [colloid-gtk-theme](https://github.com/vinceliuice/Colloid-gtk-theme)
    * [dracula-icon-theme](https://github.com/m4thewz/dracula-icons)
    * [tela-circle-icon-theme](https://github.com/vinceliuice/Tela-circle-icon-theme)
    * [banana-cursor-theme](https://github.com/ful1e5/banana-cursor)
* Blur My Shell

## INCLUDED SOFTWARE

### ✅ Daily Essentials

* dotfiles
* neovim
* git
* fzf
* tmux
* silversearcher-ag
* tree
* xclip
* net-tools
* ulauncher

### λ Languages

* Java (OpenJDK 21)
* Clojure
* Babashka
* Joker
* Lua

### 🤷 Misc.

* rpi-imager
* Keybase (not working)
* VLC
* Ungoogled Chromium
* Brave
* GIMP
* Zoom
* Discord
* Zulip

**NOTE: for desktop apps on Ubuntu, you need to explicitly source `~/.profile` from a script inside `/etc/profile.d/`:**

```sh
# /etc/profile.d/nix.sh

if [ -f /home/tamayo/.profile ] ; then
  . /home/tamayo/.profile
fi
```

## TOOLING

To build the home-manager environment:

```sh
build home
```

To build the system config:

```sh
build system
```

To build a live ISO:

```sh
build iso
```

## HELPFUL LINKS

* [Generating an ISO with my entire system configuration inside it](https://www.reddit.com/r/NixOS/comments/18lixd3/generating_an_iso_with_my_entire_system/) - from Yours Truly 😘
* [Creating a NixOS live "CD"](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD)
* [Declarative GNOME configuration with NixOS](https://determinate.systems/posts/declarative-gnome-configuration-with-nixos)
* [nixpkgs legacyPackages vs import](https://discourse.nixos.org/t/using-nixpkgs-legacypackages-system-vs-import/17462)
* Inspo:
    * [dmadisetti/.dots](https://github.com/dmadisetti/.dots)
    * [nyabinary/dotfiles](https://github.com/nyabinary/dotfiles)
