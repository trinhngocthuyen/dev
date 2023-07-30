# ----- ALIASES -----------------------

alias gs="git status"
alias gpp="git push origin head"
alias bpod="bundle exec pod"
alias bpi="bundle exec pod install"
alias bfastlane="bundle exec fastlane"
alias stree="open -a Sourcetree"

if [[ -d "/Applications/Visual Studio Code.app" ]]; then
    VSCODE_APP_NAME="Visual Studio Code"
elif [[ -d "/Applications/VSCode.app" ]]; then
    VSCODE_APP_NAME="VSCode"
fi
alias code="open -a \"${VSCODE_APP_NAME}\""

function check_ports() {
	lsof -i -P -n | grep LISTEN 2> /dev/null
}

function sim_record() {
	rm -rf "$1"
	xcrun simctl io booted recordVideo "$1"
}

function git_default_branch() {
    git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
}

function switch_and_fetch() {
    local default_branch=$(git_default_branch)
    git checkout -f ${default_branch}
    git reset --hard && git clean -df
    git pull origin ${default_branch}
}

function rebase_with_upstream() {
    local default_branch=$(git_default_branch)
    git fetch origin ${default_branch}
    git rebase FETCH_HEAD
}
