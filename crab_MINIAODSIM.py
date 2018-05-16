from WMCore.Configuration import Configuration

import datetime, time
ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

zd_mass = '20'
number_of_jets = '0'
epsilon = '1e-2'
custom_string_for_dataset = ''
step = 'MINIAODSIM'
version = 'v3'

job_label = 'ZD_UpTo'+number_of_jets+'j_MZD'+zd_mass+'_Eps'+epsilon
mass = zd_mass

outputFileName = 'zd'+number_of_jets+'j_'+'mzd'+zd_mass+'_'+step+'.root'

#____________________________________________________________||
config = Configuration()

#____________________________________________________________||
config.section_("General")
config.General.requestName     = 'DarkPhoton_m'+mass+"_"+job_label+"_"+step+"_"+version
config.General.workArea        = 'crab_DarkPhoton_m'+mass+"_"+job_label+"_"+step+"_"+version
config.General.transferOutputs = True
config.General.transferLogs    = True

#____________________________________________________________||
config.section_("JobType")
config.JobType.pluginName                       = 'Analysis'
config.JobType.psetName                         = 'step4_MINIAODSIM_cfg.py'

#____________________________________________________________||
config.section_("Data")
config.Data.inputDBS                = 'phys03'
config.Data.inputDataset            = '/ZD_UpTo0j_MZD20_Eps1e-2/klo-PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-AODSIM-351414bbda2cdc38d49da1680cef2a3f/USER'
config.Data.splitting               = 'FileBased'
config.Data.unitsPerJob             = 1 
NJOBS                               = 500 # The number of files to be run, need to be larger than the total number of the input dataset to run the whole dataset
config.Data.totalUnits              = config.Data.unitsPerJob * NJOBS
config.Data.outLFNDirBase           = '/store/user/klo/DarkPhoton_Moriond17_MINIAODSIM/'+version+'/'
config.Data.publication             = True
config.Data.publishDBS              = 'https://cmsweb.cern.ch/dbs/prod/phys03/DBSWriter/'
config.Data.outputDatasetTag        = 'PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-'+step

#____________________________________________________________||
config.section_("Site")
config.Site.storageSite = 'T2_US_Florida'
