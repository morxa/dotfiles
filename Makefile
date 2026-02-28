all: stow stow-user xkb-options icons

stow:
	stow --dotfiles -v .
	systemctl --user enable --now vim-plugins-update.timer #socks-rwth.service
	update-desktop-database ~/.local/share/applications

xkb-options:
	dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"

icons: stow
	for res in $$(ls -d /usr/share/icons/hicolor/??x?? | xargs -n 1 basename) ; do \
		mkdir -p ~/.local/share/icons/hicolor/$$res/apps; \
		for app in ~/.local/share/icons/hicolor/symbolic/apps/*.svg; do \
			magick -background none $$app -resize $$res ~/.local/share/icons/hicolor/$$res/apps/$$(basename $$app .svg).png; \
		done \
	done



stow-user:
	@[ -n "$(USER)" ] || (echo "USER is not set" && exit 1)
	stow --dotfiles -v user-$(USER)
