from obspy.core                     import read, Trace, AttribDict
from scipy.interpolate              import interp1d
from obspy.core.util.geodetics.base import gps2DistAzimuth
from datetime                       import date
from scipy                          import fftpack, signal
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.mlab
import numpy             as np
import matplotlib.pyplot as plt
import sys, math, cmath

def get_correlation_coefficient(*args):
    # UNIT TEST
    nargin = len(args)
    if nargin == 0:
        print 'Running test unit ...'
        file1  = './test_data/20011105104504.IG.PLIG.BHZ.sac'
        file2  = './test_data/20080925043418.IG.PLIG.BHZ.sac'
        print "Opening file ", file1
        print "Opening file ", file2
        sac1[0].filter('highpass',freq=1.0, corners=2, zerophase=True)
        sac2[0].filter('highpass',freq=1.0, corners=2, zerophase=True)
        low      = 1.0
        high     = 8.
        p_pick   =  'manual'
        sac1     = read(file1)
        sac2     = read(file2)
        Win      = 0.
        pplot    = True
	t_master = 0.
	t_test   = 0.
    elif nargin == 2:
        sac1     = args[0]
        sac2     = args[1]
        Win      = 40.                # Width of the window in seconds after the sac.a
        p_pick   = 'manual'
	t_master = 0.
	t_test   = 0.
    elif nargin == 3:
        sac1     = args[0]
        sac2     = args[1]
        Win      = args[2]
        p_pick   = 'manual'
        pplot    = False
	t_master = 0.
	t_test   = 0.
    elif nargin == 4:
        sac1     = args[0]
        sac2     = args[1]
        Win      = args[2]
        p_pick   = args[3]
        pplot    = False
	t_master = 0.
	t_test   = 0.
    else:
        sac1     = args[0]
        sac2     = args[1]
        Win      = args[2]
        p_pick   = args[3]
        pplot    = args[4]
	t_master = args[5]
	t_test   = args[6]

    dt = sac1[0].stats.delta
    fs = 1.0/dt

    if Win == 0:   # Dynamic window size
        s1_signal, s1_time, dummy_A = eq_window2(sac1)
        s2_signal, s2_time, dummy_B = eq_window2(sac2)
        if len(s1_signal) < len(s2_signal):
            s2_signal = s2_signal[0:len(s1_signal) -1 ]
            s2_time   = s2_time[  0:len(s1_signal) -1 ]
        else:
            s1_signal = s1_signal[0:len(s2_signal) -1 ]
            s1_time   = s1_time  [0:len(s2_signal) -1 ]
        Win = min([dummy_A, dummy_B])

    year_1  = sac1[0].stats.starttime.year
    month_1 = sac1[0].stats.starttime.month
    day_1   = sac1[0].stats.starttime.day

    
    year_2  = sac2[0].stats.starttime.year
    month_2 = sac2[0].stats.starttime.month
    day_2   = sac2[0].stats.starttime.day

    day_diff = date(year_2, month_2, day_2) - date(year_1, month_1, day_1) 
    dt_event = day_diff.days
    # TODO. Consider the case when there is no eq info. DRLA, APR2016
    #distEvnt = gps2DistAzimuth(sac1[0].stats.sac.evla, sac1[0].stats.sac.evlo, \
    #                           sac2[0].stats.sac.evla, sac2[0].stats.sac.evlo)
    distEvnt  = 0.
    Mag1     = sac1[0].stats.sac.mag
    Mag2     = sac2[0].stats.sac.mag
    if dt_event > 365:
        dt_event  = dt_event/365
        unit_time = 'years'
    else:
        unit_time = 'days'
    
    # Read Files
    S1 = sac1[0].data
    S2 = sac2[0].data

    T1 = np.linspace(sac1[0].stats.sac.b, sac1[0].stats.sac.e, sac1[0].stats.npts)
    T2 = np.linspace(sac2[0].stats.sac.b, sac2[0].stats.sac.e, sac2[0].stats.npts)


    if p_pick == 'manual':
        P_arrival_1 = sac1[0].stats.sac.a
        P_arrival_2 = sac2[0].stats.sac.a

    elif p_pick == 'auto':
        P_arrival_1 = sac1[0].stats.sac.t5
        P_arrival_2 = sac2[0].stats.sac.t5

    elif p_pick == 'fixed':
	P_arrival_1 = t_master
	P_arrival_2 = t_test
	
    elif p_pick == 'combined':
        if   sac1[0].stats.sac.a != -12345:
            P_arrival_1 = sac1[0].stats.sac.a
        elif sac1[0].stats.sac.t5 != -12345:
            P_arrival_1 = sac1[0].stats.sac.t5 
        else:
            print "No p_arrrival information_available. get_cotrrelation_coefficient.m"
            exit()
        if   sac2[0].stats.sac.a != -12345:
            P_arrival_2 = sac2[0].stats.sac.a
        elif sac2[0].stats.sac.t5 != -12345:
            P_arrival_2 = sac2[0].stats.sac.t5 
        else:
            print "No p_arrrival information_available. get_cotrrelation_coefficient.m"
            exit()
    else:
        print "get_correlation_coefficient.m - Invalid option. Choose either manual, auto or combined"
        exit()

    if P_arrival_1 == -12345.0 or P_arrival_2 == -12345.0:
    	sys.exit('Missing p arrival information. ')

    # Trim data
    if Win < 0: # Select all, I did this to check Taka's Java code. If Win is negative takes the whole record
        Win   = min(sac1[0].stats.delta*(sac1[0].stats.npts -1), sac2[0].stats.delta*(sac2[0].stats.npts -1))
	Ntrim = min(sac1[0].stats.npts, sac2[0].stats.npts)
	T1    = T1[:Ntrim]
	T2    = T2[:Ntrim]
	S1    = S1[:Ntrim]
	S2    = S2[:Ntrim]
    else:           
    	Ntrim = 2**nextpow2(float(Win/sac1[0].stats.delta))
    	index_1 = T1 >= P_arrival_1
    	index_2 = T2 >= P_arrival_2
    	T1 = T1[index_1][:Ntrim]
    	S1 = S1[index_1][:Ntrim]
    	T2 = T2[index_2][:Ntrim]
    	S2 = S2[index_2][:Ntrim]

    if len(S1) < Ntrim or len(S2) < Ntrim or len(S1) != len(S2):
        CorrelationCoefficient = 0
        tshift                 = 0
        return (CorrelationCoefficient, tshift, S1, S2)

    N        = len(S1)    
    Power_S1 = max(np.correlate(S1,S1))/N
    Power_S2 = max(np.correlate(S2,S2))/N
    if (Power_S1 == 0) or (Power_S2 == 0):
	CorrelationCoefficient = 0
	tshift                 = 0
    else:
    	A                      = np.correlate(S1,S2,'full')/(N*np.sqrt(Power_S1*Power_S2))
    	time2                  = np.arange(-(N-1)*dt, N*dt, dt)
    	CorrelationCoefficient = A.max()
    	index                  = np.argmax(A)
    	tshift                 = time2[index] 

    if pplot and (CorrelationCoefficient >= 0.95):
        stnm    = sac1[0].stats.station.rstrip()
	kevnm_1 = sac1[0].stats.sac.kevnm.rstrip()
	kevnm_2 = sac2[0].stats.sac.kevnm.rstrip()
        plt.figure(figsize=(16.0,4.5))
	print sac2[0]
	print 'Plotting ', 'sequence_' + stnm + '_' + kevnm_1 + '_' + kevnm_2 + '.png ... '
	print 'tshift = ', tshift, 's. dt =', dt, ' s. float(tshift/dt) = ', float(tshift/dt) 
        S2shift = FFTshift(S2,float(tshift/dt))
        #S2shift = FFTshift(S2, 0.0 )
        plt.plot(T1,S1/np.max(np.abs(S1)),                label='EVID = ' + kevnm_1 + ' ' + str(sac1[0].stats.starttime.date))
        plt.plot(T1,S2shift/np.max(np.abs(S2shift)),      label='EVID = ' + kevnm_2 + ' ' + str(sac2[0].stats.starttime.date))
        plt.legend(loc='upper right')
        plt.xlabel('Time [s]', fontsize=16)
        plt.title('cc = '   + "{0:5.4f}".format(CorrelationCoefficient) + ' dt = '  + "{0:4.2f}".format(tshift) + 's ' + ' $M_1$ = ' + "{0:3.1f}".format(Mag1) + ' $M_2$ = ' + "{0:3.1f}".format(Mag2) + ' $\Delta t$ = ' + "{0:3.1f}".format(dt_event) + unit_time)
        plt.axis('tight')
        plt.savefig( 'sequence_' + stnm + '_' + kevnm_1 + '_' + kevnm_2 + '.png' )
        plt.close()

    return (CorrelationCoefficient, tshift, S1, S2)
    
