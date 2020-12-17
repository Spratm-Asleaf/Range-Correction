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


%% Sensor Selection
clear all;
close all;
fclose all;
clc;

%% Load data
infilename = '".\Logs\Tag0 50m.log"';
outfilename = '.\Logs\wsx.txt';
cmd = ['.\Logs\main.exe ', infilename, ' ', outfilename];
system(cmd);
infile = fopen(outfilename,'r');
dat = fscanf(infile,'%f',[4,inf])';
[timeLen, signalNum] = size(dat);
fclose(infile);

%% Original Ranges
plotTimeIntv = (1:timeLen)*0.1;
plot(plotTimeIntv, dat(:,1), 'r-', plotTimeIntv, dat(:,2), 'b--', plotTimeIntv, dat(:,3), 'm:', plotTimeIntv, dat(:,4), 'g-.', 'linewidth', 3);
legend('Range 0','Range 1','Range 2','Range 3');
xlabel('Time (second)','fontsize',14);
ylabel('UWB (meter)','fontsize',14);
set(gca,'fontsize',14);

%% Algorithm 1
Info = cell(signalNum,1);
Err = cell(signalNum,1);
figure;
T = 0.1;
Q = 0.01^2;
MeaThres = inf; % Delta in Algorithm 1
color = 'r- b-.m: g--';
for i = 1:signalNum
    [Info{i}, Err{i}] = KFPolynomial(dat(:,i), T, Q, MeaThres); % Algorithm 1
    plot(plotTimeIntv, abs(Info{i}.X(3,:)), color(3*i - 2:3*i), 'linewidth', 2);
    hold on;
end

%% Algorithm 2
L = 50;
Omega = 15;
bad_sensor_index = FourChooseOne(Info, L, Omega);
plot(plotTimeIntv, bad_sensor_index, 'k', 'linewidth', 3);

%% Figure Format
legend('Range 0','Range 1','Range 2','Range 3','Bad Sensor');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);