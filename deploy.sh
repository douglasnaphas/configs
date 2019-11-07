#!/usr/bin/env bash

FILES=(.bashrc .bash_profile .screenrc .vimrc .tmux.conf .ssh/rc .zshrc)

if [[ ! -d ~ ]]
then
	echo "no ~ directory, exiting"
	exit 1
fi

[[ -d ~/.vim/autoload ]] || mkdir -p ~/.vim/autoload
[[ -d ~/.vim/bundle ]] || mkdir -p ~/.vim/bundle
[[ -e ~/.vim/autoload/pathogen.vim ]] || \
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

for f in ${FILES[@]}
do
	[[ -e ${f} ]] || continue
	if [[ -e ~/${f} ]]
	then
		diff ${f} ~/${f} &>/dev/null && continue
		[[ -d /tmp ]] && cp ~/${f} /tmp/${f//\//.}.bk
	fi
	cp ${f} ~/${f} && echo "deployed ${f}"
done

exit 0
