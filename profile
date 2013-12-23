# ~/.profile: executed by the command interpreter for login shells.
#
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# Source .profile.local if it exists
if [ -f "$HOME/.profile.local" ] ; then
  source $HOME/.profile.local
fi

# rbenv: enable shims & autocompletion
if [ -d "$HOME/.rbenv/bin" ] ; then
  PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)";
fi
