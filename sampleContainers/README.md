Sample Dockers for the submission infrastucture
=============================================

These sample docker files show what a community have to provide in
order to use the submission and evaluation infrastructure.

* A __query ids extraction docker__: The instance generated from this docker
  file knows how to extract query ids from the community accepted query formats. This step
  is needed in order to check whether the submission correlates to the query.
  This check is independent from the community, and it is done outside this docker
  instance. It generates as output file a JSON object which contains an array of identifiers.

* A __results validation docker__: The instance generated from this docker file
  has to check the syntax of the submitted results. Also, if the community uses
  several formats, and one or more are declared as canonical, the input has to be
  translated to one of those canonical formats (or copied, if no translation is
  needed).

* A __results ids extraction docker__: The instance generated from this docker
  file knows how to extract results ids from their canonical formats. This step
  is needed in order to check whether the submission correlates to the query.
  This check is independent from the community, and it is done outside this docker
  instance. It generates as output file a JSON object which contains an array of identifiers.

* Two __metrics computation__ dockers: The instances generated from these docker
  files compute metrics based on the content. These docker instances generate a JSON
  file which describes the metrics.

* As some consolidated metrics can be needed (like the official, main ones), which
  might depend on the results of the previous dockers, a final consolidation stage
  is also envisioned.

In order to test this proof of concept, you only have to follow next script:

1. Once you have cloned this repository, and you are in the `sampleContainers` directory,
  you have to run next commands in order to build the sample images:

  ```bash
  docker build -t opeb-submission/sample-getqueryids:latest GetQueryIds
  docker build -t opeb-submission/sample-checkresults:latest CheckResults
  docker build -t opeb-submission/sample-getresultsids:latest GetResultsIds
  docker build -t opeb-submission/sample-linemetrics:latest LineMetrics
  docker build -t opeb-submission/sample-wordmetrics:latest WordMetrics
  docker build -t opeb-submission/sample-consolidate:latest ConsolidateMetrics
  ```

2. Next, you have to prepare a query in order to feed the pipeline. As the results
  accepted as results by the community are compressed gz or bz2 archives from
  query files (preferibly text ones), you can generate text from <https://www.lipsum.com>,
  and then compress it:

  ```bash
  rm -rf /tmp/query /tmp/results /tmp/ids /tmp/metrics /tmp/consolidated_metrics
  mkdir -p /tmp/query /tmp/results /tmp/ids /tmp/canonical_results /tmp/metrics /tmp/consolidated_metrics
  curl -s -X POST https://www.lipsum.com/feed/json -d "amount=50" -d "what=paragraphs" | tr '"' "'" > /tmp/query/test_query.txt
  bzip2 -9c /tmp/query/test_query.txt > /tmp/results/test_results.bz2
  ```

3. Optional, you can get the query identifiers file (in this case, it computes the sha256 of the uncompressed content):

  ```bash
  docker run --rm -ti \
      -v /tmp/query:/query:ro \
      -v /tmp/ids:/ids \
      -u $UID \
      opeb-submission/sample-getqueryids \
      123abc /query/test_query.txt /ids/query_ids.json
  ```

4. Check the participant result, obtaining it in its canonical representation (in this case, it translates from bzip2 to gzip format):

  ```bash
  docker run --rm -ti \
      -v /tmp/results:/results:ro \
      -v /tmp/canonical_results:/canonical_results \
      -u $UID \
      opeb-submission/sample-checkresults \
      /results/test_results.bz2  /canonical_results/canonical_results.gz
  ```

5. Optional, you can get the results identifiers file (in this case, it computes the sha256 of the uncompressed content):

  ```bash
  docker run --rm -ti \
      -v /tmp/canonical_results:/canonical_results:ro \
      -v /tmp/ids:/ids \
      -u $UID \
      opeb-submission/sample-getresultsids \
      123abc /canonical_results/canonical_results.gz /ids/results_ids.json
  ```

6. Now, running the different metrics we obtain a file from each one, in JSON format. In this example, the first one counts the number of lines and words from the uncompressed content, meanwhile the second accounts for the word occurrence in the uncompressed content:

  ```bash
  docker run --rm -ti \
      -v /tmp/canonical_results:/canonical_results:ro \
      -v /tmp/metrics:/metrics \
      -u $UID \
      opeb-submission/sample-linemetrics \
      /canonical_results/canonical_results.gz unusedparam /metrics/metrics_linemetrics.json
  docker run --rm -ti \
      -v /tmp/canonical_results:/canonical_results:ro \
      -v /tmp/metrics:/metrics \
      -u $UID \
      opeb-submission/sample-wordmetrics \
      /canonical_results/canonical_results.gz unusedparam /metrics/metrics_wordmetrics.json
  ```

7. Last, running the different consolidation metrics (in this case, only one)
  we obtain a file from each methodology, in JSON format. This sample docker computes
  the relative frequency of the words, combining contents from the previously computed
  metrics:

  ```bash
  docker run --rm -ti \
      -v /tmp/metrics:/metrics:ro \
      -v /tmp/consolidated_metrics:/consolidated_metrics \
      -u $UID \
      opeb-submission/sample-consolidate \
      /metrics unusedparam /consolidated_metrics/metrics_consolidated.json
  ```
