# OpenEBench submission infrastructure

Documentation available <https://inab.github.io/opeb-submission/>

## Repository's tree view
```
.
├── diagrams
├── docs
├── sampleContainers
│   ├── CheckResults
│   ├── ConsolidateMetrics
│   ├── GetIds
│   ├── LineMetrics
│   ├── NextFlowPipeline
│   └── WordMetrics
└── scripts
    ├── sftp
    ├── tests
    └── vm
```
1. [Diagrams](#diagrams)
2. [Docs](#docs)
3. [SampleDockers](#sampledockers)
4. [Scripts](#sampledockers)
    - [SFTP](#sftp)
    - [Tests](#tests)
    - [VM](#vm)


## Diagrams
Community and User workflow diagrams in graphml format
## Docs
<https://inab.github.io/opeb-submission/>

Web page which contains all documentation about the OpeB Submission Protocol for users and communities
## SampleDockers
Docker example files to be implemented by communities
## Scripts
Script files for building and providing the different services
### SFTP
SFTP service for user submissions
### Tests
Unit tests for checking services are working correctly and the system is consistent at all moment
### VM
Virtual Machine for facilite installation, deployment and testing of all components described above
