# Choose any base image you prefer, like bioconda, ubuntu, alpine, etc..
# or using a multistage deployment
FROM	alpine:3.7
# Use a single LABEL (multiple ones are discouraged because each one creates a new layer)
LABEL	description="Sample input validator" vendor="BSC-CNS" version="0.1" maintainer="José María Fernández <jose.m.fernandez@bsc.es>"

# First, install all the dependencies needed by the input checking procedure
# As this sample checks whether the file is a valid gzip, it installs
# the three programs it needs
RUN	apk update && apk add gzip bzip2 file


# Now, we get the validation program in some way (copying, git clone, etc...)
# which should also write the input in the canonical format expected by the
# community metrics docker instances.
# It takes two parameters: input file/directory, output file/directory
# The return value tells whether the validation and the translation to
# the canonical format whether worked or failed
COPY	doValidateAndCopy.sh /usr/local/bin
ENTRYPOINT	["/usr/local/bin/doValidateAndCopy.sh"]
