# ~/.profile: executed by the command interpreter for login shells.
#
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

if [ -d "/usr/lib/jvm/java-1.6.0-openjdk/jre" ] ; then
  export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk/jre
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.keymaps" -a -z $DISPLAY ] ; then
  # Load keymaps (ie. making Caps an extra Ctrl) when in a virtual terminal
  sudo loadkeys $HOME/.keymaps/*.map > /dev/null
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
