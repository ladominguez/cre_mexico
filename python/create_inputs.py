import glob

files_sac = glob.glob('*.sac')
N         = len(files_sac)
m         = 0
counter   = 1
for file in files_sac:
    m = m + 1
    index = range(m,N)
    for k in index:
        fileout = 'input_' + '{:03d}'.format(counter)  + '_' + str(m) + '_' + str(k+1) + '.in'
        fid = open(fileout,'w+')
        fid.write(file + '\n')
        fid.write(files_sac[k] + '\n')
        fid.write('\n')
        fid.write('\n')
        fid.close()
        print 'File ', fileout, ' created.'
        counter = counter + 1
