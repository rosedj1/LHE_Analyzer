from WMCore.Configuration import Configuration

import datetime, time
ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

zd_mass = '15'
number_of_jets = '0'
epsilon = '1e-4'
custom_string_for_dataset = ''
step = 'LHE-GEN-SIM'
version = 'v1'

job_label = 'ZD_UpTo'+number_of_jets+'j_MZD'+zd_mass+'_Eps'+epsilon
mass = zd_mass

outputFileName = 'zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'.root'

#____________________________________________________________||
config = Configuration()

#____________________________________________________________||
config.section_("General")
config.General.requestName     = 'HToZdZd_m'+mass+"_"+job_label+"_"+step+"_"+version
config.General.workArea        = 'crab_HToZdZd_m'+mass+"_"+job_label+"_"+step+"_"+version
config.General.transferOutputs = True
config.General.transferLogs    = True

#____________________________________________________________||
config.section_("JobType")
config.JobType.pluginName                       = 'PrivateMC'
config.JobType.psetName                         = 'step1_GEN-SIM_cfg.py' # dummy PSet 
config.JobType.inputFiles                       = ['externalLHEProducer_and_PYTHIA8_Hadronizer_cff.py','../HToZdZd_gridpack/HAHM_variablesw_v3_MZd'+zd_mass+'.tar.xz']
config.JobType.numCores                         = 8
config.JobType.scriptExe                        = 'lhe_gen-sim_steps.sh'
config.JobType.disableAutomaticOutputCollection = True
config.JobType.outputFiles                      = ['zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'.root','zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'_inLHE.root']

#____________________________________________________________||
config.section_("Data")
config.Data.outputPrimaryDataset    = job_label 
config.Data.inputDBS                = 'global'
config.Data.splitting               = 'EventBased'
config.Data.unitsPerJob             = 500 # the number of events here must match the number of events in the exeternalLHEProducer
NJOBS                               = 100
config.Data.totalUnits              = config.Data.unitsPerJob * NJOBS
config.Data.outLFNDirBase           = '/store/user/klo/HToZdZd_GEN-SIM/'+version+'/'
config.Data.publication             = True
config.Data.publishDBS              = 'https://cmsweb.cern.ch/dbs/prod/phys03/DBSWriter/'
config.Data.outputDatasetTag        = 'PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-'+step

#____________________________________________________________||
config.section_("Site")
config.Site.storageSite = 'T2_US_Florida'
