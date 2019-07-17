## For help wth this config file: https://twiki.cern.ch/twiki/bin/view/CMSPublic/CRAB3ConfigurationFile
from WMCore.Configuration import Configuration

import datetime, time
ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

zd_mass = '7'
number_of_jets = '0'
epsilon = '1e-2'
custom_string_for_dataset = ''
step = 'PUMix'
version = 'v4'

job_label = 'ZD_UpTo'+number_of_jets+'j_MZD'+zd_mass+'_Eps'+epsilon
mass = zd_mass

outputFileName = 'zd'+number_of_jets+'j_eps'+epsilon+'_mzd'+zd_mass+'_'+step+'.root'

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
config.JobType.pluginName                       = 'Analysis' ## 'Analysis' when running on existing dataset; otherwise 'PrivateMC'
config.JobType.psetName                         = 'step2_PUMix_cfg.py'
config.JobType.numCores                         = 8
config.JobType.maxMemoryMB                      = 9000  ## 9000 MB requested. Default is 2000.
config.JobType.outputFiles                      = ['zd0j_eps'+epsilon+'_mzd'+zd_mass+'_PUMix.root',]

#____________________________________________________________||
config.section_("Data")
config.Data.inputDBS                	= 'phys03'
#config.Data.inputDataset            = '/ZD_UpTo0j_MZD35_Eps1e-2/klo-PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-LHE-GEN-SIM_RAWSIMoutput-230d5e0ade3a6acf4e86f4d16aace442/USER'
## To find the correct directory, do: `crab status -d <crab_dir1/crab_dir2>'
#config.Data.inputDataset            	= '/zd0j_MZd4_eps1e-2/drosenzw-PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-LHE-GEN-SIM_RAWSIMoutput-f743e6fe77267e7b68769bffab2232d5/USER'
config.Data.inputDataset            	= '/zd0j_MZd7_eps1e-2/drosenzw-PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-LHE-GEN-SIM_RAWSIMoutput-e9fca6d885f01c7714f9a05af3927929/USER'
config.Data.allowNonValidInputDataset 	= True
config.Data.splitting               	= 'FileBased'
config.Data.unitsPerJob             	= 1000 # the number of events here must match the number of events in the exeternalLHEProducer
NJOBS                               	= 100
config.Data.totalUnits              	= config.Data.unitsPerJob * NJOBS
config.Data.outLFNDirBase           	= '/store/user/drosenzw/DarkPhoton_Moriond17_PUMix/'+version+'/'
config.Data.publication             	= True
config.Data.publishDBS              	= 'https://cmsweb.cern.ch/dbs/prod/phys03/DBSWriter/'
config.Data.outputDatasetTag        	= 'PUMoriond17-Realistic25ns13TeVEarly2017Collision-93X_mc2017_realistic_v3-'+step 

#____________________________________________________________||
config.section_("Site")
config.Site.storageSite = 'T2_US_Florida'
