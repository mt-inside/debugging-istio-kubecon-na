set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
set -o pipefail
set -o nounset
shopt -s nullglob

source 00-versions.sh

function highlight () {
    cat - | grep --color -E "$1|$"
}


set -x
