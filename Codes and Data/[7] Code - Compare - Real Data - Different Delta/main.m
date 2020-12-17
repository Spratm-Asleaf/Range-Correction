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


%% Start
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
plotTimeIntv = (1:timeLen)*0.1;
dat = dat(:,2);
dat = dat';

no_outlier_dat = dat;

%% Algorithm 1
T = 0.1;
Q = 0.01^2;
MeaThres = 0.7; % Delta in Algorithm 1
N = 3;          % K in Eq. (7)
[Info_1, ~] = KFPolynomial(dat, N, T, Q, MeaThres);

%% Algorithm 1
T = 0.1;
Q = 0.01^2;
MeaThres = 15.0; % Delta in Algorithm 1
N = 3;          % K in Eq. (7)
[Info_2, ~] = KFPolynomial(dat, N, T, Q, MeaThres);

%% Plot true data
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
plot(plotTimeIntv, (Info_1.X(1,:)), 'm-', 'linewidth', 2.5);
legend('Measured','\Delta = 0.7');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);
axis([0 220 0 70]);

figure;
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
plot(plotTimeIntv, (Info_2.X(1,:)), 'm-', 'linewidth', 2.5);
legend('Measured','\Delta = 15');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);
axis([0 220 0 70]);