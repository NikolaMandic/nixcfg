#!/usr/bin/env bash

NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/root
nixprofile=$NIX_USER_PROFILE_DIR/homeEnv

export PATH="$nixprofile/bin"
export LD_LIBRARY_PATH="$nixprofile/lib"
export NIX_LDFLAGS="-L$nixprofile/lib -L$nixprofile/lib/pkgconfig"
export NIX_CFLAGS_COMPILE="-I$nixprofile/include -I$nixprofile/include/sasl"
export PKG_CONFIG_PATH="$nixprofile/lib/pkgconfig"
export PYTHONPATH="$nixprofile/lib/python2.7/site-packages"
export PS1="py27 $PS1"

export INCLUDE="$nixprofile/include:$INCLUDE"
export LIB="$nixprofile/lib:$LIB"
export C_INCLUDE_PATH="$nixprofile/include:$C_INCLUDE_PATH"
export LD_RUN_PATH="$nixprofile/lib:$LD_RUN_PATH"
export LIBRARY_PATH="$nixprofile/lib:$LIBRARY_PATH"
export CFLAGS=$NIX_CFLAGS_COMPILE
export LDFLAGS=$NIX_LDFLAGS

"$@"
