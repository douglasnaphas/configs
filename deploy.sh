#!/bin/bash

FILES=(.bashrc .bash_profile .screenrc .vimrc .tmux.conf .ssh/rc .gitignore)

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

KUBE_PS1_FILE=/usr/local/opt/kube-ps1/share/kube-ps1.sh
if [[ ! -e ${KUBE_PS1_FILE} ]]
then
	echo "WARNING:"
	echo "${KUBE_PS1_FILE} does not exist, is kube_ps1 installed?"
	echo "kube_ps1 prints useful info about the active Kubernetes cluster"
	echo "and namespace, like (⎈ |minikube:default). If you want that in"
	echo "your prompt, install kube_ps1 and run deploy.sh again."
	echo "See https://github.com/jonmosco/kube-ps1."
fi

exit 0
