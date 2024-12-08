all: stow xkb-options

stow:
	stow --dotfiles -v .
	systemctl --user enable --now vim-plugins-update.timer socks-rwth.service

xkb-options:
	dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"
