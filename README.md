# dotfiles-emacs

Minimal Emacs config for Rust development and reviewing changes made by
Claude Code, via Magit. See `CHEATSHEET.md` for the full keybinding reference.

## Setup on a new machine

**1. Install Emacs 29 or newer** (built-in `eglot` requires it; this was built against 31).

```sh
# macOS
brew install emacs

# Debian/Ubuntu
sudo apt install emacs
```

**2. Clone this repo as your Emacs config directory.**

If `~/.emacs.d` doesn't already exist:

```sh
git clone https://github.com/jayeshbcodes/dotfiles-emacs.git ~/.emacs.d
```

If it does exist, back it up first (`mv ~/.emacs.d ~/.emacs.d.bak`) before cloning.

**3. Launch Emacs.** First launch auto-installs everything.

```sh
emacs -nw
```

`use-package-always-ensure` is set, so on first start Emacs contacts MELPA/GNU
ELPA and installs the 5 external packages (`magit`, `rust-mode`, `which-key`,
`company`, `markdown-mode`) automatically — no manual `package-install` needed.
This requires network access; on an offline/firewalled remote box, do this
step once with network available, or copy over the resulting `~/.emacs.d/elpa/`
directory from a machine that already has it (that directory is gitignored,
so it isn't in this repo).

**4. Install Rust + rust-analyzer** (for the Eglot/Company Rust workflow):

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer
```

That's it — Magit, the theme (`F5` to toggle), Markdown preview (`F6`), and
Rust completions/diagnostics should all be working. Run through `CHEATSHEET.md`
to verify.
