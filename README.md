# LHE Analyzer 
A package to skim LHE files and plot the kinematical variables (phi, eta, pT). It is tailored to H->ZZ->4l processes.

## Instructions 
First you need the tarball which contains all the Monte Carlo (MC) information.
These are produced from MC generators like MadGraph5, POWHEG, etc. 

Then do:
```bash
tar -xf <tarball.tar.gz>
./runcmsgrid.sh 5000 1234
```
I find that 5000 events is a good starting point to analyze the kinematics. 
You can put whatever number you want.
The 1234 is just a 4 digit random seed. Again, you can put whatever number you want.

This should create a file called *cmsgrid_final.lhe*. 

Now you can start to use my LHE_Analyzer to further process this cmsgrid_final.lhe file and make kinematic plots.
If the plots look good then you should continue on with GEN-SIM processing, PUMix, AODSIM, and MINIAODSIM. 
