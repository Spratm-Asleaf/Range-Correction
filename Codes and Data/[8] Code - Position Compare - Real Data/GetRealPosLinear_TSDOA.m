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

function avg_Pos = GetRealPosLinear_TSDOA(BasePos, Dist, Team, isDesigning)
    row = length(Team(:,1));        % How many combinations in total built by every 4 anchors
    Pos = zeros(row, 2);            %
    for i = 1:row
        base_index = Team(i,:);
        
        D = Dist(base_index);
        BP = BasePos(:, base_index);

        lamda = [
            D(2)^2 - D(1)^2 - (BP(1,2))^2 + (BP(1,1))^2 - (BP(2,2))^2 + (BP(2,1))^2;
            D(3)^2 - D(1)^2 - (BP(1,3))^2 + (BP(1,1))^2 - (BP(2,3))^2 + (BP(2,1))^2;
        ];

        A = 2*[
            (BP(1,1) - BP(1,2))     (BP(2,1) - BP(2,2))
            (BP(1,1) - BP(1,3))     (BP(2,1) - BP(2,3))
        ];
    
        p = A^-1*lamda;
        Pos(i,:) = p';
    end

    if isDesigning
        avg_Pos = Pos;
    else
        avg_Pos = zeros(2,1);
        
        for j = 1:2
            for i = 1:row
                avg_Pos(j) = avg_Pos(j) + Pos(i,j);
            end
            avg_Pos(j) = avg_Pos(j)/row;
        end 
    end
end
