# SpectraMaking

The files in this repo which are the most used for me right now are 

## Getting data
- bestIterateAllShells
  - This file allows you to run simulations necessary for simulating many spectra
  - Called by BI_Den_1_Part5.sl and files like that
  - This is a version which saves output from *every* shell, not summarizing over shells
- makeASSlurms.sh and makeASMLFiles.sh
  - These are used to create a bunch of files which can then be run using **runAll.sh**. They need initial files in the format of BI_Den_1_Part5.sl and BI_Den_1_Part5.m, with density 0p1. You would have to create those yourself. 
- checkMissingRuns.sh
  - After running a bunch of simulations, you can run this to re-run any quantum numbers that were missed because of timeout
## Making Spectra
- concatenateDataWithFewerTimes
  - This file is useful for changing the format of of the output from bestIterateAllShells. It requires that you pick which shell you care about using the whichShell parameter
- altMultiSimReader
  - Turns output from concatenateDataWithFewerTimes into spectra
## Helpers 
- binarySearch
  -This is a helper function used by multiple scripts in this repo
## Other
- shellCrossSection
  - Creates a cross section plot based on the output of bestIterateAllShells
