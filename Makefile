all:
	stow --dotfiles -v .
	systemctl --user enable --now vim-plugins-update.timer socks-rwth.service
