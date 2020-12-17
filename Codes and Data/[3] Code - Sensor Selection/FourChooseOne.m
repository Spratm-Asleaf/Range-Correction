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


function index = FourChooseOne(Info, sub_seq_Length, Thres)
    % Get the signal length
    len = length(Info{1}.X(1,:));
    X = zeros(4,len);

    % Use the second order derivative as the feature
    k = 2+1; % Note: k = 0 + 1, 0-order derivative; k = 1 + 1, 1-order derivative
    for i = 1:4
        X(i,:) = abs(Info{i}.X(k,:));
    end

    % Align the data
    X = [zeros(4,sub_seq_Length) X];
    
    % Do Selection
    index = [];
    for T = sub_seq_Length+1:sub_seq_Length+len
        % Calculate the "p = 1 norm"
        dist = zeros(4,4);
        for i = 1:4
            for j = 1:4
                dist(i,j) = norm(X(i,T-sub_seq_Length:T) - X(j,T-sub_seq_Length:T),1);
            end
        end

        % Do Classification
        D = zeros(1,4);
        for i = 1:4
            for j = 1:4
    %             if i ~= j Note that when i == j, dist(i,j) = 0
                D(i) = D(i) + dist(i,j);
    %             end
            end
        end
        D = D/3;

        [~,i] = max(D);
        DD = D;DD(i) = 0;
        if D(i) - mean(DD) < Thres
            i = 0;
        end

        index = [index i];
    end
    
    index = index - 1;
end