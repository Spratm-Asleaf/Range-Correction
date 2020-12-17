%{
Readers are allowed to edit and distribute this file, only for academic purpose.
But if you decide to use the materials in this file, you are strongly suggested to
also share your codes (e.g., those related to your publications) with publics.

@Information:
Online supplementary materials for the paper titled 
"Denoising, Outlier/Dropout Correction, and Sensor Selection in Range-Based Positioning"
Authored By: Shixiong Wang, Zhongming Wu, and Andrew Lim
From: the Department of Industrial Systems Engineering and Management, National University of Singapore (S. Wang and A. Lim);
and the School of Management Science and Engineering, Nanjing University of Information Science and Technology (Z. Wu).

@Author: Shixiong Wang
@Date: 30 Sep 2020
@Email: s.wang@u.nus.edu; wsx.gugo@gmail.com
%}


%% Denosing and Outlier/Dropout Correction For Real Data
clear all;
close all;
fclose all;
clc;

%% Load Data
infilename = '".\Logs\Tag 18-28-3.log"';
outfilename = '.\Logs\wsx.txt';
cmd = ['.\Logs\main.exe ', infilename, ' ', outfilename];
system(cmd);
infile = fopen(outfilename,'r');
dat = fscanf(infile,'%f',[4,inf])';
fclose(infile);
[timeLen, signalNum] = size(dat);

%% Original Ranges
plotTimeIntv = (1:timeLen)*0.1; % sampling time is 0.1
plot(plotTimeIntv, dat(:,1), 'r', plotTimeIntv, dat(:,2), 'b', plotTimeIntv, dat(:,3), 'm', plotTimeIntv, dat(:,4), 'g', 'linewidth', 2.5);
legend('Range 1','Range 2','Range 3','Range 4');
xlabel('Time (second)','fontsize',14);
ylabel('UWB Range (meter)','fontsize',14);
set(gca,'fontsize',14);

%% Algorithm 1
Info = cell(signalNum,1);
Err = cell(signalNum,1);

T = 0.1;
Q = 0.01^2;
MeaThres = 2.0;     % Delta in Algorithm 1
for i = 1:signalNum
    % Original Range
    figure;
    plot(plotTimeIntv, dat(:,i), 'b', 'linewidth', 2.0);
    hold on;
    
    % Algorithm 1
    [Info{i}, Err{i}] = KFPolynomial(dat(:,i), T, Q, MeaThres);     
    plot(plotTimeIntv, (Info{i}.X(1,:)), 'r--', 'linewidth', 3.5);
    
    % Figure Format
    legend('Original','Corrected');
    xlabel('Time (second)','fontsize',14);
    set(gca,'fontsize',14);
    axis([0 200 0 65]);
end
