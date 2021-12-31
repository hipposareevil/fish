alias g.fetch="git fetch origin"
alias g.pull="git pull"
alias g.log="git shortlog --summary --numbered"
alias g.get.remote.tags="git ls-remote --tags origin"

function g.fork.refresh
    set curr (git branch --show-current)
    git checkout master
    git pull -p
    git fetch upstream
    git rebase upstream/master
    git push origin
    git checkout "$curr"
end

function g.master
    echo "[Checkout master, fetch, and pull]"
    git checkout master
    git fetch origin
    git pull
end


# Get commit for tag and show logs
function g.get.tag
    if $argv[1] == "-h"
        echo "Usage: $0 [git tag]"
        echo "Show git commit and history for tag"
    end

    set tag $argv[1]
    set commit (git rev-list -n 1 $tag)
    git log -p $commit    
end
