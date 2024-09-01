alias gs="git status"
alias gpp="git push origin head"
alias bpod="bundle exec pod"
alias bpi="bundle exec pod install"
alias bpiv="bundle exec pod install --verbose"
alias bfastlane="bundle exec fastlane"

alias stree="open -a Sourcetree"
alias code="open -a \"$(ls /Applications | grep -E '(Visual Studio|VS)Code')\""
alias subl="open -a \"$(ls /Applications | grep -E 'Sublime Text')\""

for child in ${0:A:h}/_*; do source "${child}"; done
unset child
