# Choose any base image you prefer, like bioconda, ubuntu, alpine, etc..
# or using a multistage deployment
FROM	alpine:3.7
# Use a single LABEL (multiple ones are discouraged because each one creates a new layer)
LABEL	description="Sample input ids extractor" vendor="BSC-CNS" version="0.1" maintainer="José María Fernández <jose.m.fernandez@bsc.es>"

# First, install all the dependencies needed by the input id extraction procedure
# In this case, it installs the only program it needs
RUN	apk update && apk add coreutils


# Now, we get the input ids extraction program in some way (copying, git clone, etc...)
# which should also write the list ids, which are going to be checked later.
# It takes two parameters: input file/directory, output JSON file
# The return value tells whether the input ids extraction
# whether worked or failed
COPY	getIds.sh /usr/local/bin
ENTRYPOINT	["/usr/local/bin/getIds.sh"]
