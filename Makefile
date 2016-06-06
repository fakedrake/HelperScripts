.PHONY : zsh vimperator

all: zsh vimperator

zsh: ~/.zshrc

vimperator: ~/.vimperatorrc

~/.vimperatorrc:
	ln -s $(PWD)/vimperatorrc ~/.vimperatorrc

~/.zshrc:  ~/.oh-my-zsh
	ln -s $(PWD)/zshrc ~/.zshrc

~/.oh-my-zsh:
	curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh \
		| bash

~/.offlineimaprc: ~/.offlineimap.py
	ln -s $(PWD)/offlineimaprc ~/.offlineimaprc

~/.offlineimap.py:
	ln -s $(PWD)/offlineimap.py ~/.offlineimap.py

offlineimap-sysctl:
	echo "[Unit]
	Description=Start offlineimap as a daemon
	Requires=network.target
	After=network.target

	[Service]
	User=%i
	ExecStart=/usr/bin/offlineimap
	KillSignal=SIGUSR2
	Restart=always

	[Install]
	WantedBy=multi-user.target
	" > /etc/systemd/system/offlineimap@.service
	systemctl offlineimap enable

offlineimap-update:
	offlineimap

.PHONY:
offlineimap: ~/.offlineimaprc

.PHONY:
offlineimap-clean:
	rm -rf ~/.offlineimaprc ~/.offlineimap.py

THEME_FILE=/usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml
# This doesn't really work but you get the idea.
.PHONY:
gnome-small-maximized:
	cat  $(THEME_FILE) |awk 'BEGIN{a=0} /<frame-geometry .*name="max"/{a=1} /<\/frame_geometry>/{a=0} /name="title_vertical_pad"/{if (a==1) {gsub("value=\".*\"", "value=\"1\""); print}'

WORKSPACE_GRID_URL = https://bitbucket.org/migerh/workspace-grid-gnome-shell-extension/downloads/workspace-grid@mathematical.coffee.gmail.com-for-3.12.zip
gnome-workspace-grid:
	wget $(WORKSPACE_GRID_URL) -O /tmp/workspacegrid.zip


~/.screenrc: $(CURDIR)/screenrc
	ln -s $< $@
