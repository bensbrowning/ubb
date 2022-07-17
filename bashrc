#!/usr/bin/env bash

# ubb, a bashrc
# bits lifted unabashedly from:
#  - https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
#  - 
# Set to 1 for troubleshooting
# UBB_DEBUG=1
# 2 is obscenely verbose
# UBB_DEBUG=2

# Version
UBB_VERSION="0.1"

# Debugging
UBB_DEBUG=${UBB_DEBUG:=0}
if [[ ${UBB_DEBUG} > 1 ]]; then
    echo "UBB_DEBUG set to ${UBB_DEBUG}"
    # set -xv
    # PS4='$LINENO: '
fi

### Startup
# Set some useful user vars with defaults
UBB_SOURCE=$(readlink -f ${BASH_SOURCE})
UBB_PATH=$(dirname ${UBB_SOURCE})
UBB_LIB="${UBB_PATH}/ubb_lib"
UBB_PS1_VERBOSE=${UBB_PS1_VERBOSE:=0}

if [[ -z ${UBB_CONFIG_DIR} ]]; then
    UBB_CONFIG_DIR=${UBB_CONFIG_DIR:="${HOME}/.ubb_config"}
fi

[[ ${UBB_DEBUG} > 0 ]] && echo "ubb version ${UBB_VERSION} starting"
if [[ ${UBB_DEBUG} > 1 ]]; then
    echo "UBB_SOURCE=${UBB_SOURCE}"
    echo "UBB_PATH=${UBB_PATH}"
    echo "UBB_LIB=${UBB_LIB}"
    echo "UBB_CONFIG_DIR=${UBB_LIB}"
fi

# Load the libs
if [[ -f ${UBB_LIB} ]]; then
    source ${UBB_LIB}
else
    echo "ERROR: Can't do much without the libs (at ${UBB_LIB}), exiting in 5s"
    sleep 5
    # exit 1
    exit
fi

### Main flow
__ubb_global
[[ ${UBB_DEBUG} > 0 ]] && echo "This bash is:"
if [[ -n $PS1 ]]; then
    : # These are executed only for interactive shells
    [[ ${UBB_DEBUG} > 0 ]] && echo " interactive"
    __ubb_interactive
else
    : # Only for NON-interactive shells
    [[ ${UBB_DEBUG} > 0 ]] && echo " noninteractive"
    __ubb_noninteractive
fi

if shopt -q login_shell ; then
    : # These are executed only when it is a login shell
    [[ ${UBB_DEBUG} > 0 ]] && echo " login"
    __ubb_login
else
    : # Only when it is NOT a login shell
    [[ ${UBB_DEBUG} > 0 ]] && echo " nonlogin"
    __ubb_nonlogin
fi

export PS1=${PS1}

# turn off super debug mode
set +xv
PS4=''
###
# Anything past here added locally and should be moved to local ubb config
###