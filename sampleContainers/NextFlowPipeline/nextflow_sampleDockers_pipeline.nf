#!/usr/bin/env nextflow

/*
vim: syntax=groovy
-*- mode: groovy;-*-
*/

params.testEventId = "123abc"

/*
* Assuring the preconditions (in this case, the docker images) are in place
*/
process dockerPreconditions {

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  output:
    file docker_image_dependency

  """
  docker build -t opeb-submission/sample-getqueryids:latest $PWD/../GetQueryIds
  docker build -t opeb-submission/sample-checkresults:latest $PWD/../CheckResults
  docker build -t opeb-submission/sample-getresultsids:latest $PWD/../GetResultsIds
  docker build -t opeb-submission/sample-linemetrics:latest $PWD/../LineMetrics
  docker build -t opeb-submission/sample-wordmetrics:latest $PWD/../WordMetrics
  docker build -t opeb-submission/sample-consolidate:latest $PWD/../ConsolidateMetrics
  touch docker_image_dependency
  """

}

/*
* The instance generated from this docker file has to check the syntax of the submitted results.
*/
process generateInput {

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:

  output:
  file pre_input
  file results_bz2

  """
  curl -s -X POST https://www.lipsum.com/feed/json -d "amount=50" -d "what=paragraphs"  | tr '"' "'" > pre_input
  bzip2 -9c pre_input > results_bz2
  """

}

/*
* The instance generated from this docker file has to check the syntax of the submitted results.
*/
process checkResults {

  container 'opeb-submission/sample-checkresults'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file results_bz2
  file docker_image_dependency

  output:
  file canonical_results_gz

  """
  doValidateAndCopy.sh $results_bz2 canonical_results_gz
  """

}

/*
* The instance generated from this docker file knows how to extract query ids from the query.
*/
process getQueryIds {

  container 'opeb-submission/sample-getqueryids'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file pre_input
  file docker_image_dependency


  output:
  file query_ids_json

  """
  getQueryIds.sh ${params.testEventId} $pre_input query_ids_json
  """

}

/*
* The instance generated from this docker file knows how to extract results ids from the results canonical formats.
*/
process getResultsIds {

  container 'opeb-submission/sample-getresultsids'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file canonical_results_gz
  file docker_image_dependency

  output:
  file result_ids_json

  """
  getResultsIds.sh ${params.testEventId} $canonical_results_gz result_ids_json
  """

}

/*
* The instance generated from this docker file compute metrics based on the number of lines and words.
*/
process LineMetrics {

  container 'opeb-submission/sample-linemetrics'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file canonical_results_gz
  file docker_image_dependency

  output:
  file metrics_linemetrics_json

  """
  metricsLineCount.sh $canonical_results_gz unusedparam metrics_linemetrics_json
  """

}

/*
* The instance generated from this docker file compute metrics based on the number of repeated words.
*/
process WordMetrics {

  container 'opeb-submission/sample-wordmetrics'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file canonical_results_gz
  file docker_image_dependency

  output:
  file metrics_wordmetrics_json

  """
  metricsWordDist.sh $canonical_results_gz unusedparam metrics_wordmetrics_json
  """

}

/*
* The instance generated from this docker file computed metrics based on the results of the previous dockers.
*/
process ConsolidateMetrics {

  container 'opeb-submission/sample-consolidate'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file metrics_linemetrics_json
  file metrics_wordmetrics_json
  file docker_image_dependency

  output:
  file metrics_consolidated_json

  """
  metricsConsolidator.sh . unusedparam metrics_consolidated_json
  """

}

