# Brain Imaging Data Structure (BIDS)

**Date:** November 5 2020 

**Summary:** An overview of the BIDS style for Brain Imaging Data. 

**Keywords:** ##zettel #bids #neuroscience #brain #imaging #archive

## Bibliography

Not Available


## Note Linked From:

- [NeuriViz Project](10152020223819-neuriviz-project.md) - An on-going experiment into developing performant neuroscientific visualizations via Julia.

## Notes

### Purpose

A core problem regarding reproducible neuroscience is that there has been no widely adopted standard for describing data from an imaging experiment.
This renders sharing and reusing data difficult.[@gorgolewskiBrainImagingData2016]
Furthermore, it complicates automation and quality assurance.

The BIDS format was inspired by the work done by the [OpenNeuro](https://openneuro.org/) community to easily share and structure their data regarding pertaining to neuroscientific research.
It enables development of automated tools to operate on datasets. [@gorgolewskiBrainImagingData2016]
Common standards minimize curation!
Helps those not involved to effectively understand the data.

### Specific data specifications: 

- Raw data derivatives should be separate from source data.

- The NIfTI image file format was selected as it is the most ubiquitous across neuroimaging software.BIDS requires users to provide additional meta information in a sidecar JSON file.

- Metadata is generally stored as an array in tab-delimited values.

- JSON files are used for storing key/value pairs.
The key names follow a fixed dictionary in the specification.



### Topics

Neuroimaging: brain imaging to gain quantitative brain data. [@gorgolewskiBrainImagingData2016]

Error reduction: errors attributed to misunderstanding data.

Provenance: information regarding actions or those involved in producing an object.
It can be used to form assessments about its valour.

## References
