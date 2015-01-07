# ~/.profile: executed by the command interpreter for login shells.
#
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Load required lib for shell variable manipulation (inc. PATH variable)
. $HOME/.lib.sh/varmanip

if [ -f $HOME/.aliases ]; then
  . $HOME/.aliases
fi

# Mac OS X: Move /usr/local/bin to the top of PATH so it will be before /usr/bin
# This is needed for Homebrew to work properly, otherwise, system-provided programs
# will be used instead of those provided by Homebrew
# The same should also be true for /usr/local/sbin since some formulae use it
if [ "`uname`" = "Darwin" ] && which brew > /dev/null; then
  ensure_precedence_in_path /usr/local/bin /usr/bin
  immediately_precede_in_path /usr/local/sbin /usr/sbin
fi

# Linux: Add $HOME/.linuxbrew/bin to PATH if it exists
# This is needed for Linuxbrew (Homebrew for Linux) to work properly
if [ -d "$HOME/.linuxbrew/bin" ] ; then
  prepend_path $HOME/.linuxbrew/bin
  export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"
fi

# Mac OS X: If curl-ca-bundle is installed (using homebrew), then use it with OpenSSL
# This fixes a lot of openssl-related ruby issues on the Mac.
if [ "`uname`" = "Darwin" -a -d "/usr/local/opt/curl-ca-bundle" ]; then
  export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
fi

# Set PATH so it includes user's private bin and its subdirectories if they exist
prepend_path $HOME/bin
if [ -d "$HOME/bin" ] ; then
  for BIN_DIR in `find $HOME/bin/* -type 'd'`; do
    prepend_path $BIN_DIR
  done
fi

# Source .profile.local if it exists
if [ -f "$HOME/.profile.local" ] ; then
  . $HOME/.profile.local
fi

# rbenv: enable shims & autocompletion
if [ -d "$HOME/.rbenv/bin" ] ; then
  prepend_path $HOME/.rbenv/bin
  eval "$(rbenv init -)";
fi

# Mac OS X: Use PCRE for regular expressions when building things with homebrew
# For this to work, you need to install the library: brew install pcre
if [ "`uname`" = "Darwin" ]; then
  export USE_LIBPCRE=yes
fi
