% mEJP analysis_individual_amps.m Sep 2022
% updates mEJP analysis to store the amplitude of each individual mini for each
% recording
% Loads chart files and determines the frequency and amplitude for each
% recording and puts them in vectors.
% Chart files must be saved as .mat files, and must only contain the
% portion of the recording you want to analyze. 
% Before running, change the 'n' (2nd line of code) to the number of files 
% you want to analyze. After pressing run, the program will ask you to 
% select the first file. It will analyze the data and display the
% recording. If it looks acceptable, hit enter, and the program will ask
% you to select the next file. When all the files are analyzed, the vectors
% containing the amplitudes, frequencies, average membrane potential and labels can be saved as a
% genotype or condition so they can be analyzed later. 
% Example for saving a .mat file:
% save('wt', 'minis_freq', 'minis_ampl', 'minis_Vm', 'minis_labels')
% Questions to kelseyclements@brandeis.edu

clear
n = 5; % n = number of files you want to analyze
minis_freq = zeros(1,n); % mini frequencies
minis_ampl  = zeros(1,n); % mini amplitudes
minis_labels = {1,n}; % labels of .mat files, usually the NMJ name ('L1_M6_A3L.mat')
minis_Vm = zeros(1, n); % average membrane potential for each recording
minis_ind_amps = zeros(n, 200); %store individual amplitudes max = 200 minis

for i = 1:n 
   
clear Volt
[filename, pathname] = uigetfile;
cd(pathname);
M = load(filename);
chart_data = M.data_block1;
sample_time_msec = 1;

Volt(:,1) = chart_data(1,:);
data_mV = Volt*10^3;
time = (1:length(data_mV))/1000;

% plot
figure
plot(time,data_mV)
ylabel('mV')
xlabel('Time (s)')


minis_data = GetSpikes(sample_time_msec,data_mV,'findMinis', true, 'plotSubject', true, 'debugPlots',false);
minis_freq(i) = minis_data.freq;
minis_ampl(i) = mean(minis_data.height);
individual_amps = minis_data.height;
number_minis = length(individual_amps);
minis_ind_amps(i,1:number_minis) = individual_amps;
minis_Vm(i) = mean(data_mV); 
minis_labels{i} = filename;

pause
i = i+1;
end


