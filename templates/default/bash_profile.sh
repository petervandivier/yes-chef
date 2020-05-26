
RED='\[\e[1;31m\]'
BOLDYELLOW='\[\e[1;33m\]'
GREEN='\[\e[0;32m\]'
BLUE='\[\e[1;34m\]'
DARKBROWN='\[\e[1;33m\]'
DARKGRAY='\[\e[1;30m\]'
CUSTOMCOLORMIX='\[\e[1;30m\]'
DARKCUSTOMCOLORMIX='\[\e[1;32m\]'
LIGHTBLUE="\[\033[1;36m\]"
PURPLE='\[\e[1;35m\]' 
NC='\[\e[0m\]' # No Color

PS1="${LIGHTBLUE}\\D{%m%d %T%z} ${PURPLE}\\u${NC}@${BOLDYELLOW}\\h${NC}:${CUSTOMCOLORMIX}\\W ${DARKCUSTOMCOLORMIX}$ ${NC}"
