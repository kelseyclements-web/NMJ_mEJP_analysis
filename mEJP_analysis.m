% mEJP analysis.m Apr 2026
% Loads chart files and determines the frequency and amplitude for each
% recording and puts them in vectors.
% Chart files must be saved as .mat files. 
% Before running, change the 'n' (2nd line of code) to the number of files 
% you want to analyze and make sure the sample time is correct. After pressing run, 
% the program will ask you to select the first file. When the graph pops up, 
% click once to select the beginning of the section 
% you want to analyze and then click a second time to select the end. If debugPlots = 'true', 
% then a graph showing the detected minis will pop up. When ready to move on, 
% the close the window and hit enter, and the program will ask
% you to select the next file. When all the files are analyzed, the vectors
% containing the amplitudes, frequencies, average membrane potential and
% labels can be saved.
% Example for saving results as a .mat file:
% analysis_date = ['labels' minis_labels; 'frequency' num2cell(minis_freq); 'amplitude' num2cell(minis_ampl);  'Vm' num2cell(minis_Vm)];
% save('analysis_date');
% Questions to kelseyclements@brandeis.edu

clear
n = 4; % n = number of files you want to analyze
sample_time_msec = 0.1; % sample time in milliseconds
minis_freq = zeros(1,n); % mini frequencies
minis_ampl  = zeros(1,n); % mini amplitudes
minis_labels = {1,n}; % labels of .mat files, usually the NMJ name ('L1_M6_A3L.mat')
minis_Vm = zeros(1, n); % average membrane potential for each recording

for i = 1:n 
   
clear Volt

% Select file and load data
[filename, pathname] = uigetfile;
cd(pathname);
Chartfile = load(filename);
chart_data = Chartfile.data_block1;


Volt(:,1) = chart_data(1,:);
data_mV = Volt*10^3;
time = (1:length(data_mV))/(1000/sample_time_msec);

% plot
figure
plot(time,data_mV)
ylabel('mV')
xlabel('Time (s)')

% Select start and end points
disp('Click START and END points on the graph');
[x_selected, ~] = ginput(2);

% Convert selected times to indices
start_time = min(x_selected);
end_time   = max(x_selected);

start_idx = find(time >= start_time, 1, 'first');
end_idx   = find(time <= end_time, 1, 'last');

% Restrict data to selected region
data_mV_segment = data_mV(start_idx:end_idx);
time_segment = time(start_idx:end_idx);

% Analyze using GetSpikes.m (make sure GetSpikes parameters are acceptable
% for analysis)
minis_data = GetSpikes(sample_time_msec,data_mV_segment,'findMinis', true, 'plotSubject', true, 'debugPlots',true);
minis_freq(i) = minis_data.freq;
minis_ampl(i) = mean(minis_data.height);
minis_Vm(i) = mean(data_mV_segment); 
minis_labels{i} = filename;
pause
i = i+1;
end