def eq_window(sac_file, SNR = 3):
# [tw Ad] = eq_window(sac,SNR)def 
#
# Returns a time window tw that containts the complete waveform.
# a o t5 maker must be set to the onet of the p-wave.
#
#                           Luis A. Dominguez (2014)

    wn      = 1    # Windows counter
    step    = 5.0  # Window step in seconds
    win_lim = 12
    record  = [0]*win_lim

    if sac_file[0].stats.sac.a  != -12345.0:
        start_time = sac_file[0].stats.sac.a
    elif sac_file[0].stats.sac.t5 != -12345.0:
        start_time = sac_file[0].stats.sac.t5
    else:
        sys.exit('Not enough header information - a and t5 missing.')

    time  = np.linspace(sac_file[0].stats.sac.b, sac_file[0].stats.sac.e, sac_file[0].stats.npts )
    data  = sac_file[0].data    

    # Noise statistics
    ind_noise = np.where( (time >= start_time - step) & (time <= start_time) )
    t_noise   = time[ind_noise]
    A_noise   = data[ind_noise]
    rms_noise = rms(A_noise)

    # Signal statistics
    ind_signal   = np.where( (time >= start_time) & (time <= start_time + step*wn) )
    t_signal     = time[ind_signal]
    A_signal     = data[ind_signal]
    rms_signal   = rms(A_signal)
    record[wn-1] = float(rms_signal)/rms_noise

    while (rms_signal >= SNR*rms_noise):
        wn = wn + 1
        ind_signal   = np.where( (time >= start_time + step*(wn -1)) & (time <= start_time + step*wn) )
        A_signal     = data[ind_signal]
        rms_signal   = rms(A_signal)
        record[wn-1] = float(rms_signal)/rms_noise
        if wn == win_lim - 1:
            break

    ind_signal = np.where( (time >= start_time - step) & (time <= start_time + step*(wn -1)) )
    T_signal   = time[ind_signal]
    A_signal   = data[ind_signal]
    rms_signal = rms(A_signal)

    win_length = wn*step
        
    return A_signal, T_signal, win_length

