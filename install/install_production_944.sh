export SCRAM_ARCH=slc6_amd64_gcc630
cmsrel CMSSW_9_4_4
cd CMSSW_9_4_4/src/
cmsenv
git cms-init
git remote add matthieu https://github.com/mmarionncern/cmg-cmssw.git -f -t heppy_94X_2018 
scp vischia@lxplus.cern.ch:/afs/cern.ch/user/c/cmgtools/public/sparse-checkout_80X_heppy .git/info/sparse-checkout
git checkout -b heppy_94X_2018 matthieu/heppy_94X_2018
git clone -o matthieu https://github.com/mmarionncern/cmgtools-lite.git -b 94X_dev_2018 CMGTools
# This scram you can even stop it and kill it straight away. It is just to create the external/$SCRAM_ARCH directory
scram b -j50
echo /RecoEgamma/EgammaTools/ >> .git/info/sparse-checkout
git read-tree -mu HEAD
git remote add cmssw-guitargeek https://github.com/guitargeek/cmssw.git -f -t ElectronID_MVA2017_940pre3
git format-patch --stdout 2efa972169e..64030f65aa2 | git apply -
cd $CMSSW_BASE/external/slc6_amd64_gcc630
git clone https://github.com/lsoffi/RecoEgamma-ElectronIdentification.git data/RecoEgamma/ElectronIdentification/data
cd data/RecoEgamma/ElectronIdentification/data
git checkout CMSSW_9_4_0_pre3_TnP
rm -r Spring15*
rm -r Spring16*
rm -r PHYS14/
cd $CMSSW_BASE/src
scram b  -j50
