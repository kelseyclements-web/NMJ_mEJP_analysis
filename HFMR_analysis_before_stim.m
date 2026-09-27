% HFMR_analysis_before_stim.m    Mar 2022
% Loads chart files containing recording before HFMR stimulation 
% and determines the frequency of minis in bins.
% Input: Chart files saved as .mat files, consisting of recording before 
% stimulation. After pressing run, you will be able to select file.
% Outputs: HFMR_before_stim_time containing the start point of each bin in s,
% and HFMR_before_stim_freq containing the mini frequency for each 
% corresponding bin.
% Save files after using save function, then use HFMR_analysis.m to generate
% graph
% Example for saving a file:
% save('wt_1', 'HFMR_before_stim_time', 'HFMR_before_stim_freq')

clear
bin_size_s = 20; % bin size in s
recording_size_s = 160; % total recording length in s
n = recording_size_s/bin_size_s; % number of bins (for 20s bins and 3 min recording n = 9)
bin_size_ms = bin_size_s*1000; % bin size in ms

% selecting file and getting raw data
[filename, pathname] = uigetfile;
cd(pathname);
M = load(filename);
chart_data = M.data_block1;
sample_time_msec = 1;

Volt(:,1) = chart_data(1,:);
data_mV = Volt*10^3;
time = (1:length(data_mV))/1000;

% plot potential v. time
figure
plot(time,data_mV)
ylabel('mV')
xlabel('Time (s)')

% time and frequency vectors
HFMR_before_stim_time = zeros(n,1); % beginning of time bin in s
HFMR_before_stim_freq = zeros(n,1); % frequency corresponding to time bin

%% HFMR analysis for 20s bins before stimulation (3 min total recording time)
for i =1:n
    HFMR_before_stim_time(i) = bin_size_s*(i-1);
    bin_begin = (i-1)*(bin_size_ms) + 1;
    bin_end = (i-1)*(bin_size_ms) + bin_size_ms + 1;
    data_mV_bin = data_mV(bin_begin:bin_end); 
    minis_data_bin =  GetSpikes(sample_time_msec,data_mV_bin,'findMinis', true, 'plotSubject', false, 'debugPlots',false);
    HFMR_before_stim_freq(i) = minis_data_bin.freq; 
end

