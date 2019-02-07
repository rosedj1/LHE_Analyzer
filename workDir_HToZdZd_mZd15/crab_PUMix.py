from WMCore.Configuration import Configuration

import datetime, time
ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

zd_mass = '15'
number_of_jets = '0'
epsilon = '1e-4'
custom_string_for_dataset = ''
step = 'PUMix'
version = 'v4'

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
config.JobType.pluginName                       = 'Analysis'
config.JobType.psetName                         = 'step2_PUMix_cfg.py'
config.JobType.outputFiles                      = ['zd0j_mzd15_PUMix.root',]

#____________________________________________________________||
config.section_("Data")
config.Data.inputDBS                = 'phys03'
config.Data.inputDataset            = '/ZD_UpTo0j_MZD15_Eps1e-4/klo-PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-LHE-GEN-SIM_RAWSIMoutput-fa011d18b106659d0bf0fb45743134b7/USER'
config.Data.splitting               = 'FileBased'
config.Data.unitsPerJob             = 1 # the number of events here must match the number of events in the exeternalLHEProducer
NJOBS                               = 500
config.Data.totalUnits              = config.Data.unitsPerJob * NJOBS
config.Data.outLFNDirBase           = '/store/user/klo/HToZdZd_PUMix/'+version+'/'
config.Data.publication             = True
config.Data.publishDBS              = 'https://cmsweb.cern.ch/dbs/prod/phys03/DBSWriter/'
config.Data.outputDatasetTag        = 'PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-'+step

#____________________________________________________________||
config.section_("Site")
config.Site.storageSite = 'T2_US_Florida'
