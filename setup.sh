# variables
export MIKU="Hatsune Miku"
export DOWNLOADS="$HOME/Downloads"
export CODE="$DOWNLOADS/code/kickoff"
export EVAL="$DOWNLOADS/code/kickoff_ev"
export PRG="$HOME/exec"
export PDF="$DOWNLOADS/pdf"

export BOT="$DOWNLOADS/code/42hackathon2023"

PATH="\
$HOME/Desktop/Visual Studio Code.app/Contents/Resources/app/bin:\
$PATH:\
$PRG:\
$PRG/mongobin:\
"

# alias
alias update="source $HOME/.zshenv"
alias gimp="open ~/Desktop/gimp.app/"
alias setup="code $PRG/setup.sh"
alias prg="code $PRG"

# python
alias venv="source venv/bin/activate"
alias pyrun="python -m"
export PPY="$CODE/../piscine_python"

# exgo
alias exgo="source $PRG/exnext.sh"
alias this="exgo +0"
alias next="exgo +1"
alias prev="exgo -1"
alias back="code -r .."

# updatemake
alias updatecppmake="updatemake.sh cppmakefile.sh"

# ANSI colour code
export Reset='\033[0m'
export Bold='\033[1m'
export Underline='\033[4m'
export Blinking='\033[5m'
export Inverse='\033[7m'
export Black='\033[30m'
export Red='\033[31m'
export Green='\033[32m'
export Yellow='\033[33m'
export Blue='\033[34m'
export Magenta='\033[35m'
export Cyan='\033[36m'
export White='\033[37m'
export B_Black='\033[40m'
export B_Red='\033[41m'
export B_Green='\033[42m'
export B_Yellow='\033[43m'
export B_Blue='\033[44m'
export B_Magenta='\033[45m'
export B_Cyan='\033[46m'
export B_White='\033[47m'

# function similarly to include, assuming this file has only function

source "$PRG/lib/libbash.sh"
source "$PRG/lib/utils.sh"
source "$PRG/lib/searcher.sh"
