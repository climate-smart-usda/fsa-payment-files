# US Department of Agriculture Farm Service Agency Farm Payment Files, 2004–2024

This repository is an archive of the US Department of Agriculture Farm Service Agency (FSA) [Farm Payment Files](https://www.fsa.usda.gov/tools/informational/freedom-information-act-foia/electronic-reading-room/frequently-requested/payment-files). FSA maintains records on payments made to agricultural program participants in electronic form. In response to public interest in this data, FSA makes it available on a public website and via a Freedom of Information Act (FOIA) request. Data on the website are available as multiple Microsoft Excel files per year, which are large and tedious to process. The script in this repository automates the process of downloading the data and appending them into a single large dataset, then writing the data as a partitioned Parquet dataset, which facilitates efficient analysis.

Data were downloaded from the [FSA Farm Payment Files website](https://www.fsa.usda.gov/tools/informational/freedom-information-act-foia/electronic-reading-room/frequently-requested/payment-files) and ingested into the [R statistical framework](https://www.r-project.org), were cleaned to a common set of fields, and then were written to a partitioned Parquet dataset available in the [`fsa-payment-files`](/fsa-payment-files) directory. [`fsa-payment-files.R`](/fsa-payment-files.R) is the R script that cleans the data and produces the Parquet dataset. The FSA uses slightly different county or county equivalent definitions for their service areas than the standard ANSI FIPS areas used by the US Census. Geospatial definitions of the FSA counties are included in the [`FSA_Counties_dd17.gdb.zip`](/FSA_Counties_dd17.gdb.zip) dataset; FSA county codes are detailed in [FSA Handbook 1-CM](https://www.fsa.usda.gov/Internet/FSA_File/1-cm_r03_a80.pdf), Exhibit 101. The [`fsa-payment-files`](/fsa-payment-files) directory is also uploaded to a public Amazon AWS S3 bucket for ease of access.

The [FSA Farm Payment Files](https://www.fsa.usda.gov/tools/informational/freedom-information-act-foia/electronic-reading-room/frequently-requested/payment-files) were produced by the USDA Farm Service Agency and are in the Public Domain. Data in the [`fsa-payment-files`](/fsa-payment-files) directory were derived from the FSA Farm Payment Files by R. Kyle Bocinsky and are released under the [Creative Commons CCZero license](https://creativecommons.org/publicdomain/zero/1.0/). The [`fsa-payment-files.R`](/fsa-payment-files.R) script is copyright R. Kyle Bocinsky, and is released under the [MIT License](/LICENSE.md).

This work was supported by grants from the National Oceanic and Atmospheric Administration, [National Integrated Drought Information System](https://www.drought.gov) (University Corporation for Atmospheric Research subaward SUBAWD000858), and by US Department of Agriculture Office of the Chief Economist (OCE), Office of Energy and Environmental Policy (OEEP) funds passed through to Research, Education, and Economics mission area (award 58-3070-3-016).

Please contact Kyle Bocinsky ([kyle.bocinsky@umontana.edu](mailto:kyle.bocinsky@umontana.edu)) with any questions.

<br>
<p align="center">
<a href="https://climate.umt.edu" target="_blank">
<img src="https://climate.umt.edu/assets/images/MCO_logo_icon_only.png" width="350" alt="The Montana Climate Office logo.">
</a>
</p>

