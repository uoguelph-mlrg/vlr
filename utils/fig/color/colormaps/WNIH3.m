function [cmap] = WNIH3()
% colormap: National Institute of Health (NIH)
% hardcoded 256 levels :(
% good contrast throughout though
% *warped*: higher contrast at low levels
cmap = ...
[           0            0            0
     0.030303            0     0.060606
     0.060605            0      0.12121
     0.090908            0      0.18182
      0.12121            0      0.24243
      0.15151            0      0.30303
      0.18182            0      0.36364
      0.21212            0      0.42424
      0.24242            0      0.48485
      0.27272            0      0.54546
      0.30303            0      0.60606
      0.33333            0      0.66667
      0.31818            0      0.68182
      0.30303            0      0.69697
      0.28788            0      0.71212
      0.27272            0      0.72728
      0.25757            0      0.74243
      0.24242            0      0.75758
      0.22727            0      0.77273
      0.21212            0      0.78788
      0.19697            0      0.80303
      0.18182            0      0.81818
      0.16667            0      0.83334
      0.15151            0      0.84849
      0.13636            0      0.86364
      0.12121            0      0.87879
      0.10606            0      0.89394
     0.090908            0      0.90909
     0.075757            0      0.92424
     0.060605            0      0.93939
     0.045454            0      0.95455
     0.030303            0       0.9697
     0.015151            0      0.98485
            0            0            1
            0     0.019608            1
            0     0.039215            1
            0     0.058823            1
            0     0.078431            1
            0     0.098038            1
            0      0.11765            1
            0      0.13725            1
            0      0.15686            1
            0      0.17647            1
            0      0.19608            1
            0      0.21568            1
            0      0.23529            1
            0       0.2549            1
            0      0.27451            1
            0      0.29411            1
            0      0.31372            1
            0      0.33333            1
            0       0.3492      0.98413
            0      0.36508      0.96825
            0      0.38095      0.95238
            0      0.39682      0.93651
            0       0.4127      0.92064
            0      0.42857      0.90476
            0      0.44444      0.88889
            0      0.46032      0.87302
            0      0.47619      0.85714
            0      0.49206      0.84127
            0      0.50794       0.8254
            0      0.52381      0.80953
            0      0.53968      0.79365
            0      0.55556      0.77778
            0      0.57143      0.76191
            0       0.5873      0.74603
            0      0.60318      0.73016
            0      0.61905      0.71429
            0      0.63492      0.69842
            0       0.6508      0.68254
            0      0.66667      0.66667
            0      0.68421      0.66667
            0      0.70176      0.66667
            0       0.7193      0.66667
            0      0.73684      0.66667
            0      0.75439      0.66667
            0      0.77193      0.66667
            0      0.78948      0.66667
            0      0.80702      0.66667
            0      0.82456      0.66667
            0      0.84211      0.66667
            0      0.85965      0.66667
            0      0.87719      0.66667
            0      0.89474      0.66667
            0      0.91228      0.66667
            0      0.92983      0.66667
            0      0.94737      0.66667
            0      0.96491      0.66667
            0      0.98246      0.66667
            0            1      0.66667
     0.034483            1      0.64368
     0.068966            1      0.62069
      0.10345            1       0.5977
      0.13793            1      0.57472
      0.17241            1      0.55173
       0.2069            1      0.52874
      0.24138            1      0.50575
      0.27586            1      0.48276
      0.31034            1      0.45977
      0.34483            1      0.43678
      0.37931            1       0.4138
      0.41379            1      0.39081
      0.44828            1      0.36782
      0.48276            1      0.34483
      0.51724            1      0.32184
      0.55172            1      0.29885
      0.58621            1      0.27586
      0.62069            1      0.25287
      0.65517            1      0.22989
      0.68966            1       0.2069
      0.72414            1      0.18391
      0.75862            1      0.16092
       0.7931            1      0.13793
      0.82759            1      0.11494
      0.86207            1     0.091954
      0.89655            1     0.068966
      0.93103            1     0.045977
      0.96552            1     0.022989
            1            1            0
            1       0.9899            0
            1       0.9798            0
            1       0.9697            0
            1       0.9596            0
            1      0.94949            0
            1      0.93939            0
            1      0.92929            0
            1      0.91919            0
            1      0.90909            0
            1      0.89899            0
            1      0.88889            0
            1      0.87879            0
            1      0.86869            0
            1      0.85859            0
            1      0.84848            0
            1      0.83838            0
            1      0.82828            0
            1      0.81818            0
            1      0.80808            0
            1      0.79798            0
            1      0.78788            0
            1      0.77778            0
            1      0.76768            0
            1      0.75758            0
            1      0.74747            0
            1      0.73737            0
            1      0.72727            0
            1      0.71717            0
            1      0.70707            0
            1      0.69697            0
            1      0.68687            0
            1      0.67677            0
            1      0.66667            0
            1      0.65657            0
            1      0.64646            0
            1      0.63636            0
            1      0.62626            0
            1      0.61616            0
            1      0.60606            0
            1      0.59596            0
            1      0.58586            0
            1      0.57576            0
            1      0.56566            0
            1      0.55556            0
            1      0.54545            0
            1      0.53535            0
            1      0.52525            0
            1      0.51515            0
            1      0.50505            0
            1      0.49495            0
            1      0.48485            0
            1      0.47475            0
            1      0.46465            0
            1      0.45455            0
            1      0.44444            0
            1      0.43434            0
            1      0.42424            0
            1      0.41414            0
            1      0.40404            0
            1      0.39394            0
            1      0.38384            0
            1      0.37374            0
            1      0.36364            0
            1      0.35354            0
            1      0.34343            0
            1      0.33333            0
            1      0.32323            0
            1      0.31313            0
            1      0.30303            0
            1      0.29293            0
            1      0.28283            0
            1      0.27273            0
            1      0.26263            0
            1      0.25253            0
            1      0.24242            0
            1      0.23232            0
            1      0.22222            0
            1      0.21212            0
            1      0.20202            0
            1      0.19192            0
            1      0.18182            0
            1      0.17172            0
            1      0.16162            0
            1      0.15152            0
            1      0.14141            0
            1      0.13131            0
            1      0.12121            0
            1      0.11111            0
            1      0.10101            0
            1     0.090909            0
            1     0.080808            0
            1     0.070707            0
            1     0.060606            0
            1     0.050505            0
            1     0.040404            0
            1     0.030303            0
            1     0.020202            0
            1     0.010101            0
            1            0            0
      0.99107            0            0
      0.98213            0            0
       0.9732            0            0
      0.96427            0            0
      0.95534            0            0
       0.9464            0            0
      0.93747            0            0
      0.92854            0            0
      0.91961            0            0
      0.91067            0            0
      0.90174            0            0
      0.89281            0            0
      0.88388            0            0
      0.87494            0            0
      0.86601            0            0
      0.85708            0            0
      0.84815            0            0
      0.83922            0            0
      0.83028            0            0
      0.82135            0            0
      0.81242            0            0
      0.80349            0            0
      0.79455            0            0
      0.78562            0            0
      0.77669            0            0
      0.76776            0            0
      0.75882            0            0
      0.74989            0            0
      0.74096            0            0
      0.73203            0            0
      0.72309            0            0
      0.71416            0            0
      0.70523            0            0
       0.6963            0            0
      0.68736            0            0
      0.67843            0            0
      0.66667            0            0];