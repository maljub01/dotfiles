# ~/.profile: executed by the command interpreter for login shells.
#
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

function can_be_added_to_path() {
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

function prepend_path() {
  local dir=$1
  if can_be_added_to_path $dir; then
    export PATH="$dir:$PATH"
  fi
}

function append_path() {
  local dir=$1
  if can_be_added_to_path $dir; then
    export PATH="$PATH:$dir"
  fi
}

if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

# Move /usr/local/bin to the top of PATH so it will be before /usr/bin
# This is needed for homebrew to work properly, otherwise,
# system-provided programs will be used instead of those
# provided by Homebrew
if [ "`uname`" = "Darwin" ] && which brew > /dev/null; then
  function fix_path_for_homebrew() {
    export PATH=":$PATH:" # Add : to both ends of PATH to make it easier to manipulate
    export PATH=${PATH/:\/usr\/local\/bin:/:} # Remove old instance of /usr/local/bin

    # Add /usr/loca/bin right on top of /usr/bin
    export PATH=${PATH/:\/usr\/bin:/:\/usr\/local\/bin:\/usr\/bin:}

    # Remove : from both ends of PATH
    export PATH=${PATH/#:/}
    export PATH=${PATH/%:/}
  }

  case ":$PATH:" in
    *:/usr/bin:*:/usr/local/bin:*) fix_path_for_homebrew;;
    *:/usr/bin:/usr/local/bin:*) fix_path_for_homebrew;;
  esac
fi

# If curl-ca-bundle is installed (using homebrew), then use it with OpenSSL
# This fixes a lot of openssl-related ruby issues on the Mac.
if [ "`uname`" = "Darwin" -a -d "/usr/local/opt/curl-ca-bundle" ]; then
  export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
fi

# Set PATH so it includes user's private bin if it exists
prepend_path $HOME/bin

# Source .profile.local if it exists
if [ -f "$HOME/.profile.local" ] ; then
  source $HOME/.profile.local
fi

# rbenv: enable shims & autocompletion
if [ -d "$HOME/.rbenv/bin" ] ; then
  prepend_path $HOME/.rbenv/bin
  eval "$(rbenv init -)";
fi

# Use PCRE for regular expressions when building things with homebrew (on OS X):
# For this to work, you need to install the library: brew install pcre
export USE_LIBPCRE=yes
