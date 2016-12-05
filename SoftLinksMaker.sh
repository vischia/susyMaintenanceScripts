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

###
# Made by Chiqui <isidro.gonzalez.caballero@cern.ch> and Nacho <ignacio.suarez.andres@cern.ch>
###

FOLDERIN=""
FOLDEROUT=""
# Base dir for data folders
MPAFDATA="/pool/ciencias/HeppyTrees/RA7/estructura/"

# Example of possible values
#FOLDERIN=/pool/ciencias/TreesDR74X/heppyTrees/v1
#FOLDEROUT=TreesDR74X_v1


# Get values from command line if available
if [ ! -z $1 ]; then
    FOLDERIN=$1
    if [ ! -z $2 ]; then
	FOLDEROUT=$2
    fi
fi

# If at this point we don't have a valid FOLDERIN variable, ask for it
if [ -z $FOLDERIN ]; then
    echo "[QUES] Introduce the folder where I should search for the samples:"
    read -e -p "       " -i "/pool/ciencias/HeppyTrees/RA7/estructura/trees_8011_July22" FOLDERIN
fi

# Check if FOLDERIN exists and exit if that is not the case
if [ ! -d $FOLDERIN ]; then
    echo "[ERROR] $FOLDERIN does not exist! Exiting!"
    exit
fi



# If at this point we don't have a valid FOLDEROUT variable, ask for it
if [ -z $FOLDEROUT ]; then
    echo "[QUES] Introduce the name of the folder that will be placed in "
    echo "       $MPAFDATA"
    echo "       and where the soft links should be created: "
    read -e -p "       " -i "trees_8011_July5" FOLDEROUT
fi







# Full path of the folder where soft links will be created
LOCALFOLDER=$MPAFDATA/$FOLDEROUT

# Some output at this point
echo "[INFO] Sample files in $FOLDERIN will be linked in $LOCALFOLDER"


# Creating main data folder if needed
if [ ! -d $MPAFDATA ]; then
    echo "[INFO] Creating directory $MPAFDATA"
    mkdir $MPAFDATA
fi
  
# Creating particular data folder if needed
LOCALFOLDER=$MPAFDATA/$FOLDEROUT
if [ ! -d $LOCALFOLDER ]; then
    echo "[INFO] Creating directory $LOCALFOLDER"
    mkdir $LOCALFOLDER
fi

# Now yes! Create the links!
for NAMESAMPLE in $FOLDERIN/*
do  
  NAMESHORT=$(basename $NAMESAMPLE)
  echo [INFO] $LOCALFOLDER/$NAMESHORT "-->" $FOLDERIN/$NAMESHORT    
  #ls -lrtF --color $SAMPLEFOLDER/treeProducerSusyMultilepton/tree.root 
  ln -s $FOLDERIN/$NAMESHORT $LOCALFOLDER/$NAMESHORT
done

if [ -d $FOLDERIN/merged ]; then
    for NAMESAMPLE in $FOLDERIN/merged/*
    do  
	NAMESHORT=$(basename $NAMESAMPLE)
	echo [INFO] $LOCALFOLDER/$NAMESHORT "-->" $FOLDERIN/merged/$NAMESHORT
         #ls -lrtF --color $SAMPLEFOLDER/treeProducerSusyMultilepton/tree.root 
	ln -s $FOLDERIN/merged/$NAMESHORT $LOCALFOLDER/$NAMESHORT
done

fi
