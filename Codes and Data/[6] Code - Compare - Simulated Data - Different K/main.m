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

%% Generate Data
timeLen = 1200;
plotTimeIntv = (1:timeLen)*0.1;
signal = sqrt(401 + 400*sin(plotTimeIntv*0.1));
dat = signal + 1*randn(1,timeLen);

no_outlier_dat = dat;

%% Algorithm 1
%K = 1
T = 0.1;
Q = 0.05^2;
R = 1^2;
MeaThres = inf; % Delta in Algorithm 1
N = 1;          % K in Eq. (7)
[Info_1, ~] = KFPolynomial(dat, N, T, Q, R, MeaThres);

% K = 2
T = 0.1;
Q = 0.05^2;
R = 1^2;
MeaThres = inf; % Delta in Algorithm 1
N = 2;          % K in Eq. (7)
[Info_2, ~] = KFPolynomial(dat, N, T, Q, R, MeaThres);

%K = 3
T = 0.1;
Q = 0.05^2;
R = 1^2;
MeaThres = inf; % Delta in Algorithm 1
N = 3;          % K in Eq. (7)
[Info_3, ~] = KFPolynomial(dat, N, T, Q, R, MeaThres);

% K = 4
T = 0.1;
Q = 0.05^2;
R = 1^2;
MeaThres = inf; % Delta in Algorithm 1
N = 4;          % K in Eq. (7)
[Info_4, ~] = KFPolynomial(dat, N, T, Q, R, MeaThres);

%% Compare with Algorithm 1
figure;
% Plot true data
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
plot(plotTimeIntv, signal, 'b-', 'linewidth', 3.0);
hold on;
plot(plotTimeIntv, (Info_1.X(1,:)), 'g-.', 'linewidth', 2.5);
hold on;
plot(plotTimeIntv, (Info_2.X(1,:)), 'k:', 'linewidth', 2.5);
hold on;
plot(plotTimeIntv, (Info_3.X(1,:)), 'm-', 'linewidth', 2.5);
hold on;
plot(plotTimeIntv, (Info_4.X(1,:)), 'r--', 'linewidth', 2.5);

% Figure Format
legend('Measured','True','K=1', 'K=2','K=3', 'K=4');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);

%% Calculate MSE
% Table 1
% Note that the results in each trial is different due to randomness, but similar
norm(signal - (Info_1.X(1,:)))^2/timeLen         % K=1
norm(signal - (Info_2.X(1,:)))^2/timeLen         % K=2
norm(signal - (Info_3.X(1,:)))^2/timeLen         % K=3
norm(signal - (Info_4.X(1,:)))^2/timeLen         % K=4

