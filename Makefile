packages:
	$(shell sh install_packages.sh)

zsh:
	$(shell curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh)
	mv ~/.zshrc ~/.zshrc.bak
	ln -s zshrc ~/.zshrc

ruby:
	$(shell curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3)
	echo ". $HOME/.rvm/scripts/rvm" >> ~/.zshrc
