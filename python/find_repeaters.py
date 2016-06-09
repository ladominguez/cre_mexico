import os, random, shutil, glob, time, crsmex, sys, smtplib
from subprocess import call
from datetime   import date
from obspy      import read
from obspy.core.util import gps2DistAzimuth

if len(sys.argv) == 1:  # UNIT TEST
	station_nm = "CAIG.HHZ..4-16Hz_data"
	send_email   = False
else:
	station_nm = str(sys.argv[1])

email_results = True	
share_results = True
root_dir      = "/home/u2/antonio/CRSMEX/data/"
path_data     = root_dir + station_nm + "/sac/"
coh_dir       = root_dir + station_nm + "/coh/"
log_dir       = root_dir + station_nm + "/log/"
out_dir       = "/home/u2/antonio/CRSMEX/output/"
share_dir     = "/data/seis01/antonio/output_crsmex/2015JUN10/"  

today         = date.today()
start_time    = time.time()
file_list     = sorted(glob.glob(os.path.join(path_data,"*.sac")))
N             = len(file_list)
out_file1     = "CRS_" + station_nm + "_" + str(today.year) + '{0:02d}'.format(today.month) + \
                                                              '{0:02d}'.format(today.day)   + ".DAT" # Luis's  format
out_file2     = "CRS_" + station_nm + "_" + str(today.year) + '{0:02d}'.format(today.month) + \
                                                              '{0:02d}'.format(today.day)   + ".BSL" # Taira's format
log_file      = "CRS_" + station_nm + "_" + str(today.year) + '{0:02d}'.format(today.month) + \
                                                              '{0:02d}'.format(today.day)   + ".LOG" # Log file 
out_file1     = out_dir + out_file1
out_file2     = out_dir + out_file2
log_file      = log_dir + log_file

# Control Parameters 
Win        =  25.5         # Win = 0 means dynamic window (see file eq_win.m), otherwise Win > 0 fixed lenght.
Threshold  =  0.6
low_f      =  1
high_f     =  8
n_poles    =  2
p_pick     = 'fixed'     # Manual a field, auto t5 field, combined  either a or t5 field
pplot      = True
no_limit   = True

eq_distance_threshold = 100
eq_sta_dist_limit     = 75

fid       = open(out_file1, "w")
fid2      = open(out_file2, "w")

computer  = os.popen("uname -m -n -s").read()
line_log  = "Windows width = " + str(Win) + " Threshold = " + str(Threshold) + " STNM = " + station_nm + \
           " Low = " + str(low_f) + "Hz. High = " + str(high_f) + "Hz. N_poles = " + str(n_poles) + " p_pick = " + p_pick + "."

fid.write("% " + computer)
fid.write("% Number of files: "    + str(N)   + "\n" )
fid.write("% "                     + line_log + "\n" )
fid.write("% Start Time = " + time.strftime("%d %B %Y at %H:%M:%S") + "\n")
print     "Searching repeaters for station " + station_nm + " ..."

