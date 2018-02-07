#!/usr/bin/env nextflow

/*
vim: syntax=groovy
-*- mode: groovy;-*-
*/

params.pre_input = "/etc/passwd"

pre_input = file(params.pre_input)

/*
* The instance generated from this docker file has to check the syntax of the submitted results.
*/
process generateInput {

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file pre_input

  output:
  file test_input_bz2

  """
  bzip2 -9c $pre_input > test_input_bz2
  """

}

/*
* The instance generated from this docker file has to check the syntax of the submitted results.
*/
process checkResuls {

  container 'opeb-submission/sample-checkresults'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file test_input_bz2

  output:
  file canonical_input_gz

  """
  doValidateAndCopy.sh $test_input_bz2 canonical_input_gz
  """

}

/*
* The instance generated from this docker file knows how to extract input ids from their canonical formats.
*/
process getResultsIds {

  container 'opeb-submission/sample-getiresultsids'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file canonical_input_gz

  output:
  file input_ids_json

  """
  getResultsIds.sh $canonical_input_gz input_ids_json
  """

}

/*
* The instance generated from this docker file compute metrics based on the number of lines and words.
*/
process LineMetrics {

  container 'opeb-submission/sample-linemetrics'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file canonical_input_gz

  output:
  file metrics_linemetrics_json

  """
  metricsLineCount.sh $canonical_input_gz unusedparam metrics_linemetrics_json
  """

}

/*
* The instance generated from this docker file compute metrics based on the number of repeated words.
*/
process WordMetrics {

  container 'opeb-submission/sample-wordmetrics'

  publishDir 'nextflow_working_directory', mode: 'copy', overwrite: true

  input:
  file canonical_input_gz

  output:
  file metrics_wordmetrics_json

  """
  metricsWordDist.sh $canonical_input_gz unusedparam metrics_wordmetrics_json
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

  output:
  file metrics_consolidated_json

  """
  metricsConsolidator.sh . unusedparam metrics_consolidated_json
  """

}

