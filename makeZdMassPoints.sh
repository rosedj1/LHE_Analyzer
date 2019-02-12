#!/bin/bash
######################################################################################
## PURPOSE: For each Zd mass point for the H-->ZdZd-->4l, quickly and easily:
##              - make MadGraph cards
##              - prepare a workspace (crab_cfg.py, stepX files)
##              - generate a new gridpack (tarball)
##              - submit any CRAB process (e.g., GEN-SIM, PUMix, AOD, MiniAOD)
## SYNTAX:  ./<scriptname.sh>
## NOTES:   User needs to do: source /cvmfs/cms.cern.ch/crab3/crab.sh before running
##          this script. 
## AUTHOR:  Jake Rosenzweig
## DATE:    2019-02-09
######################################################################################

#_____________________________________________________________________________________
# User-specific Parameters
# If you change parameters here, you have to rerun makeWorkspace=1 for them to take effect

overWrite=1 # 1 = overwrite any files and directories without prompting
#zdmasslist="4 5 6 7 8 9 10 15 20 25 30 35 40 45 50 55 60"
zdmasslist="8 9 10 15 20 25 30 35 40 45 50 55 60"
epsilon=1e-2    ## epsilon can't yet contain  a decimal, e.g. 1.5e-2
kappa=1e-4
numjets=0
tarballName=HAHM_variablesw_v3_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz
nevents=1000
njobs=500
MG_Dir="/home/rosedj1/genproductionsLucien/genproductions/bin/MadGraph5_aMCatNLO"   # Path to MadGraph area
workDirBASE="/home/rosedj1/DarkZ-EvtGeneration/CMSSW_9_4_2/src/DarkZ-EvtGeneration" # Path above all workDirs
freshCMSSWpath="/home/rosedj1/CMSSW_9_4_2/src/"
storageSiteGEN='/store/user/drosenzw/HToZdZd_GEN-SIM/'
storageSitePUMix='/store/user/drosenzw/HToZdZd_PUMix/'
storageSiteAOD='/store/user/drosenzw/HToZdZd_AODSIM/'
storageSiteMiniAOD='/store/user/drosenzw/HToZdZd_MINIAODSIM/'

#_____________________________________________________________________________________
# User chooses which processes to run: 1 = run, 0 = don't run
makeCards=0         # New MadGraph cards
makeWorkspace=0     # run this each time you change above parameters
makeTarball=0       # MUST HAVE clean CMSSW environment, i.e. mustn't have cmsenv'ed!
submitGENSIM=0      # first run: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitPUMix=1       # first run: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitAOD=0         # first run: source /cvmfs/cms.cern.ch/crab3/crab.sh 
submitMiniAOD=0     # first run: source /cvmfs/cms.cern.ch/crab3/crab.sh 

#_____________________________________________________________________________________
# Automatic variables
startDir=`pwd`
maxjobs=$(( 5 * $njobs ))

#_____________________________________________________________________________________
# Create new MadGraph cards 
if [ ${makeCards} = 1 ]; then
    for zdmass in ${zdmasslist}; do

        cd ${MG_Dir}
        cardsDir=HToZdZdcards_eps${epsilon}_MZD${zdmass}

        ## Ugly regex so that epsilon has correct format for HAHM_variablesw_v3_customizecards.dat
        temp_eps=$( echo $epsilon | sed "s#^[0-9]*[^e]#&.000000#;s#.*e-#&0#" )
        temp_kappa=$( echo $kappa | sed "s#^[0-9]*[^e]#&.000000#;s#.*e-#&0#" )

        echo "Making MadGraph5 cards for mZd${zdmass} GeV in ${MG_Dir}/${cardsDir}"
        if [ -d ${cardsDir} ] && [ ${overWrite} = 0 ]; then
            echo "Directory ${cardsDir} already exists. Overwrite it? [y/n] "
            read ans
            if [ ${ans} = 'y' ]; then 
                cp -rT HToZdZdcards_MZDmass_template/ ${cardsDir}
                cd ${cardsDir}
                sed -i "s|ZDMASS|${zdmass}|g"       HAHM_variablesw_v3_customizecards.dat
                sed -i "s|EPSILON|${temp_eps}|g"    HAHM_variablesw_v3_customizecards.dat
                sed -i "s|KAPPA|${temp_kappa}|g"    HAHM_variablesw_v3_customizecards.dat
                cd ..
            else
                echo "Not creating new cards for mZd${zdmass}."
                continue
            fi
        else 
            ## Dir doesn't exist or user overwrites all. Create new cards.
            cp -rT HToZdZdcards_MZDmass_template/ ${cardsDir}
            cd ${cardsDir}
            sed -i "s|ZDMASS|${zdmass}|g"       HAHM_variablesw_v3_customizecards.dat
            sed -i "s|EPSILON|${temp_eps}|g"    HAHM_variablesw_v3_customizecards.dat
            sed -i "s|KAPPA|${temp_kappa}|g"    HAHM_variablesw_v3_customizecards.dat
            cd ..
        fi

    done
    cd ${startDir}
