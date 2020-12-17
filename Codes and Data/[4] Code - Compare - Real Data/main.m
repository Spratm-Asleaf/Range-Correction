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

%% Algorithm 1 (K = 3)
T = 0.1;
Q = 0.01^2;
MeaThres = 2.0; % Delta in Algorithm 1
N = 3;          % K in Eq. (7)
% Algorithm 1
[Info, Err] = KFPolynomial(dat, N, T, Q, MeaThres);

%% Compare with K = 3
figure;
% Plot true data
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
% plot(plotTimeIntv, signal, 'b-', 'linewidth', 3.0);
% hold on;
plot(plotTimeIntv, (Info.X(1,:)), 'm-', 'linewidth', 2.5);

% K=2
T = 0.1;
Q = 0.01^2;
MeaThres = 2.0; % Delta in Algorithm 1
N = 2;          % K in Eq. (7)
[Info_Holt, ~] = KFPolynomial(dat, N, T, Q, MeaThres);
plot(plotTimeIntv, (Info_Holt.X(1,:)), 'r--', 'linewidth', 2.5);

% K=1
T = 0.1;
Q = 0.01^2;
MeaThres = 5.0; % Delta in Algorithm 1
N = 1;          % K in Eq. (7)
[Info_Local_Level, ~] = KFPolynomial(dat, N, T, Q, MeaThres);
plot(plotTimeIntv, (Info_Local_Level.X(1,:)), 'g-.', 'linewidth', 2.5);

% One-sided median method [24], see section 3.2 therein
y = dat;
yy = [y(1) y];
z = diff(yy);
K = 10;
tao_tilde = 8;
for t = 2*K + 1:timeLen
    m_tilde_t_y = median(y(t-2*K:t-1));
    m_tilde_t_z = median(z(t-2*K:t-1));
    
    m_tilde_t_2K = m_tilde_t_y + K * m_tilde_t_z;   % predicted value for y_t
    
    if abs(y(t) - m_tilde_t_2K) < tao_tilde
        % do nothing to keep this y_t
    end
    
    if abs(y(t) - m_tilde_t_2K) > tao_tilde
        % this is an outlier and do replacement
        y(t) = m_tilde_t_2K;
    end
end
plot(plotTimeIntv, y, ':', 'color', [1,0.5,0], 'linewidth', 2.5);

% Figure Format
legend('Measured','K=3', 'K=2', 'K=1', 'One-sided Median');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);
axis([0 270 0 70]);

% Robust Kalman Filter [22], see section 3.2 therein
figure;
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
% plot(plotTimeIntv, signal, 'b-', 'linewidth', 3.0);
% hold on;
plot(plotTimeIntv, (Info.X(1,:)), 'r--', 'linewidth', 2.5);
T = 0.1;
Q = 0.1^2;
N = 3;          % K in Eq. (7)
[Info_Robust, ~] = Robust_KFPolynomial(dat, N, T, Q);
plot(plotTimeIntv, (Info_Robust.X(1,:)), 'm-.', 'linewidth', 2.5);

% Figure Format
legend('Measured','Algorithm 1', 'Robust Filtering');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);
axis([0 200 -5 80]);