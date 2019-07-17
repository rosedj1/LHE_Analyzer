#!/bin/bash
##############################################################################
## PURPOSE: Copy LHE skim files, modify each for different Zdark mass points, 
##          move the already-made tarballs into Heshy's directory, and process
##          each cmsgrid_final.lhe file using a modified ZZD_lhe.C script
## SYNTAX:  ./<script_name>
## AUTHOR:  Jake Rosenzweig
## DATE:    2018-09-21
##############################################################################
#for lhaid in 263000 306000; do
for lhaid in 306000; do
    #for zdmass in 1 2 3 4 7 8 10 15 16 20 25 30 32 35; do
    for zdmass in 1; do
        cp ./LHEskimmer/* gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid${lhaid}
        cd gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid${lhaid}/
        ## Real quick, just move the tarballs into Heshy's directory
        cp HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid${lhaid}.tar.xz ../GRIDPACKSFORHESHY/
        ## Prepare the LHE skimmer for the current file
        sed -i "s/ZDMASS/${zdmass}/" ZZD_lhe.C
        sed -i "s/LHAID/${lhaid}/" ZZD_lhe.C
        ## The -q option tells ROOT to quit when done
        root -q -l ZZD_lhe.C > outputZZD_lhe_MZd${zdmass}_lhaid${lhaid}.txt
        echo "Done processing Zdmass ${zdmass} with lhaid = ${lhaid}"
        cd ..
    done
done
