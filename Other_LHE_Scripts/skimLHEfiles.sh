#!/bin/bash
########################################################################################################
## PURPOSE: Quickly apply ZZD_lhe.C skimming file on many different mass points from MadGraph LHE files.
## SYNTAX:  ./<script_name>
## NOTES:   Check that ZZD_lhe_template.C is in right place and has right parameters
##          e.g., that fiducial cuts are turned on: fiducial="true"
## AUTHOR:  Jake Rosenzweig
## DATE:    2018-10-14
########################################################################################################
#for lhaid in 263000 306000; do
generator="MG5"
nevents=15000

fiducial="true"
cuts="WITH"

for lhaid in 306000; do
    for zdmass in 1 2 3 4 7 10 15 20 25 30 35; do
        cp ZZD_lhe_template.C gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid${lhaid}/ZZD_lhe.C
        cd gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid${lhaid}/
        ## Prepare the LHE skimmer for the current file
        sed -i "s/ZDMASS/${zdmass}/g" ZZD_lhe.C
        sed -i "s/LHAID/${lhaid}/g" ZZD_lhe.C
        sed -i "s/FIDUCIAL/${fiducial}/g" ZZD_lhe.C
        sed -i "s/NEVENTS/${nevents}/g" ZZD_lhe.C
        ## The -q option tells ROOT to quit when done
        root -q -l ZZD_lhe.C > outputfromZZDskimmer_${generator}_mZd${zdmass}_GEN_${cuts}cuts.txt
        echo "Done processing Zdmass ${zdmass} with lhaid = ${lhaid}"
        cd ..
    done
done
