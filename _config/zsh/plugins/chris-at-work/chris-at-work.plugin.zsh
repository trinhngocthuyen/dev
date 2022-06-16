# ----- ALIASES -----------------------
alias gs="git status"
alias gpp="git push origin head"
alias bpod="bundle exec pod"
alias bpi="bundle exec pod install"
alias vscode="open -a VSCode"
alias stree="open -a Sourcetree"

function check_ports() {
	lsof -i -P -n | grep LISTEN 2> /dev/null
}

function sim_record() {
	rm -rf "$1"
	xcrun simctl io booted recordVideo "$1"
}
