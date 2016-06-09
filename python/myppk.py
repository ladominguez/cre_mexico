from obspy.signal.trigger import classicSTALTA, triggerOnset, plotTrigger
from obspy.core           import read
import os, glob

stla       =  3.0   # Short term in seconds
ltla       = 20.0   # Long term in seconds
on_tres    =  3.5   # ON threshold
off_tres   =  0.5   # OFF threshold

file_list  = glob.glob(os.path.join(os.getcwd(), "*.sac"))
N          = len(file_list)
misses     = 0

for k in range(0,N):
    trace = read(file_list[k])
    tr    = trace[0]
    df    = tr.stats.sampling_rate
    try:
        cft   = classicSTALTA(tr.data, int(stla * df), int(ltla * df))
#cft   = recSTALTA(tr.data, int(stla * df), int(ltla * df))
    except:
        print "Error from file ", file_list[k]
        misses = misses + 1
        continue
    on_of = triggerOnset(cft, on_tres, off_tres )
    if len(on_of) > 0:
        #plotTrigger(tr, cft, on_tres, off_tress)
        try:
            t5              = tr.times()[on_of[0][0]] + tr.stats.sac.b
        except:
            print "Error from file ", file_list[k]
            misses = misses + 1
            continue
        tr.stats.sac.t5 = t5
        tr.write(file_list[k], format='SAC')
    else:
        misses = misses + 1
        print "Unable to pick p arrival.", file_list[k]
print "Files analyzed ", k 
print "Unable to detect ", misses
