import ROOT
from DataFormats.FWLite import Events, Handle

events = Events('step1_GEN-SIM.root')

handle = Handle('std::vector<reco::GenParticle>')
label = ("genParticles","","GEN") 
for count,e in enumerate(events):
    if count > 10: continue
    e.getByLabel(label,handle)
    genParticles = handle.product()
    print "-"*20 
    for p in genParticles:
        if not p.isHardProcess(): continue
        print p.pdgId(),p.pt(),p.eta()
