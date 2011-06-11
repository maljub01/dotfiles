# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

source ~/.aliases

if [ -d "/usr/lib/jvm/java-1.6.0-openjdk/jre" ] ; then
  export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk/jre
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# jruby settings
if [ -d "$HOME/workspace/jruby-1.6.0" ] ; then
  export PATH=$PATH:$HOME/workspace/jruby-1.6.0/bin
fi

# apache ant settings
if [ -d "$HOME/workspace/apache-ant-1.8.1" ] ; then
  export ANT_HOME=$HOME/workspace/apache-ant-1.8.1
  export PATH=$PATH:$ANT_HOME/bin
fi

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

