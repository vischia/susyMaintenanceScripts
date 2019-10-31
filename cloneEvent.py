import ROOT as r 
import sys

fil = sys.argv[1]
if len(sys.argv) > 3: 
    run = sys.argv[2]
    lum = sys.argv[3]
    evt = sys.argv[4]
else:
    run, lum, evt = sys.argv[2].split(':')

tfile = r.TFile.Open(fil) 
ttree = tfile.Get('Events')

tfile2 = r.TFile.Open('evt_%s_%s_%s.root'%(run,lum,evt),'recreate')
subtree = ttree.CopyTree( 'event == %s && run == %s && luminosityBlock == %s'%(evt,run,lum))
print subtree.GetEntries(), 'selected events'
subtree.AutoSave()
tfile2.Close()


