development-quilombola-com
==========================

Repository for development.quilombola.com domain.

To clone this repository on a new AWS EC2 instance --

Copy the contents of the 1st script of this README.md, dump a copy into railup.bash, and execute it on your Mac.
This should create a new rails app on a EC2 instance running Ubuntu 12.04.2 LTS.

```

#!/bin/bash 
# script name : railup.bash
#
# written by: munair simpson
# inspired by: dima golub
#
# takes as arguments:
# 	- $1 : Amazon EC2 Instance URL
#	- $2 : Repository on GitHub
#
#

# Assign arguments to script variables to improve readability.
# Create a script alias for the ssh command.
#
declare instance=$1
declare repository=$2
declare xcquut='ssh -i /Users/munair/Downloads/tokyomobile.pem -l ubuntu'

# Prepare git, rvm, ruby, libpq-dev (for the pg 0.17.0 ruby interface to postgresql), postgresql and rails for ec2 instance.
#
$xcquut $instance 'sudo apt-get install -y git-core'
$xcquut $instance 'curl -L https://get.rvm.io | bash -s stable'
$xcquut $instance 'source ~/.bash_profile; source ~/.bashrc; source ~/.profile; rvm list; rvm install 2.0.0; rvm --default use 2.0.0; ruby -v'
$xcquut $instance 'sudo apt-get install -y libpq-dev'
$xcquut $instance 'LANGUAGE="ko_KR.UTF-8"; LC_ALL="C"; export LANGUAGE LC_ALL ; sudo apt-get install -y postgresql'
$xcquut $instance 'ps auwx | grep pos || pg_createcluster 9.1 main --start'
$xcquut $instance 'source ~/.bash_profile; source ~/.bashrc; source ~/.profile; echo "gem: --no-ri --no-rdoc" >> .gemrc; gem install rails --version 4.0.0; pwd'

# Next, create an SSH key and (by copy/pasting with the mouse)
# add it to Github at https://github.com/settings/ssh
#
$xcquut $instance 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa; cat ~/.ssh/id_rsa.pub'

# Now you can clone via SSH from github.
# Cloning over SSH allows you to push/pull changes.
# Use the credential helper with caching set to 1 hour to avoid
# having to repeatedly enter your username and password.
#
$xcquut $instance 'git config --global user.name "Munair Simpson"'
$xcquut $instance 'git config --global user.email "munair@gmail.com"'
$xcquut $instance 'git config --global credential.helper "cache --timeout=3600"'
if [ $repository != "" ] 
then 
  $xcquut $instance 'cd '"'$repository'"' || git clone https://github.com/munair/'"'$repository'"'.git'
else
  repository='ubuntu'
  $xcquut $instance 'source ~/.bash_profile; rails new '"'$repository'"' --database=postgresql; cd '"'$repository'"'; ls -aslF | grep '"'$repository'"' 1>/dev/null && echo "app created."'
fi

# Modify Gemfile to include:
#  activeadmin, therubyracer, less-rails, twitter-bootstrap-rails, rails_12factor (for Heroku)
#
# Install the bundle.
#
$xcquut $instance 'cd '"'$repository'"'; grep activeadmin Gemfile || echo "gem '"'activeadmin'"', github: '"'gregbell/active_admin'"'" >> Gemfile'
if ( $xcquut $instance 'cd '"'$repository'"'; grep therubyracer Gemfile' )
then
  $xcquut $instance 'cd '"'$repository'"'; grep "# gem '"'therubyracer'"'" Gemfile && cat Gemfile | sed "s/# gem '"'therubyracer'"'/gem '"'therubyracer'"'/" > gemfile && mv gemfile Gemfile'
else
  $xcquut $instance 'cd '"'$repository'"'; echo "gem '"'therubyracer'"'" >> Gemfile'
fi
$xcquut $instance 'cd '"'$repository'"'; grep less-rails Gemfile || echo "gem '"'less-rails'"'" >> Gemfile'
$xcquut $instance 'cd '"'$repository'"'; grep twitter-bootstrap-rails Gemfile || echo "gem '"'twitter-bootstrap-rails'"'" >> Gemfile'
$xcquut $instance 'cd '"'$repository'"'; grep rails_12factor Gemfile || echo "gem '"'rails_12factor'"', group: :production" >> Gemfile'
$xcquut $instance 'cd '"'$repository'"'; source ~/.bash_profile; bundle install'


```

Login to your new instance and execute setup.bash from the repository.

Email / call me for further details.
