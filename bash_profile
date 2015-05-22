isInString() {
  if [[ $1 == *"$2"* ]] && [ -n "$2" ]
  then
    return 0
  fi
  return 1
}

status() {
  # Get 'git status -s' with colors :)
  filelines=$(script -q /dev/null git status -s | cat)
  
  oldIFS="$IFS"
  IFS='
  '
  IFS=${IFS:0:1} # this is useful to format your code with tabs
  lines=( $filelines )
  IFS="$oldIFS"

  for index in "${!lines[@]}"
  do
      diplay_idex=$(($index + 1))
      echo "$diplay_idex ${lines[index]}"
  done
}

diff() {
  filelines=$(git status -s | cut -c 4-) 

  oldIFS="$IFS"
  IFS='
  '
  IFS=${IFS:0:1} # this is useful to format your code with tabs
  lines=( $filelines )
  IFS="$oldIFS"

  for index in "${!lines[@]}"
  do
    diplay_idex=$(($index + 1))
    if isInString $1 $diplay_idex 
    then
        git diff ${lines[index]}
      fi
  done
}

commit() {
  read -p "Message: " message

  git commit -m "$message"
}

add() {
  status
  read -p "Files to add: " filesToAdd
  filelines=$(git status -s | cut -c 4-) 

  oldIFS="$IFS"
  IFS='
  '
  IFS=${IFS:0:1} # this is useful to format your code with tabs
  lines=( $filelines )
  IFS="$oldIFS"

  for index in "${!lines[@]}"
  do
    diplay_idex=$(($index + 1))
    if isInString $filesToAdd $diplay_idex 
    then
        echo "$diplay_idex ${lines[index]}"
        git add ${lines[index]}
      fi
  done
}

function glog {
  num_commits=10
  if [ -n "$1" ] 
  then
    num_commits=$1
  fi

  git log -n $num_commits --graph --abbrev-commit --decorate --format=format:' %C(bold yellow)%an%C(reset) - %C(bold green)%ar%C(reset)%C(bold blue)%d%C(reset)%n''  %C(black)%s%C(reset)' --all
}

function parse_git_branch {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \(\1\)/'
}

function proml {

  local        BLUE="\[\033[0;34m\]"

# OPTIONAL - if you want to use any of these other colors:
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
# END OPTIONAL

  local     DEFAULT="\[\033[0m\]"

PS1="\W$GREEN\$(parse_git_branch)$DEFAULT> "

}

function cdi {
   echo "Going to SocialCondo iOS"
   cd; cd SocialCondoiOS
}

function cdw {
   echo "Going to SocialCondo web"
   cd; cd SocialCondoWeb
}

function cda {
   echo "Going to SocialCondo android"
   cd; cd SocialCondoAndroid
}

proml

export NVM_DIR="/Users/marcoseich/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

nvm use 0.10

alias top="top -o cpu"
alias demo="ssh 'root@162.243.91.105'"
alias prod="ssh -i ~/Documents/socialcondo/sc_key.pem ubuntu@54.232.246.181"