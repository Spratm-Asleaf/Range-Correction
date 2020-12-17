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

%% Denoising Using Exponential Smoothing
clear all;
close all;
fclose all;
clc;

%% Load Data
outfilename = '.\Logs\wsx.txt';
infile = fopen(outfilename,'r');
dat = fscanf(infile,'%f',[4,inf])';
dat = dat(1:150,:);                 % only use a part of signal
fclose(infile);
[timeLen, signalNum] = size(dat);

plotTimeIntv = (1:timeLen)*0.1;     % sampling time is 0.1

%% Original Ranges
hold on;
plot(plotTimeIntv, dat(:,1), 'color', [0.7,0.7,0.7]*0.8, 'linewidth', 3);

%% ETS
EstimtRangeETS = zeros(1,timeLen);
a = 0.25;                               % use 0.25 or 0.75 here
w1 = dat(1,1);
for i = 1:timeLen
    w1 = a*dat(i,1) + (1-a)*w1;
    EstimtRangeETS(i) = w1;
end
hold on;
plot(plotTimeIntv, EstimtRangeETS, 'm', 'linewidth', 3);

%% Algorithm 1
Info = cell(1,1);
Err = cell(1,1);
T = 0.1;
Q = 0.01^2;
MeasThres = 2.0;     % Delta in Algorithm 1
[Info, Err] = KFPolynomial(dat(:,1), T, Q, MeasThres);
hold on;
plot(plotTimeIntv, (Info.X(1,:)),'b-.', 'linewidth', 3);

%% Figure Format
legend('Noised Range','Denoised Range (ETS)','Denoised Range (This paper)');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);
axis([0 15 0.7 4]);