# Choose any base image you prefer, like bioconda, ubuntu, alpine, etc..
# or using a multistage deployment
FROM	alpine:3.7
# Use a single LABEL (multiple ones are discouraged because each one creates a new layer)
LABEL	description="Sample metrics: number of lines and words" vendor="BSC-CNS" version="0.1" maintainer="José María Fernández <jose.m.fernandez@bsc.es>"

# First, install all the dependencies needed by the metrics computation procedure
# As this sample computes the number of lines and words of a compressed gzip, it
# installs the two packages it needs
# Bash is installed for systems like nextflow
RUN	apk add --no-cache gzip coreutils bash


# Now, we get the metrics computation program in some way (copying, git clone, etc...)
# which should also write its output in a single JSON file.
# It takes three parameters: input file/directory, directory with all the needed
# reference databases, and the output JSON file
# The return value tells whether the metrics computation whether
# worked or failed
COPY	metricsLineCount.sh /usr/local/bin
ENTRYPOINT	["/usr/local/bin/metricsLineCount.sh"]
