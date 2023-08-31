# Structure of NoteMate

NoteMate is structured on the concept of the [Open Knowledge Model (OKM)](https://jacobzelko.com/04172022033744-open-knowledge-standard/) which is an open specification that minimally prescribes the structure of notes ingested by NoteMate.
To process notes that are compliant with the OKM, NoteMate offers three main components: 

- **Input Parsing** - parsing tools for various note structures and filetypes. 

- **Intermediate Structures** - internal and external objects defined by NoteMate.

- **Target Outputs** - tools for generating an output made to a specific target.

At its core, NoteMate is a toolbox for transforming information into various outputs with a focus on personal notes.
It is designed to be flexible enough so that one can adapt personal note structures into targets supported by NoteMate while sufficiently constrained to have well-defined APIs that can be consumed in other packages or projects more readily.


