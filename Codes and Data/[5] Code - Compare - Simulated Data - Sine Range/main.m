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


%% Denosing and Outlier/Dropout Correction For Simulated Data
%% Important NOTE:
% Note that this file occasionally fails to work.
% But if  "MeaThres" is set large, say, 5/10 rather than 2, the odds of failure could be lowered.
% Alternatively, when the outliers/dropouts are spaerer, this file very works well again.
% So far, we do not know how dense outliers is the upper bound that this
% algorithm can handle. This will be a future work.


%% Start
clear all;
close all;
fclose all;
clc;

%% Generate Data
timeLen = 1200;
plotTimeIntv = (1:timeLen)*0.1;
signal = sqrt(401 + 400*sin(plotTimeIntv*0.1));
dat = signal + 0.1*randn(1,timeLen);

no_outlier_dat = dat;

% Add 20 ouotliers
No = 20;
outlier_index = randi(timeLen, 1, No);
for i = 1:No
    dat(outlier_index(i)) = dat(outlier_index(i)) + (5 + 50*rand);
end

% Add 100 dropouts
No = 100;
outlier_index = randi(timeLen, 1, No);
for i = 1:No
    dat(outlier_index(i)) = 0;
end

% Plot true data
plot(plotTimeIntv, dat, 'b', 'linewidth', 2.0);
hold on;
plot(plotTimeIntv, signal, 'm-.', 'linewidth', 2.0);
hold on;

%% Algorithm 1 (K=3)
T = 0.1;
Q = 0.01^2;
MeaThres = 2.0; % Delta in Algorithm 1
N = 3;          % K in Eq. (7)
% Algorithm 1
[Info, Err] = KFPolynomial(dat, N, T, Q, MeaThres);
plot(plotTimeIntv, (Info.X(1,:)), 'r--', 'linewidth', 3.5);

% Figure Format
legend('Measured','True','Corrected');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);

%% Compare with K = 3
figure;
% Plot true data
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
plot(plotTimeIntv, signal, 'b-', 'linewidth', 3.0);
hold on;
plot(plotTimeIntv, (Info.X(1,:)), 'm-', 'linewidth', 2.5);

% K = 2
T = 0.1;
Q = 0.01^2;
MeaThres = 2.0; % Delta in Algorithm 1
N = 2;          % K in Eq. (7)
[Info_Holt, ~] = KFPolynomial(dat, N, T, Q, MeaThres);
plot(plotTimeIntv, (Info_Holt.X(1,:)), 'r--', 'linewidth', 2.5);

% K = 1
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
tao_tilde = 2;
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
legend('Measured','True','K=3', 'K=2', 'K=1', 'One-sided Median');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);

% Robust Kalman Filter [22], see section 3.2 therein
figure;
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
plot(plotTimeIntv, signal, 'b-', 'linewidth', 3.0);
hold on;
plot(plotTimeIntv, (Info.X(1,:)), 'r--', 'linewidth', 2.5);
T = 0.1;
Q = 0.05^2;
N = 3;          % K in Eq. (7)
[Info_Robust, ~] = Robust_KFPolynomial(dat, N, T, Q);
plot(plotTimeIntv, (Info_Robust.X(1,:)), 'm-.', 'linewidth', 2.5);

% Figure Format
legend('Measured','True','Algorithm 1', 'Robust Filtering');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);


%% Calculate MSE
% Table 1
% Note that the results in each trial is different due to randomness, but similar
norm(signal - (Info.X(1,:)))^2/timeLen              % K = 3
norm(signal - (Info_Holt.X(1,:)))^2/timeLen         % K = 2
norm(signal - (Info_Local_Level.X(1,:)))^2/timeLen  % K = 1
norm(signal - y)^2/timeLen                          % One-sided Median
norm(signal - (Info_Robust.X(1,:)))^2/timeLen       % Robust Kalman Filter [22]
norm(signal - no_outlier_dat)^2/timeLen             % Non-denoised without outliers/dropouts
norm(signal - dat)^2/timeLen                        % Non-denoised with outliers/dropouts

if norm(signal - (Info.X(1,:)))^2/timeLen > 100
    msgbox({'Error occurred due to extremely dense outliers/dropouts.'...
        'Experiment occasionally failed at this trial.'...
        'Please see comments in the beginning of the codes.'...
        'You may run this file again.'},'Author Tip','error');
    return;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%        When outliers are sparse and the signal is slow-changing       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Robust Fitering [22]
figure;
signal = 1 + plotTimeIntv;
dat = signal + 0.1*randn(1,timeLen);
% Add 2 ouotliers
No = 2;
outlier_index = randi(timeLen, 1, No);
for i = 1:No
    dat(outlier_index(i)) = dat(outlier_index(i)) + (5 + 50*rand);
end
% Add 2 dropouts
No = 2;
outlier_index = randi(timeLen, 1, No);
for i = 1:No
    dat(outlier_index(i)) = 0;
end
% Plot true data
no_outlier_dat = dat;
plot(plotTimeIntv, dat, 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
hold on;
plot(plotTimeIntv, signal, 'b-', 'linewidth', 2.0);
hold on;
% Algorithm 1
T = 0.1;
Q = 0.01^2;
MeaThres = 2.0; % Delta in Algorithm 1
N = 3;          % K in Eq. (7)
[Info, Err] = KFPolynomial(dat, N, T, Q, MeaThres);
plot(plotTimeIntv, (Info.X(1,:)), 'r--', 'linewidth', 2.5);
% Robust Kalman Filter [22], see section 3.2 therein
T = 0.1;
Q = 0.05^2;
N = 3;          % K in Eq. (7)
[Info_Robust, ~] = Robust_KFPolynomial(dat, N, T, Q);
plot(plotTimeIntv, (Info_Robust.X(1,:)), 'm-.', 'linewidth', 2.5);
% Figure Format
legend('Measured','True','Algorithm 1', 'Robust Fitering');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);
% sub-figure
% axes('position',[0.55,0.55,0.5,0.5]);
% time = 1000:1200;
% plot(plotTimeIntv(time), (Info.X(1,time)), 'r--', 'linewidth', 2.5);
% hold on;
% plot(plotTimeIntv(time), (Info_Robust.X(1,time)), 'm-.', 'linewidth', 2.5);
