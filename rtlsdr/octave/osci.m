%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:       S3xm3x
% Date:         08.03.2017
% File:         osci.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Vars
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		samp_rate = 1.2e6			% Hertz
		refresh_rate =	0.05			% Seconds 
		PRE = 100				% Downsampling rate of the write function
		N = samp_rate*refresh_rate/PRE		% Number of samples
		fileRaw = 'raw.csv'
		fileFiltered = 'filtered.csv'	
		fileBinary = 'binary.csv'	
		n = 1;					% Additional decimation if necessary		

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Readout and plot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				
		offset = 0;
		C0 = 0;
		C1 = 0;
		t = linspace(0,refresh_rate*1e3,N/n);	
		M1 = zeros(1,N);
		P1 = M1(1:n:end);
		M2 = zeros(1,N);
		P2 = M2(1:n:end);
		M3 = zeros(1,N);
		P3 = M3(1:n:end);
		osciRaw = subplot(3,1,1);
		plot(t,P1);
		xlabel('t/ms');
		ylabel('8 Bit value');
		title('Max'' Scope Raw');
		osciFilt = subplot(3,1,2);
		plot(t,P2);
		xlabel('t/ms');
		ylabel('8 Bit value');
		title('Max'' Scope Filtered');
		osciBin = subplot(3,1,3);
		plot(t,P3);
		xlabel('t/ms');
		ylabel('8 Bit value');
		title('Max'' Scope Binary');
		sum=0;

		while (length(M1) >= N)
			R0 = offset * N;
			R1 = offset * N + N - 1;
			M1 = dlmread(fileRaw,',',[R0,C0,R1,C1]);
			P1 = M1(1 : n : end);			% Decimate!
			M2 = dlmread(fileFiltered,',',[R0,C0,R1,C1]);
			P2 = M2(1 : n : end);			% Decimate!
			M3 = dlmread(fileBinary,',',[R0,C0,R1,C1]);
			P3 = M3(1 : n : end);		
			set(findobj(osciRaw, 'type', 'line'), 'xdata', t, 'ydata', P1); 
			set(findobj(osciFilt, 'type', 'line'), 'xdata', t, 'ydata', P2); 
			set(findobj(osciBin, 'type', 'line'), 'xdata', t, 'ydata', P3); 
			axis(osciRaw,[0 refresh_rate*1e3 -20 20]);
			axis(osciFilt,[0 refresh_rate*1e3 -20 20]);
			axis(osciBin,[0 refresh_rate*1e3 0 1.1]);
			offset = offset + 1;
			sum=sum+length(P2)
			pause(refresh_rate);			
		end