def eq_window2(sac_file, SNR = 3):
# [tw Ad] = eq_window(sac,SNR)def 
#
# Returns a time window tw that containts the complete waveform.
# a o t5 maker must be set to the onet of the p-wave.
#
#                           Luis A. Dominguez (2014)

    wn        = 512    # number of samples to analyze
    step      = 3.0    # Window step in seconds
    win_limit = 50.0
    dt        = sac_file[0].stats.delta
    window    = wn*dt

    if sac_file[0].stats.sac.a  != -12345.0:
        start_time = sac_file[0].stats.sac.a
    elif sac_file[0].stats.sac.t5 != -12345.0:
        start_time = sac_file[0].stats.sac.t5
    else:
        sys.exit('Not enough header information - a and t5 missing.')

    time  = np.linspace(sac_file[0].stats.sac.b, sac_file[0].stats.sac.e, sac_file[0].stats.npts )
    data  = sac_file[0].data    

    # Noise statistics
    ind_noise = np.where( (time >= start_time - step) & (time <= start_time) )
    t_noise   = time[ind_noise]
    A_noise   = data[ind_noise]
    rms_noise = rms(A_noise)

    # Signal statistics
    ind_signal   = np.where( (time >= start_time + window) & (time <= start_time + window + step) )
    t_signal     = time[ind_signal]
    A_signal     = data[ind_signal]
    rms_signal   = rms(A_signal)

    while (rms_signal >= SNR*rms_noise):
        wn           = wn*2
        window       = wn*dt
        if window >= win_limit:
            break
        ind_signal   = np.where( (time >= start_time + window) & (time <= start_time + window + step) )
        A_signal     = data[ind_signal]
        rms_signal   = rms(A_signal)

    ind_signal = np.where( (time >= start_time) & (time <= start_time + window))
    T_signal   = time[ind_signal]
    A_signal   = data[ind_signal]
    return A_signal, T_signal, window

