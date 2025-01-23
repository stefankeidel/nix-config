#/usr/bin/env zsh
set -euo pipefail

ssh-add --apple-use-keychain ~/.ssh/id_rsa

update_code() {
    local dir=$1
    cd "$dir"
    git checkout main
    git pull origin main
}

update_code ~/code/nix-config
update_code ~/code/kirkbot
update_code ~/code/accounting
update_code ~/code/resume