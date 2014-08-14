%% super merging file for 1 to 19 pieces
tic;
A = xlsread('label_VECtor.1.xlsx');
B = xlsread('label_VECtor.2.xlsx');
C = xlsread('label_VECtor.3.xlsx');
D = xlsread('label_VECtor.4.xlsx');
E = xlsread('label_VECtor.5.xlsx');
F = xlsread('label_VECtor.6.xlsx');
G = xlsread('label_VECtor.7.xlsx');
H = xlsread('label_VECtor.8.xlsx');
I = xlsread('label_VECtor.9.xlsx');
J = xlsread('label_VECtor.10.xlsx');
K = xlsread('label_VECtor.12.xlsx');
L = xlsread('label_VECtor.13.xlsx');
M = xlsread('label_VECtor.14.xlsx');
N = xlsread('label_VECtor.15.xlsx');
O = xlsread('label_VECtor.16.xlsx');
P = xlsread('label_VECtor.17.xlsx');
Q = xlsread('label_VECtor.18.xlsx');
R = xlsread('label_VECtor.19.xlsx');
Z = [A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R];
[m n]=size(Z)
toc;
xlswrite('label.emerged.xlsx', Z);