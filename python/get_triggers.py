import obspy, sys
import numpy as np
import matplotlib.pyplot as plt
from obspy.signal.trigger import classic_sta_lta, plot_trigger

on  = 1.5
off = 1.0

trace = obspy.read("TAU.IG.BHZ..D.2012.082.203455.00023000.sac")[0]
df    = trace.stats.sampling_rate

cft = classic_sta_lta(trace.data, int(5. * df), int(10. * df))

cft  = cft - on
cfts = np.sign(cft)
cftd = np.diff(cfts)

ind_on = np.where(cftd == 2)

plt.plot(trace.times(),trace.data)


for k in ind_on[0]:
    print k, trace.times()[k]
    plt.axvline(trace.times()[k],color='r')

plt.savefig('deletme.png')

