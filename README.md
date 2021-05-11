> @Author: WANG Shixiong (Email: <s.wang@u.nus.edu>; <wsx.gugo@gmail.com>)

> @Affiliate: Department of Industrial SystemsEngineering and Management, National University of Singapore

> @Date: Uploaded on Sep 30, 2020; Updated on Dec 17, 2020

> MATLAB Version: 2016A or later

# Range Correction

Online complementary materials of the paper titled 

**Denoising, Outlier/Dropout Correction, and Sensor Selection in Range-Based Positioning**

Published in the _IEEE Transactions on Instrumentation and Measurement_ (DOI: [10.1109/TIM.2021.3078537](http://dx.doi.org/10.1109/TIM.2021.3078537))

By Shixiong Wang, Zhongming Wu, and Andrew Lim

From the Department of Industrial Systems Engineering and Management, National University of Singapore (S. Wang and A. Lim);
and the School of Management Science and Engineering, Nanjing University of Information Science and Technology (Z. Wu).


## ***See Also***

Please refer to our another paper for theoretical issues of the presented method: 

https://github.com/Spratm-Asleaf/TVLAP-KF


## ***Supplementary Materials***

* The file "Supplementary Materials.pdf" contains the materials that help understand the paper, including another example for sensor anomaly in Fig. 2 and **possible questions from readers**. See contents below.
    ```
    1. Another Example for Sensor Anomaly
    2. If the abnormality (especially continuous anomalies) occurs when the real measurement suddenly changes, 
       can the algorithm cope with it?
    3. What’s the rationale of the model (1)?
    4. What’s the rationale behind the model (12)? The noise process W(n) affects x(n+1) in a correlated way. 
       Why is it reasonable?
    5. Why the authors did not record the time stamps of dropouts and try to recover these locations?
    6. How to obtain (9)?
    7. Why the previously estimated position has not been considered?
    8. Why the difference method is not suitable for estimating the derivative of a time series?
    ```

    
## ***Codes and Data***

* [1] The folder "[1] Code - Denoising - ETS" contains the codes to generate Fig. 8 in the paper

* [2] The folder "[2] Code - Denoising and Outlier Correction - Real Data" contains the codes to generate Fig. 1 and Fig. 9 in the paper

* [3] The folder "[3] Code - Sensor Selection" contains the codes to generate Fig. 2, Fig. 4, and Fig. 20 in the paper

* [4] The folder "[4] Code - Compare - Real Data" contains the codes to generate Fig. 10 and Fig. 11 in the paper

* [5] The folder "[5] Code - Compare - Simulated Data - Sine Range" contains the codes to generate Table I, Fig. 17, Fig. 18, and Fig. 19 in the paper

* [6] The folder "[6] Code - Compare - Simulated Data - Different K" contains the codes to generate Table II in the paper

* [7] The folder "[7] Code - Compare - Real Data - Different Delta" contains the codes to generate Fig. 13 in the paper

* [8] The folder "[8] Code - Position Compare - Real Data" contains the codes to generate Fig. 12 and Fig. 14 in the paper

* [9] The folder "[9] Data - Supplementary" contains the source data related to the supplementary materials

