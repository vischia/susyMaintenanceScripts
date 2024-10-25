from glob import glob
import ROOT as r 
import os

production_paths=[
    "fqcd_forkristijonas",
    #"frqcd_mc_2018_withpnet",
]

remote_paths=[
    "/eos/cms/store/cmst3/group/tthlep/sesanche/NanoTrees_forCMGRDF_100524_summerstudent_kistinjonas/",
    #"/eos/cms/store/cmst3/group/tthlep/sesanche/NanoTrees_forCMGRDF_100524_summerstudent_kistinjonas_mc/",
]

def print_is_missing(file_name, production_path):
    #print(f'{file_name} missing')
    #print(f"Chunk {chunk} has failed") 
    print(f"cd {production_path}/{chunk}; run_condor_simple.sh -t 480 ./batchScript.sh; cd -")

for production_path, remote_path in zip( production_paths, remote_paths):
    for chunk in os.listdir(production_path):
        if not os.path.isdir(f'{production_path}/{chunk}'): continue
        if "Chunk" in chunk:
            dataset_name = chunk.split("_Chunk")[0]
            chunk_no=chunk.split("_Chunk")[1]
            file_name=f"{remote_path}/{dataset_name}/{chunk}.root_{chunk}_{chunk_no}.root"
        else:
            file_name=f"{remote_path}/{chunk}/{chunk}.root_{chunk}_all.root"
    
        if not os.path.exists(file_name):
            print_is_missing( file_name, production_path)
            continue

        tf=r.TFile.Open( file_name )
        evts=tf.Get("Events")
        if not evts:
            print(f"rm {file_name}")
            #print_is_missing( file_name, production_path)
            continue
