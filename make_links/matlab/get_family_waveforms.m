clear all
close all

fid      = fopen('directories.list',   'r');
stations = ['ARIG'; 'CAIG'; 'MEIG'; 'MMIG'; 'PNIG'; 'PLIG'; 'TLIG'; 'OXIG'; 'PEIG'; 'ZIIG'; 'YOIG'];


while 1
    subdir = fgetl(fid);
    if ~ischar(subdir)
        break
    end

    for w = 1:size(stations,1)
            [files N] = ValidateComponent(stations(w,:),subdir,'table',1);
	
	    if N == 0
		continue
            end

	    for k = 1:N
		A      = load(fullfile(pwd,subdir,files(k).name) );
		T(k,:) = (A(:,2)./max(abs(A(:,2))))';
	    end
	    
	    Tt   = A(:,1);
	    Tm   = mean(T)';
	    Tstd = std(T)';
            
	    out  = [Tt Tm Tstd];
	
	    fileout = [stations(w,:) '.' upper(subdir) '.W' num2str(N,'%.2d') '.table'];
            
	    disp(['Writting ' fileout ' using ' num2str(N) ' waveforms.'])
	    save(fileout, 'out', '-ascii');	    
            clear files N T

    end
    
end

fclose(fid);
