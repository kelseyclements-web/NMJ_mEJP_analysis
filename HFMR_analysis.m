%% HFMR analysis
% Need to use HFMR_analysis_before_stim and HFMR_analysis_after_stim to
% generate input files
load('HFMR_before_stim_time')
load('HFMR_before_stim_freq')
load ('HFMR_after_stim_time')
load('HFMR_after_stim_freq')
totaltime = [HFMR_before_stim_time; HFMR_after_stim_time+160];
totalfreq = [HFMR_before_stim_freq; HFMR_after_stim_freq];
plot(totaltime, totalfreq)
xlabel('time(s)')
ylabel('mini frequency (hz)')
title(['muscle 6 L1A3R'])
stimtimex = 160; % optional, to mark stim time
stimtimey = 2.0;
hold on
plot(stimtimex, stimtimey, '*')