#!/bin/sh

for f in .alias .bashrc .func.win .env.win .func.win .screenrc .zshrc 
do
	ln -s ~/dotfiles/$f ~/$f
done

ln -s `pwd`/_vimrc ~/.vimrc
ln -s `pwd`/_gvimrc ~/.gvimrc
ln -s `pwd`/.vim ~/.vim

git submodule init
git submodule update

