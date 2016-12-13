#!/bin/bash

# --- CMG stuff Installation script ---
# Pietro Vischia
# In case of issues, mail to: pietro.vischia@cern.ch

# Run with: installSusy.sh <YOUR-GITHUB-USERNAME> <YOUR-CERN-USERNAME>


UGIT=${1}
UCERN=${2}

CENTRALBRANCH="heppy_80X_M17"
LITEBRANCH="80X_M17"

if [ "${UGIT}" == "" ]; then
    echo "You must specify your github username and your lxplus username, in this order:"
    echo "sh ${0} <YOUR-GITHUB-USERNAME> <YOUR-CERN-USERNAME>"
    echo "Possibly, you must also not be Constantin or Marco, as their repos are added to the remotes list anyways :D"
    exit -1
fi

if [ "${UCERN}" == "" ]; then
    echo "You must specify your github username and your lxplus username, in this order:"
    echo "sh ${0} <YOUR-GITHUB-USERNAME> <YOUR-CERN-USERNAME>"
    echo "Possibly, you must also not be Constantin or Marco, as their repos are added to the remotes list anyways :D"
    exit -1
fi

# This is for not having to wait for the scp command to leave the desk :D

wget https://linux.web.cern.ch/linux/docs/krb5.conf; env KRB5_CONFIG=./krb5.conf kinit ${UCERN}; 


export SCRAM_ARCH=slc6_amd64_gcc530
scram project CMSSW CMSSW_8_0_19
cd CMSSW_8_0_19/src 
cmsenv
cmsenv
eval `scramv1 runtime -sh`
git cms-init

# add the central cmg-cmssw repository to get the Heppy 80X branch
### For now, use peruzzim as central
### git remote add cmg-central https://github.com/CERN-PH-CMG/cmg-cmssw.git  -f  -t heppy_80X
git remote add peruzzim git@github.com:peruzzim/cmg-cmssw.git -f -t ${CENTRALBRANCH}
git remote add cmg-central git@github.com:CERN-PH-CMG/cmg-cmssw.git

# configure the sparse checkout, and get the base heppy packages
env KRB5_CONFIG=../../krb5.conf scp -v -o GSSAPIAuthentication=yes -o GSSAPIDelegateCredentials=yes -o PreferredAuthentications=gssapi-with-mic -o KerberosAuthentication=yes -o GSSAPITrustDNS=yes ${UCERN}@lxplus.cern.ch:/afs/cern.ch/user/c/cmgtools/public/sparse-checkout_80X_heppy .git/info/sparse-checkout
#git checkout -b heppy_80X cmg-central/heppy_80X


# add ECOP, and check it out (first time for the branch. Then, no.)
### git remote add ecop git@github.com:ECOP/cmg-cmssw.git -f -t heppy_80X_for2016basis
git remote add ecop git@github.com:ECOP/cmg-cmssw.git 

git checkout -b ${CENTRALBRANCH} peruzzim/${CENTRALBRANCH}

# add your mirror, and push the 80X branch to it
git remote add origin git@github.com:${UGIT}/cmg-cmssw.git
git push origin -u ${CENTRALBRANCH}

# Now get the CMGTools subsystem from the cmgtools-lite repository
### For now, use perizzum as central
### git clone -o cmg-central https://github.com/CERN-PH-CMG/cmgtools-lite.git -b 80X CMGTools
git clone -o peruzzim git@github.com:peruzzim/cmgtools-lite.git -b ${LITEBRANCH} CMGTools
git remote add cmg-central git@github.com:CERN-PH-CMG/cmgtools-lite.git

cd CMGTools 


# add ECOP, and check it out (first time for the branch. Then, no.)
### git remote add ecop git@github.com:ECOP/cmgtools-lite.git -f -t 80X_for2016basis
git remote add ecop git@github.com:ECOP/cmgtools-lite.git

git checkout -b ${LITEBRANCH} peruzzim/${LITEBRANCH}

# add your fork, and push the 80X branch to it
git remote add origin  git@github.com:${UGIT}/cmgtools-lite.git 
git push -u origin ${LITEBRANCH}

# add Constantin's fork, because sometimes he has the good stuff
git remote add cheidegg  git@github.com:cheidegg/cmgtools-lite.git


# Remove kerberos
cd $CMSSW_BASE/src/../../
rm krb5.conf

#compile
cd $CMSSW_BASE/src && scram b -j 20




exit 0