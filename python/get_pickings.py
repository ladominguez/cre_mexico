import numpy as np
def get_pickings(time, cft, on, off):
    cft  = cft - on
    cfts = np.sign(cft)
    cftd = np.diff(cfts)

    ind_on = no.where(cftd == 2)
    

