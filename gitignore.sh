#!/bin/bash
sudo echo '*.pyc' > $HOME/git_ignore.txt
sudo echo '*~' >> $HOME/git_ignore.txt
git config --global core.excludesfile $HOME/git_ignore.txt
