#!/bin/bash
#########################################################
## PURPOSE:     Quickly move LHE files from lxplus to T2.
## SYNTAX:      ./<script.sh>
## NOTES:
## AUTHOR:      Jake Rosenzweig
## DATE:        2018-10-25
#########################################################

#voms-proxy-init -voms cms
#for zdmass in 1 2 3 4 7 10 15 20 25 30 35; do
for zdmass in 4 7 10 15 20 25 30 35; do
    #gfal-copy gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid306000/cmsgrid_final_MG5_MZd${zdmass}_15000events_lhaid306000.lhe gsiftp://cmsio.rc.ufl.edu//cms/data/store/user/drosenzw/MadGraphStudies/
    #gfal-copy gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid306000/cmsgrid_final_MG5_MZd${zdmass}_15000events_lhaid306000.lheWITHOUTcuts.root gsiftp://cmsio.rc.ufl.edu//cms/data/store/user/drosenzw/MadGraphStudies/
    #gfal-copy gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid306000/cmsgrid_final_MG5_MZd${zdmass}_15000events_lhaid306000.lheWITHcuts.root gsiftp://cmsio.rc.ufl.edu//cms/data/store/user/drosenzw/MadGraphStudies/
    gfal-copy gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid306000/outputfromZZDskimmer_MG5_mZd${zdmass}_GEN_WITHOUTcuts.txt gsiftp://cmsio.rc.ufl.edu//cms/data/store/user/drosenzw/MadGraphStudies/
    gfal-copy gridpack_HAHM_variablesw_v3_eps1e-2_MZd${zdmass}_lhaid306000/outputfromZZDskimmer_MG5_mZd${zdmass}_GEN_WITHcuts.txt gsiftp://cmsio.rc.ufl.edu//cms/data/store/user/drosenzw/MadGraphStudies/
done

