# Choose any base image you prefer, like bioconda, ubuntu, alpine, etc..
# or using a multistage deployment
FROM	alpine:3.7
# Use a single LABEL (multiple ones are discouraged because each one creates a new layer)
LABEL	description="Sample query ids extractor" vendor="BSC-CNS" version="0.1" maintainer="José María Fernández <jose.m.fernandez@bsc.es>"

# First, install all the dependencies needed by the query ids extraction procedure
# In this case, it installs the only program it needs
# Bash is installed for systems like nextflow
RUN	apk add --no-cache coreutils bash


# Now, we get the query ids extraction program in some way (copying, git clone, etc...)
# which should also write the list ids, which are going to be checked later.
# It takes two parameters: input file/directory, output JSON file
# The return value tells whether the results ids extraction
# whether worked or failed
COPY	getQueryIds.sh /usr/local/bin
ENTRYPOINT	["/usr/local/bin/getQueryIds.sh"]
