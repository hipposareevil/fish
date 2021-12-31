function b2 -d "run b2 docker image"
    docker run --rm -v $PWD:/scratch \
	-e KEY_ID=000ad0ec9f486e90000000001 \
	-e APPLICATION_KEY=K0002kl3Wk/3wd0MmqoMMFGnAYbESO4 \
	hipposareevil/b2 "$argv"
end
