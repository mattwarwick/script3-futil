#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-12-01
# Figures out a suitable unique tempname 

if [ -z $TMPNAME_SH ]; then

TMPNAME_SH="tmpname.sh"

function tmpname() {
	if [ $# -eq 0 ]; then
		echo "$(getvar VAR_MAINDIR)/$(getvar VAR_SUBDIR)/$(getvar VAR_FULL_TMPNAME_BASE)"
	else
		echo "$(getvar VAR_MAINDIR)/$(getvar VAR_SUBDIR)/$(getvar VAR_FULL_TMPNAME_BASE)_$@"
	fi
}

function tmpname_cleanup() {
	rm  $(getvar VAR_MAINDIR)/$(getvar VAR_SUBDIR)/$(getvar VAR_FULL_TMPNAME_BASE)*
}

function tmpname_init() {
	mkdir -p "$(getvar VAR_MAINDIR)/$(getvar VAR_SUBDIR)"
}

#Note: UI included even if included. This is not recommended practice in s3
TMPNAME_SH_INFO=${TMPNAME_SH}
source .futil.ui..tmpname.sh

if [ "X$(getvar VAR_AUTOINIT)" == "Xyes" ]; then
	tmpname_init
fi

source s3.ebasename.sh
if [ "$TMPNAME_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	shift $(($OPTIND - 1))

	tty -s; ATTY="$?"
	ISATTY="$ATTY -eq 0"

	set -e
	set -u

	tmpname "$@"
	exit $?
fi

fi