fi

#_____________________________________________________________________________________
# Create new workspace for each mass point - prepares crab_cfg, and stepX files.
if [ ${makeWorkspace} = 1 ]; then
    for zdmass in ${zdmasslist}; do

        cd ${workDirBASE}
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}

        echo "Making workspace: ${workDirBASE}/${workDir}"
        ## Check to see if dir already exists
        if [ -d ${workDir} ] && [ ${overWrite} = 0 ]; then
            echo "Directory ${workDirBASE}/${workDir} already exists. Overwrite it? [y/n] "
            read ans
            if [ ${ans} = 'y' ]; then 
                cp -rT workDir_HToZdZd_template/ ${workDir}
                cd ${workDir}
                ## Replace values with correct Zd mass, file paths, etc. in each file.
                for file in \
                    crab_GEN-SIM.py \
                    crab_PUMix.py \
                    crab_AODSIM.py \
                    crab_MINIAODSIM.py \
                    step1_GEN-SIM_cfg.py \
                    step2_PUMix_cfg.py \
                    step3_AODSIM_cfg.py \
                    step4_MINIAODSIM_cfg.py \
                    lhe_gen-sim_steps.sh \
                    externalLHEProducer_and_PYTHIA8_Hadronizer_cff.py; do
                    sed -i "s|ZDMASS|${zdmass}|g"                           ${file}
                    sed -i "s|NUMJETS|${numjets}|g"                         ${file}
                    sed -i "s|EPSILON|${epsilon}|g"                         ${file}
                    sed -i "s|NUMEVENTS|${nevents}|g"                       ${file}
                    sed -i "s|NUMJOBS|${njobs}|g"                           ${file}
                    sed -i "s|MAXJOBS|${maxjobs}|g"                         ${file}
                    sed -i "s|TARBALLNAME|${tarballName}|g"                 ${file}
                    sed -i "s|STORAGESITEGEN|${storageSiteGEN}|g"           ${file}
                    sed -i "s|STORAGESITEPUMIX|${storageSitePUMix}|g"       ${file}
                    sed -i "s|STORAGESITEAOD|${storageSiteAOD}|g"           ${file}
                    sed -i "s|STORAGESITEMINIAOD|${storageSiteMiniAOD}|g"   ${file}
                done

            else
                echo "Not creating ${workDir} workspace."
                continue
            fi

        else 
            ## Dir doesn't exist or user overwrites all. Create workDir.
            cp -rT workDir_HToZdZd_template/ ${workDir}
            cd ${workDir}
            ## Replace values with correct Zd mass, etc. in each file.
            for file in \
                crab_GEN-SIM.py \
                crab_PUMix.py \
                crab_AODSIM.py \
                crab_MINIAODSIM.py \
                step1_GEN-SIM_cfg.py \
                step2_PUMix_cfg.py \
                step3_AODSIM_cfg.py \
                step4_MINIAODSIM_cfg.py \
                lhe_gen-sim_steps.sh \
                externalLHEProducer_and_PYTHIA8_Hadronizer_cff.py; do
                sed -i "s|ZDMASS|${zdmass}|g"                           ${file}
                sed -i "s|NUMJETS|${numjets}|g"                         ${file}
                sed -i "s|EPSILON|${epsilon}|g"                         ${file}
                sed -i "s|NUMEVENTS|${nevents}|g"                       ${file}
                sed -i "s|NUMJOBS|${njobs}|g"                           ${file}
                sed -i "s|MAXJOBS|${maxjobs}|g"                         ${file}
                sed -i "s|TARBALLNAME|${tarballName}|g"                 ${file}
                sed -i "s|STORAGESITEGEN|${storageSiteGEN}|g"           ${file}
                sed -i "s|STORAGESITEPUMIX|${storageSitePUMix}|g"       ${file}
                sed -i "s|STORAGESITEAOD|${storageSiteAOD}|g"           ${file}
                sed -i "s|STORAGESITEMINIAOD|${storageSiteMiniAOD}|g"   ${file}
            done
        fi

    done
    cd ${startDir}
fi

