#!/bin/bash
################################################
# DESCRIPTION:
# This scripts create the soft links needed in the workdir/data
# folder to let MPAF understand where the samples are.
# It may be used in many ways
# 1) Just execute it and it will ask for the relevant information
# 2) It accepts 2 arguments: the input folder (where the samples are) 
#    and the name of the folder where the softlinks will be created.
# 3) Edit the FOLDERIN and FOLDEROUT variables in here to hold the 
#    values of the input folder and the folder where the softlinks will
#    be created. Then, just call the script
################################################

# Probe only or act
ACTION=""

# Base dir for data folders
MPAFDATA=""

# URL to be substituted
ORIGURL=""

# URL to be set as substitution
DESTURL=""

         
# URL to be substituted
#ORIGURL="root://eoscms.cern.ch//eos/cms/store/user/mmarionn/heppyTrees/809_June9/"
#ORIGURL="root://eoscms.cern.ch//eos/cms/store/user/mmarionn/heppyTrees/8011_June29/"
#DESTURL="file:////pool/ciencias/HeppyTrees/RA7/809_June9/"


#ORIGURL="file://pool/ciencias/HeppyTrees/RA7/809_June9/"
#DESTURL="/pool/ciencias/HeppyTrees/RA7/809_June9/"

#ORIGURL="//pool/ciencias/HeppyTrees/RA7/809_June9/"
#DESTURL="file:///pool/ciencias/HeppyTrees/RA7/809_June9/"
#ORIGURL="file:///pool/ciencias/HeppyTrees/RA7/809_June9/"
#DESTURL="file:////pool/ciencias/HeppyTrees/RA7/809_June9/"
#ORIGURL="root://eoscms.cern.ch//eos/cms/store/user/peruzzi/ra5trees/"
#ORIGURL="TREES_80X_230616/"
#ORIGURL="809_June9_more/"
#DESTURL=""

# Get values from command line if available
if [ ! -z $1 ]; then
    ACTION=$1
    if [ ! -z $2 ]; then
        MPAFDATA=$2
        if [ ! -z $3 ]; then
            ORIGURL=$3
            if [ ! -z $4 ]; then
                DESTURL=$4
            fi
        fi
    fi
fi

# If at this point we don't know what to do, ask for it
if [ -z $ACTION ]; then
    echo "[QUES] Introduce the action [probe|substitute]"
    read -e -p "       " -i "probe" ACTION
fi

if [ $ACTION != "probe" ] && [ $ACTION != "substitute" ]; then
    echo "[ERROR] Action undefined. Permitted actions are:"
    echo "      probe: dumps into urllist.txt a list of the urls, for preliminary inspection"
    echo " substitute: dumps into urllist.txt a list of the urls, for bookkeeping, and then performs the requested substitution"
    exit
fi

# If at this point we don't have a valid MPAFDATA variable, ask for it
if [ -z $MPAFDATA ]; then
    echo "[QUES] Introduce the folder where I should search for the samples:"
    read -e -p "       " -i "/pool/ciencias/HeppyTrees/RA7/pietro/friendTrees/trees80X_809June9/" MPAFDATA
fi

# If at this point we don't have an URL to be substituted, ask for it
if [ -z $ORIGURL ]; then
    echo "[QUES] Introduce the URL to be substituted:"
    read -e -p "       " -i "" ORIGURL
fi

# If at this point we don't have an URL to substitute ORIGURL with, ask for it
if [ -z $DESTURL ]; then
    echo "[QUES] Introduce the URL that must replace $ORIGURL:"
    read -e -p "       " -i "" DESTURL
fi

# Check if MPAFDATA exists and exit if that is not the case
if [ ! -d $MPAFDATA ]; then
    echo "[ERROR] $MPAFDATA does not exist! Exiting!"
    exit
fi

# Some output at this point
echo "[INFO] Sample files in $MPAFDATA will have their tree.root.url substituted with the new url."
echo "[INFO] The original URL is assumed to be: ${ORIGURL}, and will be substituted with ${DESTURL}"

# Now yes! Create the links!
for NAMESAMPLE in $MPAFDATA/*
do  
  NAMESHORT=$(basename $NAMESAMPLE)
  echo "[INFO] Acting on $MPAFDATA/$NAMESHORT/treeProducerSusyMultilepton/tree.root.url"
  #ls -lrtF --color $SAMPLEFOLDER/treeProducerSusyMultilepton/tree.root 
  #ln -s $FOLDERIN/$NAMESHORT $LOCALFOLDER/$NAMESHORT
  cat $MPAFDATA/$NAMESHORT/treeProducerSusyMultilepton/tree.root.url >> urllist.txt
  echo -e "\n" >> urllist.txt
  if [ "${ACTION}" = "probe" ]; then
      continue
  fi
  echo "sed -i -e \"s#${ORIGURL}#${DESTURL}#g\" $MPAFDATA/$NAMESHORT/treeProducerSusyMultilepton/tree.root.url"
  sed -i -e "s#${ORIGURL}#${DESTURL}#g" $MPAFDATA/$NAMESHORT/treeProducerSusyMultilepton/tree.root.url
done

