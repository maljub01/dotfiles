# ~/.profile: executed by the command interpreter for login shells.
#
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

can_be_added_to_path() {
  local can_be_added=1
  local dir=$1
  if [ -d $dir ] ; then # Only can add if directory exists
    case ":$PATH:" in
      *:$dir:*) ;; # Don't add if already added
      *) can_be_added=0;;
    esac
  fi
  return $can_be_added;
}

path_includes() {
  local dir=$1
  case ":$PATH:" in
    *:$dir:*) true;;
    *) false;;
  esac
}

# Add : to both ends of PATH to make it easier to manipulate
give_path_colons() {
  export PATH=":$PATH:"
}

# Remove : from both ends of PATH
remove_colons_from_path() {
  export PATH=${PATH/#:}
  export PATH=${PATH/%:}
}

remove_path() {
  local dir=$1
  give_path_colons
  export PATH=${PATH/:$dir:/:}
  remove_colons_from_path
}

prepend_path() {
  local dir=$1
  if can_be_added_to_path $dir; then
    export PATH="$dir:$PATH"
  fi
}

append_path() {
  local dir=$1
  if can_be_added_to_path $dir; then
    export PATH="$PATH:$dir"
  fi
}

# Add $1 right on top of $2 in $PATH (Assumes $PATH includes $2)
immediately_precede_path() {
  local dir1=$1
  local dir2=$2

  if can_be_added_to_path $dir1; then
    give_path_colons
    export PATH=${PATH/:$dir2:/:$dir1:$dir2:}
    remove_colons_from_path
  fi
}

# Ensure $1 precedes $2 in $PATH
ensure_path_precedence() {
  local dir1=$1
  local dir2=$2

  fix_path_precedence() {
    remove_path $dir1
    immediately_precede_path $dir1 $dir2
  }

  case ":$PATH:" in
    *:$dir2:*:$dir1:*) fix_path_precedence;;
    *:$dir2:$dir1:*) fix_path_precedence;;
  esac

  unset -f fix_path_precedence
}

if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

# Mac OS X: Move /usr/local/bin to the top of PATH so it will be before /usr/bin
# This is needed for Homebrew to work properly, otherwise, system-provided programs
# will be used instead of those provided by Homebrew
# The same should also be true for /usr/local/sbin since some formulae use it
if [ "`uname`" = "Darwin" ] && which brew > /dev/null; then
  ensure_path_precedence /usr/local/bin /usr/bin
  immediately_precede_path /usr/local/sbin /usr/sbin
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
  source $HOME/.profile.local
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
