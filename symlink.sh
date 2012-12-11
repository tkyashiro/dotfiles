#!/bin/sh

for f in .alias .func.win .env.win .func.win .screenrc .zshrc 
do
	ln -s ~/dotfiles/$f ~/$f
done