def rms(y):
    r = math.sqrt(np.sum(np.square(y))/len(y))
    return r

def nextpow2(x):
    x = round(x)
    n = 0
    
    while x > 2**n:
        n = n+1

    return n
def FFTshift(signal, delay):
    x      = signal
    N      = len(x)
    R      = range(1,N+1)

    X      = fftpack.fft(x)
    k      = np.concatenate((range(0,int(math.floor(N/2))),range(int(math.floor(-N/2)),0)))
    W      = np.exp(-cmath.sqrt(-1) * 2 * np.pi * delay * k / N)
    if N%2 == 0:
        W[N/2] = W[N/2].real

    Y = X*W
    y = fftpack.ifft(Y)
    y = y.real
    return y
def coherency(*args):
# Input arguments:
#  S1 - Signal 1 numpy array
#  S2 - Signal 2 numpy array
#  f1 - Minimum frquency
#  f2 - Maximum frequency
#  fs - Sampling frequency
    nargin = len(args)

    if nargin == 0:
        sac1 = read('./test_data/20080925043418.IG.PLIG.BHZ.sac')
        sac2 = read('./test_data/20011105104504.IG.PLIG.BHZ.sac')
        S1   = sac1[0].data
        S2   = sac2[0].data
        fs   = sac2[0].stats.sampling_rate
        fmin = 1.0
        fmax = 8.0
        filename = 'test.dat'
    elif nargin == 6:
        S1       = args[0]
        S2       = args[1]
        fmin     = args[2]
        fmax     = args[3]
        fs       = args[4]
        filename = args[5]
    else:
        sys.exit('Invalid number of input arguments - crsmex.coherency')

    N1  = len(S1)
    N2  = len(S2)
    Cxy, f = matplotlib.mlab.cohere(S1,S2,Fs=fs,NFFT=128)
    f_ind  = np.where((f >= fmin) & (f <= fmax)) 

    Cxy_mean = np.mean(np.sqrt(Cxy[f_ind]))
    out = np.array([f, Cxy])

    #if Cxy_mean >= 0.8:
    #     print 'Writting coherency ', filename
    #     np.savetxt(filename,np.transpose(out),fmt='%-8.3f %7.5f')
    return Cxy_mean

######## RESERVE ############################
#    f1 = np.linspace(0.0, fs/2., len(S1)/2)
#    f2 = np.linspace(0.0, fs/2., len(S2)/2)
#    X1 = np.absolute(fftpack.fft(S1))
#    X2 = np.absolute(fftpack.fft(S2))
    
#    f_ind1 = np.where((f1 >= fmin) & (f1 <= fmax)) 
#    f_ind2 = np.where((f2 >= fmin) & (f2 <= fmax)) 

#    N1 = len(f_ind1)
#    N2 = len(f_ind2)

#    if (N1 == 0) or (N2 == 0):
#        sys.exit('Empty vectors - crsmex.coherency')

#    if N1 > N2: # This condition solves the error that arises when the records have different lenghts
#        freq = f2(f_ind2)
#        Int  = interp1d(f1,X1,kind='nearest')
#        X1   = Int(freq)
#        X2   = X2[f_ind2]
#    elif N1 < N2:
#        freq = f1(f_ind1)
#        Int  = interp1d(f2,X2,kind='nearest')
#        X1   = X1[f_ind1]
#        X2   = Int(freq)
#    else:  # N1 == N2
#        X1   = X1[f_ind1]
#        X2   = X2[f_ind2]
#
#    X12     = np.mean(np.abs(X1.conjugate()*X2))
#    X1_mean = np.mean(np.abs(X1**2))
#   X2_mean = np.mean(np.abs(X2**2))

#    coherence = X12/cmath.sqrt(X1_mean*X2_mean)
#    coh= np.real(coherence)

#    return np.array(coh,dtype=float)