for k in range(0,N):
    master = read( file_list[k] )
    master.filter('bandpass', freqmin=low_f , freqmax=high_f, corners=n_poles, zerophase=True )
    #master.filter('highpass', freq=low_f , corners=n_poles, zerophase=True )
    kevnm_master = master[0].stats.sac.kevnm.rstrip()
    log_line = 'k = ' + str(k) + ' out of ' + str(N)
    print log_line
    if (k-1)%100 == 0:
	fid_log   = open(log_file,  'a')
    	fid_log.write(log_line + '\n')
        fid_log.close()
    if no_limit == False:
    	eq_station = gps2DistAzimuth(master[0].stats.sac.evla, master[0].stats.sac.evlo, \
                                 master[0].stats.sac.stla, master[0].stats.sac.stlo)
    	if  master[0].stats.sac.dist > eq_sta_dist_limit:
		continue

    for n in range(k+1, N): 
        test         = read( file_list[n] )
        test.filter('bandpass', freqmin=low_f , freqmax=high_f, corners=n_poles, zerophase=True )
        #test.filter('highpass', freq=low_f ,  corners=n_poles, zerophase=True )
	eq_dist = 9999.  # Declare to a  large value
	if no_limit == False:
        	eq_dist = gps2DistAzimuth(master[0].stats.sac.evla, master[0].stats.sac.evlo, \
                                    test[0].stats.sac.evla,  test[0].stats.sac.evlo )[0]/1000
        if (eq_dist <= eq_distance_threshold) or (no_limit):
	    if p_pick == 'fixed':
		master_times = [master[0].stats.sac.t6, master[0].stats.sac.t7, master[0].stats.sac.t8]
		test_times   = [test[0].stats.sac.t6,   test[0].stats.sac.t7,   test[0].stats.sac.t8]
		for kfixed in range(0,3):
	   	    for jfixed in range(0,3):
		        p_master = master_times[kfixed]
		        p_test   = master_times[jfixed]
			if (p_master != -12345.) and (p_test != -12345.):
				CorrelationCoefficient, tshift, S1, S2 = crsmex.get_correlation_coefficient(master, test, Win, p_pick, pplot, p_master, p_test)
	    else:
            	CorrelationCoefficient, tshift, S1, S2 = crsmex.get_correlation_coefficient(master, test, Win, p_pick, pplot)
        else:
            continue
        if CorrelationCoefficient >= Threshold:
            fileout_coh = coh_dir + 'COH.' + 'BHZ.' + station_nm + '.' +  kevnm_master + '.' + test[0].stats.sac.kevnm.rstrip() + '.DAT'
            coherence   = crsmex.coherency(S1, S2, low_f, high_f, master[0].stats.sampling_rate, fileout_coh)
            outline     = str(k) + " " + file_list[k].split('/')[-1] + " " + file_list[n].split('/')[-1] + " " + \
                          "{0:6.4f}".format(CorrelationCoefficient) + " " \
		          "{0:6.2f}".format(tshift) + " " + "{0:5.2f}".format(master[0].stats.sac.evla) + " " + \
                          "{0:5.2f}".format(master[0].stats.sac.evlo) + " " + "{0:5.2f}".format(test[0].stats.sac.evla) + " " + \
                          "{0:5.2f}".format(test[0].stats.sac.evlo  ) + " " + "{0:5.2f}".format(Win) 
            outline2    = str(master[0].stats.starttime.year) + '.' + "{0:03d}".format(master[0].stats.starttime.julday) + '.' + \
                          "{0:02d}".format(master[0].stats.starttime.hour) + "{0:02d}".format(master[0].stats.starttime.minute) + \
                          "{0:02d}".format(master[0].stats.starttime.second) + ' ' + \
                          str(test[0].stats.starttime.year) + '.' + "{0:03d}".format(test[0].stats.starttime.julday) + '.' + \
                          "{0:02d}".format(test[0].stats.starttime.hour) + "{0:02d}".format(test[0].stats.starttime.minute) + \
                          "{0:02d}".format(test[0].stats.starttime.second) + ' ' + \
                          "{0:04d}".format(int(CorrelationCoefficient*1e4)) + ' ' + "{0:04d}".format(int(coherence*1e4)) + ' ' + \
			  master[0].stats.sac.kevnm.rstrip() + ' ' + test[0].stats.sac.kevnm.rstrip() 
            print outline2
	    fid.write(outline + '\n')
	    fid2.write(outline2 + '\n')
	    outline=''
            outline2=''
print "Writting ", out_file1
print "Writting ", out_file2
print "Elapse time (minutes) = ", (time.time() - start_time)/60., ", (hours) = ", (time.time() - start_time)/3600.
fid.write("% End Time = " + time.strftime("%d %B %Y at %H:%M:%S") + "\n")
fid.close()
fid2.close()
fid_log.close()

if share_results:
	shutil.copy(out_file1, share_dir)
	shutil.copy(out_file2, share_dir)
        
if email_results:
	FROM    = 'antonio@seismo.berkeley.edu'
	TO      = 'antonio@moho.ess.ucla.edu'
	SUBJECT = '[CRSMEX] Results from station ' + station_nm
	TEXT    = line_log
	message = 'Subject: %s\n\n%s' % (SUBJECT, TEXT)

	server = smtplib.SMTP('mail.geo.berkeley.edu')
	server.sendmail(FROM, TO, message)
	server.quit()        
