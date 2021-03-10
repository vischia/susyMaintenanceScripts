#!/bin/bash

if [ "$1" == "" ]; then
    echo "Run me as:"
    echo "$0 yourGitUsername yourCERNUsername"
    exit 0
fi

if [ "$2" == "" ]; then
    echo "Run me as:"
    echo "$0 yourGitUsername yourCERNUsername"
    exit 0
fi

  
GITUSERNAME=${1}
CERNUSERNAME=${2}
ALREADYHAVEHEPPYREPO="true"
ALREADYHAVECMGREPO="true"
# SOLO AL CERN: JEI=20. Si no, 8
JEI=8


# Get the base heppy happiness
#scp ${CERNUSERNAME}@lxplus.cern.ch:/afs/cern.ch/user/c/cmgtools/public/sparse-checkout_80X_heppy my_sparse-checkout


export SCRAM_ARCH=slc6_amd64_gcc530
export VO_CMS_SW_DIR=/cms/cvmfs/cms.cern.ch
source ${VO_CMS_SW_DIR}/cmsset_default.sh
export CMS_PATH=${VO_CMS_SW_DIR}
#scram project CMSSW_8_0_19
cd CMSSW_8_0_19/src/
cmsenv
#git cms-init
#
#git remote add cmg-central https://github.com/CERN-PH-CMG/cmg-cmssw.git -f  -t heppy_80X
#
## Get the base heppy happiness
#cp $CMSSW_BASE/src/../../my_sparse-checkout .git/info/sparse-checkout
#git checkout -b heppy_80X cmg-central/heppy_80X
#
## Add your mirror
#git remote add origin git@github.com:${GITUSERNAME}/cmg-cmssw.git
#    
#if [ "$ALREADYHAVEHEPPYREPO"== "false" ]; then
#    # Mirror-push to it
#    git push -u origin heppy_80X
#else
#    # Push to it
#    echo "You should do: git push origin heppy_80X"
#    echo "However, better not mess with you previous branches"
#    echo "You are welcome to modify the script according to your special needs"
#    echo "Waiting 5 seconds..."
#    echo sleep 5
#fi      
#
## Get CMGTools-lite
#git clone -o cmg-central https://github.com/CERN-PH-CMG/cmgtools-lite.git -b 80X CMGTools
#cd CMGTools
#
#git remote add origin  git@github.com:${GITUSERNAME/cmgtools-lite.git
#
#if [ "$ALREADYHAVECMGREPO"== "false" ]; then
#    # Mirror-push to it
#    git push -u origin 80X
#else
#    # Push to it
#    echo "You should do: git push origin 80X"
#    echo "However, better not mess with you previous branches"
#    echo "You are welcome to modify the script according to your special needs"
#    echo "Waiting 5 seconds..."
#    echo sleep 5
#fi
#
## Compile, because yes.
cd $CMSSW_BASE/src
#scram b -j 20
#
#echo "I will now transparently add /RecoEgamma/ElectronIdentification/ to the sparse checkout file, like a boss"
#
#echo "/RecoEgamma/ElectronIdentification/" >> ${CMSSW_BASE}/src/.git/info/sparse-checkout
#
# Add Matthieu's repo
cd $CMSSW_BASE/src/
git remote add mmarionncern git@github.com:mmarionncern/cmg-cmssw.git
git fetch mmarionncern
git merge mmarionncern/heppy_80X_M17_Production

cd CMGTools
git remote add mmarionncern git@github.com:mmarionncern/cmgtools-lite.git
git fetch mmarionncern
git merge mmarionncern/80X_M17_Production

# Compile, because yes
cd $CMSSW_BASE/src/
scram b -j${JEI}

# Do crap with electrons
cd $CMSSW_BASE/external/slc6_amd64_gcc530
git clone https://github.com/ikrav/RecoEgamma-ElectronIdentification.git data/RecoEgamma/ElectronIdentification/data
cd data/RecoEgamma/ElectronIdentification/data
git checkout egm_id_80X_v1

# Compile, because yes
cd $CMSSW_BASE/src
scram b -j${JEI}

echo "Congratulations. In principle this should have worked. LoL.\n"
echo "You are now ready to process the data."
echo "First, do a check to be sure it works:"
echo "\t\t heppy test CMGTools!TTHAnalysis/cfg/run_susyMultilepton_cfg.py --option test=1 -N 500 --option analysis\"susy\" --option runData"
echo "In the run_susyMultilepton file, you will find all the run ranges if you look for e.g. 2016B:"
echo "\t\t processing = \"Run2016B-23Sep2016-v3\"; short = \"Run2016B_23Sep2016_v3\"; run_ranges = [(273150,275376)]; useAAA=True; # -v3 starts from 273150 to 275376"
echo "\t\t dataChunks.append((json,processing,short,run_ranges,useAAA))"
echo "\n"
echo "Have fun and be happy with heppy"



