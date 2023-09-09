# detect if this script is sourced: see http://stackoverflow.com/a/38128348/6255594
SOURCED=0

#要求source setup.sh执行脚本
if [ -n "$ZSH_EVAL_CONTEXT" ]; then 
	[[ $ZSH_EVAL_CONTEXT =~ :file$ ]] && { SOURCED=1; SOURCEDIR=$(cd $(dirname -- $0) > /dev/null && pwd -P); }
elif [ -n "$KSH_VERSION" ]; then
	[[ "$(cd $(dirname -- $0) > /dev/null && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) > /dev/null && pwd -P)/$(basename -- ${.sh.file})" ]] && { SOURCED=1; SOURCEDIR=$(cd $(dirname -- ${.sh.file}) > /dev/null && pwd -P); }
elif [ -n "$BASH_VERSION" ]; then
	[[ $0 != "$BASH_SOURCE" ]] && { SOURCED=1; SOURCEDIR=$(cd $(dirname -- $BASH_SOURCE) > /dev/null && pwd -P); }
fi

if [ $SOURCED -ne 1 ]; then
	unset SOURCED
	unset SOURCEDIR
    echo "Error: this script needs to be sourced in a supported shell" >&2
    echo "Please check that the current shell is bash, zsh or ksh and run this script as '. $0 <args>'" >&2
    return 1
fi

SCRIPTDIR=$(cd $(dirname $BASH_SOURCE) > /dev/null && pwd -P)
TOPDIR=$(cd $(dirname $BASH_SOURCE)/../../../ > /dev/null && pwd -P)

echo "METADIR: $TOPDIR"

VERSION=1.1.0
DEFAULT_MACHINE=qemuarm64
DEFAULT_BUILDDIR=./build
VERBOSE=0
DEBUG=0

function usage() {
    cat <<EOF >&2
Usage: . $SCRIPT [options] [feature [feature [... ]]]

Version: $VERSION
Compatibility: bash, zsh, ksh

Options:
   -m|--machine <machine>
      what machine to use
      default: '$DEFAULT_MACHINE'
   -b|--build <directory>
      build directory to use
      default: '$DEFAULT_BUILDDIR'
   -f|--force
      flag to force overwriting any existing configuration
      default: false
   -v|--verbose
      verbose mode
      default: false
   -d|--debug
      debug mode
      default: false
   -h|--help
      get some help

EOF
}

function info() { echo "$@" >&2; }
function infon() { echo -n "$@" >&2; }
function error() { echo "ERROR: $@" >&2; return 1; }
function verbose() { [[ $VERBOSE == 1 ]] && echo "$@" >&2; return 0; }
function debug() { [[ $DEBUG == 1 ]] && echo "DEBUG: $@" >&2; return 0;}

### default options values
MACHINE=$DEFAULT_MACHINE
BUILDDIR=$DEFAULT_BUILDDIR
SETUPSCRIPT=
FORCE=

while true; do
	case "$1" in
		-m|--machine)  MACHINE=$2; shift 2;;
		-b|--builddir) BUILDDIR=$2; shift 2;;
		-f|--force) FORCE=1; shift;;
		-v|--verbose) VERBOSE=1; shift;;
		-d|--debug) VERBOSE=1; DEBUG=1; shift;;
		-h|--help)     HELP=1; shift;;
		--)            shift; break;;
		*) error "Arguments parsing error"; return 1;;
	esac
done

[[ "$HELP" == 1 ]] && { usage; return 1; }

#. $METADIR/poky/oe-init-build-env $BUILDDIR >/dev/null
. $TOPDIR/poky/oe-init-build-env $BUILDDIR
#cp $TOPDIR/setup/configs/$MACHINE/* $BUILDDIR 

