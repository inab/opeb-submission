# Choose any base image you prefer, like bioconda, ubuntu, alpine, etc..
# or using a multistage deployment
FROM	alpine:3.7
# Use a single LABEL (multiple ones are discouraged because each one creates a new layer)
LABEL	description="Sample consolidation metrics" vendor="BSC-CNS" version="0.1" maintainer="José María Fernández <jose.m.fernandez@bsc.es>"

# First, install all the dependencies needed by the metrics computation procedure
# As this sample computes the number of lines and words of a compressed gzip, it
# installs the two packages it needs
# Bash is installed for systems like nextflow
RUN	apk add --no-cache jq bash


# Now, we get the metrics computation program in some way (copying, git clone, etc...)
# which should also write its output in a single JSON file.
# It takes three parameters: input directory with all the JSON metrics, directory with
# all the needed reference databases, and the output consolidated JSON file
# The return value tells whether the metrics consolidation whether
# worked or failed
COPY	metricsConsolidator.sh /usr/local/bin
ENTRYPOINT	["/usr/local/bin/metricsConsolidator.sh"]
