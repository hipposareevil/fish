alias dm="docker-machine"
alias d="docker"
alias dc="docker-compose"

function _d.get.header
    d ps | head -1
end

function _d.get.image.header 
    d images | head -1
end

# list docker process by grep
function d.ps -d 'docker ps with grep'
    _d.get.header

    if test (count $argv) -eq 1
        d ps | grep $argv[1] | sort -k2
    else
        d ps | grep -v "CONTAINER ID" | sort -k2
    end
end

# show disk usage
function d.disk 
    d system df -v
end


# Exec /bin/sh into the container
function d.exec
    set -l options "h/help" 
    argparse $options -- $argv

    # help
    if set -q _flag_help || test (count $argv) -eq 0
        echo "Usage: $0 [filter]"
        echo "Exec into first container that matches the filter"
        echo ""
        return 0
    end

    set -l filter $argv[1]
    set container (docker ps | grep $filter| head -1 | awk '{print $1}')
    echo "Execing into container '$container'"
    docker exec -it "$container" /bin/bash
end


# get stats
function d.stats 
    set -l result = (d ps | grep -v "NAMES" | awk '{ print $NF }'| tr "\n" " ")
    d stats "$result" 
end


# list images in your local docker. Provide a name and it will be grepped for.
# The filtering is done across all fields returned from 'docker images'
# 
# This returns the images sorted.
# example: d.images http
function d.images
    if test (count $argv) -eq 1
        _d.get.image.header
        d images | grep $argv[1] | sort
    else
        d images | grep -v REPOSITORY | sort
    end
end


########## Remove containers


# remove container by name
function d.rm.by.name 
    set name $argv[1]
    d.ps $name | grep -v "CONTAINER ID" | awk '{print $1}' | xargs -I % docker rm -f %
end

# remove old containers that have exited 
function d.rm.old 
    echo "--- Removing old containers ---"
    set result = (d ps -af status=exited | grep -v data | grep -v CONTAINER | awk '{print $1}')
    d rm "$result"
end

# remove old containers that have just been created
function d.rm.created 
    echo "--- Removing created containers ---"
    result = (d ps -af status=created | grep -v data | grep -v CONTAINER | awk '{print $1}')
    d rm "$result"
end

########## Remove images


# Remove images by tag.
# This will remove all images that match the incoming param against the tag, but not the name
function d.rmi.by.tag
    set tag $argv[1]

    # get images, removing the header,
    # use awk to grep on the 2nd column (the tag), print the name, then remove name:tag
    d images \
        | grep -v REPOSI \
        | awk -v awkname=$tag '$2 ~ awkname' \
        | awk '{print $1}' \
        | xargs -I % docker rmi %:$tag
end

# Remove images by name. This will remove all images that match the incoming param against the name, but not the tag
function d.rmi.by.name
    set name $argv[1]

    # get images, removing the header, use awk to grep on the 1st column (the name), print the name:tag, then remove it
    d images \
        | grep -v REPOSI \
        | awk -v awkname=$name '$1 ~ awkname' \
        | awk '{print $1":"$2}' \
        | xargs -I % docker rmi %
end


# remove old images (dangling=true)
function d.rmi.old 
    echo "--- Removing unused images ---"
    d rmi (docker images --filter "dangling=true" -q --no-trunc)
end

# remove untagged images
function d.rmi.untagged 
    echo "--- Removing untagged images ---"
    d rmi (d images | grep "^<none>" | awk "{print $3}")
end

# remove old volumes
function d.rm.volume 
    echo "--- Removing old volumes ---"
    d volume rm (docker volume ls -qf dangling=true)
end

function d.wpff
    unproxy
    export DOCKER_TLS_VERIFY=1
    export DOCKER_HOST=tcp://willprogramforfood.com:2376
    export DOCKER_CERT_PATH=~/.docker/wpff/
    export DOCKER_MACHINE_NAME=default
end

# list tags for a given image from the tahoma repo
function d.wpff.tags 
   set where "willprogramforfood.com"
   set what $argv[1]
   echo "Getting tags for '$what' from '$where:5000'"
   curl -s -q -k -X GET "https://$where:5000/v2/$what/tags/list" | python -mjson.tool
end


function d.wpff.repo 
    set where "willprogramforfood.com"
    echo "Getting image list from '$where:5000'"
    curl -s -q -k -X GET https://$where:5000/v2/_catalog  | python -mjson.tool
end

function d.local 
    unset DOCKER_HOST
    unset DOCKER_CERT_PATH
    unset DOCKER_MACHINE_NAME
    unset DOCKER_TLS_VERIFY
end



