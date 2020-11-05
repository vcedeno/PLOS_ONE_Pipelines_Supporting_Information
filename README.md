# PLOS_ONE_Pipelines_Supporting_Information
_Data analysis and modeling pipelines for controlled networked social science experiments_

## User Manual
This code is included as the Supplemental Material for the paper "Data analysis and modeling pipelines for controlled networked social science experiments" in the PLOS ONE Journal.
Our contribution is to describe the design and implementation of a software system 
to automate many of the steps involved in analyzing social science experimental data, building models to capture the behavior of human subjects, and providing data to test hypotheses. 
The proposed pipeline framework consists of formal models, formal algorithms, and theoretical models as the basis for the design and implementation.
This documentation includes instructions for installing and getting started with the pipeline software.

### Prerequisite Software
Python
```
https://www.python.org/downloads/
```

### Download
```
https://github.com/vcedeno/PLOS_ONE_Pipelines_Supporting_Information
```

### Installation
The folder S1 _ Software _ Table _ 5 contains code for the third of the five pipelines described in the paper.
The property-inference-pipeline format follows the pipeline design and implementation
described in Section 7, _"Pipeline design and implementation"_. These pipelines are
composable.

* json-schema: This folder contains the pipeline configuration files and datasets. 
    - h1: Dataset for the function h1, that generates the properties for a Markovian transition matrix.
    - h2: Dataset for the function h2, that outputs a file with the properties for an adapted conditional random fields (CRF) model.
    - inputTransformation: 
   	  - datasets: Transformation data in the file h1datasets.json.
   	  - schemas: Transformation schema in the file h1schema.json. The JSON schemas control the accessing of the input files in the datasets folder.
* src: 
    - h1: Function h1 generates the properties for a Markovian transition matrix.
    - h2: Function h1outputs a file with the properties for an adapted conditional random fields (CRF) model.
    - property-inference-pipeline.py: code that runs the pipeline.
    - validateJson.py : code that check files against their JSON schema and terminate
gracefully if a verification fails.

### Invocation
The following is an example of how to invoke the function h1.
From the folder S1 _ Software _ Table _ 5 execute:
```
python property-inference-pipeline/src/property-inference-pipeline.py jsonInputPipeline/input/property-inference-pipeline.json
```

