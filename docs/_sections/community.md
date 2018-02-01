---
layout: page
title: Community
description: Community instructions
---
## Community instructions

Communities that aim to integrate with our pipeline for benchmarking should provide
several docker images. We provide examples of these docker images using toy benchmarks,
which are available under the repository folder 'sampleDockers'.

### Community workflow activity

![community workflow activity](../img/opeb-submission/community.png)

### The Community has to provide

* An __input data validation docker__: This docker will check the syntax of the submitted 
  results from users. If the community allows input in more than one format, this docker image
  has to translate this input file to a canonical format.
  The docker image may throw an Error Condition, which is shown as 'Error Condition #1' in the
  upper graph.
  This Error Condition is thrown in case file format is not allowed or recognized,
  file is corrupted or it could not be translated to the canonical format.

  * Input: Original User Input.
  * Output: User Input in canonical format or error message.
  * Output Schema: <!--- TODO --->

* An __input ids extraction docker__: This docker will extract ids from the canonical format.
  The output of this docker should be a file in JSON format, containing a list of the extracted ids.
  Later, a check that is done outside the docker image will compare this extracted ids with the
  benchmark event ids.
  This check may throw the 'Error Condition #2' if there is no perfect match between the 
  two lists of ids. This may happen if the user has more or less ids than the benchmark
  requires, any of the ids provided by the user does not match with the event list of ids, 
  or a repeated id is provided.
  *This check is not performed by the docker container*
  
  * Input: User Input in canonical format.
  * Output: JSON list containing IDs.
  * Output Schema: <!--- TODO --->

* One or more __metrics computation dockers__ : These docker images should calculate the statistics
  based on the content. Each docker produces a statistic in JSON format. 
  
  * Input: User Input in canonical format.
  * Output: JSON file containing metric calculated.

* One __metrics consolidation docker__ : This docker image will accept all the statistics calculated
  by the previous dockers and unify them in a single JSON file. This allows to post-process them,
  allowing to calculate secondary statistics, that need previous statistics to be calculated.

  This JSON is the result of the current workflow and will be stores 
  
  * Input: JSON files containing metrics calculated.
  * Output: JSON file containing unified metrics and, if necessary, secondary metrics.
  * Output Schema: <!--- TODO --->

<!--- TODO
### How to upload the dockers
--->


