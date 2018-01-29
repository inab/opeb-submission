Sample Dockers for the submission infrastucture
=============================================

These sample docker files show what a community have to provide in
order to use the submission and evaluation infrastructure.

* An __input validation docker__: The instance generated from this docker file
  has to check the syntax of the submitted results. Also, if the community uses
  several formats, and one or more are declared as canonical, the input has to be
  translated to one of those canonical formats (or copied, if no translation is
  needed).

* A __input ids extraction docker__: The instance generated from this docker
  file knows how to extract input ids from their canonical formats. This step
  is needed in order to check whether the submission correlates to the query.
  This check is independent from the community, and it is done outside this docker
  instance. It generates as output file a JSON array of identifiers.

* Two __metrics computation__ dockers: The instances generated from these docker
  files compute metrics based on the content. These docker instances generate a JSON
  file which describes the metrics.

* As some consolidated metrics can be needed (like the official, main ones), which
  might depend on the results of the previous dockers, a final consolidation stage
  is also envisioned.

In order to test this proof of concept, you only have to follow next script:

1. Once you have cloned this repository, and you are in the `sampleDockers` directory,
  you have to run next commands in order to build the sample images:

  ```bash
  docker build -t opeb-submission/sample-checkinput:latest CheckInput
  docker build -t opeb-submission/sample-getids:latest GetIds
  docker build -t opeb-submission/sample-linemetrics:latest LineMetrics
  docker build -t opeb-submission/sample-wordmetrics:latest WordMetrics
  docker build -t opeb-submission/sample-consolidate:latest ConsolidateMetrics
  ```

2. Next, you have to prepare data in order to feed the pipeline. As it works with
  compressed gz or bz2 files (preferibly text ones), you can compress the text file
  you prefer:

  ```bash
  mkdir -p /tmp/input /tmp/canonical_input /tmp/metrics /tmp/consolidated_metrics
  bzip2 -9c /etc/passwd > /tmp/input/test_input.bz2
  ```

3. Check the input, obtaining it in its canonical representation (in this case, it translates from bzip2 to gzip format):

  ```bash
  docker run --rm -ti \
      -v /tmp/input:/input:ro \
      -v /tmp/canonical_input:/output \
      -u $UID \
      opeb-submission/sample-checkinput \
      /input/test_input.bz2  /output/canonical_input.gz
  ```

4. Optional, you can get the identifiers file (in this case, it is a naïve function):

  ```bash
  docker run --rm -ti \
      -v /tmp/canonical_input:/input:ro \
      -v /tmp/canonical_input:/output \
      -u $UID \
      opeb-submission/sample-getids \
      /input/canonical_input.gz /output/input_ids.json
  ```

5. Now, running the different metrics we obtain a file from each one, in JSON format. In this example, the first one counts the number of lines and words from the uncompressed content, meanwhile the second accounts for the word occurrence in the uncompressed content:

  ```bash
  docker run --rm -ti \
      -v /tmp/canonical_input:/input:ro \
      -v /tmp/metrics:/output \
      -u $UID \
      opeb-submission/sample-linemetrics \
      /input/canonical_input.gz unusedparam /output/metrics_linemetrics.json
  docker run --rm -ti \
      -v /tmp/canonical_input:/input:ro \
      -v /tmp/metrics:/output \
      -u $UID \
      opeb-submission/sample-wordmetrics \
      /input/canonical_input.gz unusedparam /output/metrics_wordmetrics.json
  ```

6. Last, running the different consolidation metrics (in this case, only one)
  we obtain a file from each methodology, in JSON format. This sample docker computes
  the relative frequency of the words, combining contents from the previously computed
  metrics:

  ```bash
  docker run --rm -ti \
      -v /tmp/metrics:/input:ro \
      -v /tmp/consolidated_metrics:/output \
      -u $UID \
      opeb-submission/sample-consolidate \
      /input unusedparam /output/metrics_consolidated.json
  ```
