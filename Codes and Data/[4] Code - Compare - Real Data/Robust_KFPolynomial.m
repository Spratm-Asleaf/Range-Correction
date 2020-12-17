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

function [Info, Err] = Robust_KFPolynomial(Z, N, T, Q)
    %% Robust Kalman Filter, see [22]
    %N = 3;  % K in Eq. (7)

    F = [];  % Phi in Eq. (12)
    f_vec = [];
    for i = 1:N
        f_vec = [f_vec T^(i-1)/factorial(i-1)];
    end

    F = [F; f_vec];
    for i = 2:N
        F = [F; [zeros(1, i-1) f_vec(1:N-i+1)]];
    end

    G = F;  % G in Eq. (12)
    G = G(:,end);

    H = [1 zeros(1,N-1)];  % H in Eq. (12)

    R = (0.05/3)^2;  % R in Eq. (12)

    P = eye(N, N)*1e5;
    X = zeros(N, 1) + 0.0000001;

    len = length(Z);
    XRecord = zeros(N,len);
    PRecord = cell(1,len);
    Err     = zeros(1,len);
    
    %% Signal Processing Paras
    InitSignalExceptionCount = 3;
    isSignalException = false;

    for i = 1:len
        %% Measurement
        if InitSignalExceptionCount >= 0
            InitSignalExceptionCount = InitSignalExceptionCount - 1;
            if InitSignalExceptionCount < 0
                isSignalException = true;
            end
        end
        
        %% Kalman
        X = F*X;
        Z_ = H*X;
        
        P = F*P*F' + G*Q*G';
        
        Err(i) = Z(i) - Z_;
        if isSignalException
            gamma = Err(i)' * (H*P*H' + R)^-1 * Err(i);     % Eq. (30) of [22]
            
            chi_square_0_01 = 6.63;         % 1% confidence
            chi_square_0_0001 = 15.14;      % 0.01% confidence
            beta = 1.0;
            if gamma <= chi_square_0_01                     % Eq. (34) of [22]
                beta = 1.0;
            elseif gamma > chi_square_0_01 && gamma <= chi_square_0_0001
                beta = gamma/chi_square_0_01;
            elseif gamma > chi_square_0_0001
                beta = 1e6;         % infinity
            end

            R = R * beta;                                   % Eq. (32) of [22]
            
            zz = Z(i);
        else
            zz = Z(i);
        end

        K = P*H'*(H*P*H' + R)^-1;
        X = X + K*(zz - Z_);

        XRecord(:,i) = X;

        P = (eye(N,N) - K*H)*P*(eye(N,N) - K*H)' + K*R*K';

        PRecord{i} = P;
    end
    
    Info.X = XRecord;
    Info.P = PRecord;
end