#!/bin/sh

for f in .alias .bashrc .func.win .env.win .func.win .screenrc .zshrc 
do
	ln -s ~/dotfiles/$f ~/$f
done

