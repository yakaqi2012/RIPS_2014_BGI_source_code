%% super merging file for 1 to 19 pieces
tic;
A = xlsread('real.emerged.1.xlsx');
B = xlsread('real.emerged.2.xlsx');
C = xlsread('real.emerged.3.xlsx');
D = xlsread('real.emerged.4.xlsx');
E = xlsread('real.emerged.5.xlsx');
F = xlsread('real.emerged.6.xlsx');
G = xlsread('real.emerged.7.xlsx');
H = xlsread('real.emerged.8.xlsx');
I = xlsread('real.emerged.9.xlsx');
J = xlsread('real.emerged.10.xlsx');
K = xlsread('real.emerged.12.xlsx');
L = xlsread('real.emerged.13.xlsx');
M = xlsread('real.emerged.14.xlsx');
N = xlsread('real.emerged.15.xlsx');
O = xlsread('real.emerged.16.xlsx');
P = xlsread('real.emerged.17.xlsx');
Q = xlsread('real.emerged.18.xlsx');
R = xlsread('real.emerged.19.xlsx');
Z = [A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R];
[m n]=size(Z)
toc;
xlswrite('real.emerged.xlsx', Z);