#_____________________________________________________________________________________
# Generate new tarball (gridpack) for each mass point
if [ ${makeTarball} = 1 ]; then
    #echo "Running scram b clean... cleaning"
    #scram b clean
    for zdmass in ${zdmasslist}; do

        cd ${MG_Dir}
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cardsDir=HToZdZdcards_eps${epsilon}_MZD${zdmass}

        echo "Generating gridpack ${tarballName} for mZd${zdmass} GeV" 
        ## Check to see if tarball already exists in workspace 
        if [ -e ${MG_Dir}/${tarballName} ] && [ ${overWrite} = 0 ]; then
            echo "The gridpack ${tarballName} already exists in ${workDir}. Overwrite it? [y/n] "
            read ans
            if [ ${ans} = 'y' ]; then 
                if [ -d HAHM_variablesw_v3/ ];           then rm -rf HAHM_variablesw_v3/; fi
                if [ -d ${cardsDir}/HAHM_variablesw_v3/ ]; then rm -rf ${cardsDir}/HAHM_variablesw_v3/; fi
                ./mkgridpack.sh HAHM_variablesw_v3 ${cardsDir}/

                echo "Moving log files with MadGraph cards into: ${MG_Dir}/${cardsDir}"
                mv HAHM_variablesw_v3/ HAHM_variablesw_v3.log ${cardsDir}/
                ## Move tarball into workspace
                echo "Moving gridpack ${tarballName} into workspace: ${workDirBASE}/${workDir}"
                mv HAHM_variablesw_v3_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz ${workDirBASE}/${workDir}
            else
                echo "Not creating new tarball for mZd${zdmass}."
                continue
            fi

        else
            if [ -d HAHM_variablesw_v3/ ]; then rm -rf HAHM_variablesw_v3/; fi
            if [ -d ${cardsDir}/HAHM_variablesw_v3/ ]; then rm -rf ${cardsDir}/HAHM_variablesw_v3/; fi
            ./mkgridpack.sh HAHM_variablesw_v3 ${cardsDir}/

            echo "Moving log files with MadGraph cards into: ${MG_Dir}/${cardsDir}"
            mv HAHM_variablesw_v3/ HAHM_variablesw_v3.log ${cardsDir}/
            ## Move tarball into workspace
            echo "Moving gridpack ${tarballName} into workspace: ${workDirBASE}/${workDir}"
            mv HAHM_variablesw_v3_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz ${workDirBASE}/${workDir}
        fi

    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit GEN-SIM CRAB job
if [ ${submitGENSIM} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*MZD*_LHE-GEN-SIM_*
        echo "Submitting mZd${zdmass} GeV for CRAB GEN-SIM processing."
        crab submit -c crab_GEN-SIM.py
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit PUMix CRAB job
if [ ${submitPUMix} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*MZD*_PUMix_*
        # Find the dataset path from the CRAB GEN-SIM log file 
        datasetDir=$( crab status -d crab_HToZdZd_*MZD${zdmass}*_LHE-GEN-SIM_*/crab*/ | grep -E */ZD.*LHE-GEN-SIM_RAWSIM* | cut -f 4 )

        for file in crab_PUMix.py step2_PUMix_cfg.py; do
            sed -i "s|GENSIMDATASET|${datasetDir}|g" ${file}
        done

        echo "Submitting mZd${zdmass} GeV for CRAB PUMix processing."
        crab submit -c crab_PUMix.py
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit AOD CRAB job
if [ ${submitAOD} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*MZD*_AODSIM_*
        # Find the dataset path from the CRAB PUMix log file 
        datasetDir=$( crab status -d crab_HToZdZd_*MZD${zdmass}*_PUMix_*/crab*/ | grep -E */ZD.*PUMix* | cut -f 4 )
        sed -i "s|PUMIXDATASET|${datasetDir}|g" crab_AODSIM.py

        echo "Submitting mZd${zdmass} GeV for CRAB AODSIM processing."
        crab submit -c crab_AODSIM.py
    done

    cd ${startDir}
fi

#_____________________________________________________________________________________
# Submit MiniAOD CRAB job
if [ ${submitMiniAOD} = 1 ]; then
    cd ${freshCMSSWpath}
    eval `scramv1 runtime -sh` # same as cmsenv

    for zdmass in ${zdmasslist}; do
        workDir=workDir_HToZdZd_eps${epsilon}_mZd${zdmass}
        cd ${workDirBASE}/${workDir}
        rm -rf crab*MZD*_MINIAODSIM_* 
        # Find the dataset path from the CRAB AOD log file 
        datasetDir=$( crab status -d crab_HToZdZd_*MZD${zdmass}*_AOD_*/crab*/ | grep -E */ZD.*AOD* | cut -f 4 )
        sed -i "s|AODDATASET|${datasetDir}|g"           crab_MINIAODSIM.py

        echo "Submitting mZd${zdmass} GeV for CRAB MiniAODSIM processing."
        crab submit -c crab_MINIAODSIM.py
    done

    cd ${startDir}
fi
