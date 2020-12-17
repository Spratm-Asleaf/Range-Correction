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

%% Anchors
dimLength = 61;  % x axis
dimWidth  = 4.3; % y axis
dimHeight_up = 2.2; % z axis for base A0~A3
BasePos_0 = [0;             0;                  dimHeight_up];          % A0
BasePos_1 = [0;             dimWidth;           dimHeight_up];          % A1
BasePos_2 = [dimLength;     dimWidth;           dimHeight_up];          % A2
BasePos_3 = [dimLength;     0;                  dimHeight_up];          % A3

BasePos = [
    BasePos_0   BasePos_1   BasePos_2   BasePos_3
];

%% Every 3 anchors make a base-group for positioning
Team = [
% 0 and 1 cannot be simutaneously used because the errors (i.e., innate biases) contained in 0
% and 1 would significantly degrade the positioning performances if they
% jointly paticipate in positioning
%     0 1 2       % A0 + A1 + A2
%     0 1 3       % A0 + A1 + A3
    0 2 3       % A0 + A2 + A3
    1 2 3       % A1 + A2 + A3
] + 1;

%% Load Original Range Measurement
load Original_Range;

% timeLen: how many range measurements (how many discrete time index)
% signalNum = 4: four anchors
% column 1: range from A0
% column 2: range from A1
% column 3: range from A2
% column 4: range from A3
[timeLen, signalNum] = size(Original_Range);
plotTimeIntv = (1:timeLen)*0.1;     % sampling time, 0.1 second

%% Data Structure to Store Corrected Ranges
Corrected_Range_Algo_1 = zeros(timeLen, signalNum);
Corrected_Range_Holt = zeros(timeLen, signalNum);
Corrected_Range_Local_Level = zeros(timeLen, signalNum);
Corrected_Range_One_Sided_Median = zeros(timeLen, signalNum);
Corrected_Range_Robust = zeros(timeLen, signalNum);

%% Do Range Correction
for sig =  1:signalNum
    dat = Original_Range(:,sig);
    dat = dat';

    % Algorithm 1 (K=3)
    T = 0.1;
    Q = 0.01^2;
    MeaThres = 2.0; % Delta in Algorithm 1
    N = 3;          % K in Eq. (7)
    [Info, Err] = KFPolynomial(dat, N, T, Q, MeaThres);
    Corrected_Range_Algo_1(:,sig) = Info.X(1,:);

    % K = 2
    T = 0.1;
    Q = 0.01^2;
    MeaThres = 2.0; % Delta in Algorithm 1
    N = 2;          % K in Eq. (7)
    [Info_Holt, ~] = KFPolynomial(dat, N, T, Q, MeaThres);
    Corrected_Range_Holt(:,sig) = Info_Holt.X(1,:);

    % K = 1
    T = 0.1;
    Q = 0.01^2;
    MeaThres = 5.0; % Delta in Algorithm 1
    N = 1;          % K in Eq. (7)
    [Info_Local_Level, ~] = KFPolynomial(dat, N, T, Q, MeaThres);
    Corrected_Range_Local_Level(:,sig) = Info_Local_Level.X(1,:);

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
    Corrected_Range_One_Sided_Median(:,sig) = y;

    % Robust Method [22]
    T = 0.1;
    Q = 0.05^2;
    N = 3;          % K in Eq. (7)
    [Info_Robust, ~] = Robust_KFPolynomial(dat, N, T, Q);
    Corrected_Range_Robust(:, sig) = Info_Robust.X(1,:);
end

%% Plot Error Distribution
figure;
hist(Original_Range(:,1) - Corrected_Range_Algo_1(:,1),100,'r');
set(gca,'fontsize',14);
xlabel('Range Error (meter)', 'fontsize', 16);
axis([-50 15 0 30]);
h = findobj(gca,'Type','patch');
h.FaceColor = [1 0 0];
h.EdgeColor = 'w';

%% Do Positioning
Position_Algo_1 = zeros(timeLen, 2);    % 2-dimensional
Position_Holt = zeros(timeLen, 2);
Position_Local_Level = zeros(timeLen, 2);
Position_One_Sided_Median = zeros(timeLen, 2);
Position_Robust = zeros(timeLen, 2);

Position_Measured = zeros(timeLen, 2);

% Plot the first round
for time = 1:945        %945:timeLen for second round
    Position_Measured(time,:) = GetRealPosLinear_TSDOA(BasePos, Original_Range(time,:), Team, false);
    Position_Algo_1(time,:) = GetRealPosLinear_TSDOA(BasePos, Corrected_Range_Algo_1(time, :), Team, false);
    Position_Holt(time,:) = GetRealPosLinear_TSDOA(BasePos, Corrected_Range_Holt(time, :), Team, false);
    Position_Local_Level(time,:) = GetRealPosLinear_TSDOA(BasePos, Corrected_Range_Local_Level(time, :), Team, false);
    Position_One_Sided_Median(time,:) = GetRealPosLinear_TSDOA(BasePos, Corrected_Range_One_Sided_Median(time, :), Team, false);
    Position_Robust(time,:) = GetRealPosLinear_TSDOA(BasePos, Corrected_Range_Robust(time, :), Team, false);  
end

%% Plot Positions
figure; hold on;
plot(Position_Measured(:,1), Position_Measured(:,2), 'marker', '*', 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
plot(Position_Algo_1(:,1), Position_Algo_1(:,2), 'm-', 'linewidth', 2.0);

legend('Measured', 'Algorithm 1');
set(gca,'fontsize',14);
axis([0-2 dimLength+2 0-2 dimWidth + 3]);

% Plot for Comparison
figure; hold on;
plot(Position_Measured(:,1), Position_Measured(:,2), 'marker', '*', 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
plot(Position_Algo_1(:,1), Position_Algo_1(:,2), 'm-', 'linewidth', 2.0);
plot(Position_Holt(:,1), Position_Holt(:,2), 'r--', 'linewidth', 2.5);
plot(Position_Local_Level(:,1), Position_Local_Level(:,2), 'g-.', 'linewidth', 2.5);
plot(Position_One_Sided_Median(:,1), Position_One_Sided_Median(:,2), ':', 'color', [1,0.5,0], 'linewidth', 2.5);

legend('Measured', 'K=3', 'K=2', 'K=1', 'One-sided Median');
set(gca,'fontsize',14);
axis([0-2 dimLength+2 0-2 dimWidth + 6]);

% Plot for Robust Method
figure;
hold on;
plot(Position_Measured(:,1), Position_Measured(:,2), 'marker', '*', 'color', [0.1 0.1 0.1]*6, 'linewidth', 2.0);
plot(Position_Algo_1(:,1), Position_Algo_1(:,2), 'r-', 'linewidth', 2.0); hold on;
plot(Position_Robust(:,1), Position_Robust(:,2), 'm-.', 'linewidth', 2.5);

legend('Measured', 'Algorithm 1', 'Robust');
set(gca,'fontsize',14);
axis([0-2 dimLength+2 0-2 dimWidth + 3]);
