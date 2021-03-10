cmsrel CMSSW_9_2_8
cd CMSSW_9_2_8/src
cmsenv
git cms-init

git remote add matthieu https://github.com/mmarionncern/cmg-cmssw.git -f  -t heppy_92X_dev
cp /afs/cern.ch/user/c/cmgtools/public/sparse-checkout_80X_heppy .git/info/sparse-checkout
git checkout -b heppy_92X_dev matthieu/heppy_92X_dev

git clone -o matthieu https://github.com/mmarionncern/cmgtools-lite.git -b 92X_dev CMGTools
cd CMGTools

cd $CMSSW_BASE/src
scram b -j 21


#cd $CMSSW_BASE/external/slc6_amd64_gcc530
#git clone https://github.com/ikrav/RecoEgamma-ElectronIdentification.git data/RecoEgamma/ElectronIdentification/data
#cd data/RecoEgamma/ElectronIdentification/data
#git checkout egm_id_80X_v1
#cd $CMSSW_BASE/src

# python heppy_crab.py --cfg-file ../run_susyMultilepton_cfg.py --storage-site T2_CH_CERN --output-dir heppyTrees -v ProdMCJan23 -l ProdMCJan23 --option removeJecUncertainties --option analysis="susy" --option mcGroup=0
