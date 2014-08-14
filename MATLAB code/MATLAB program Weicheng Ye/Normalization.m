%% read in the file
%% normalization with the imputation
function Normalization
w = input('Normalization method number: ')
A = xlsread('real.emerged.master.xlsx');
[m h] = size(A) %% m=808 n=65 807*64
n=h-2;
B = A(:,1:n);
%% imputation procedure for average
tic;
B(find(isnan(B)))=0;
AVG = mean(B);
%size(AVG)
for i=1:m
    for j=1:n
        if B(i,j)==0
            B(i,j) = AVG(j);
        end
    end
end
toc;
%%
if w==1
    %% normalization 1
    tic;
    C = B-repmat(mean(B),m,1);
    d = std(B);
    D = repmat(d,m,1);
    i=1;
    counter=1;
    t=n;
    while i <= t
        if d(counter)==0
            C(:,i)=[];
            D(:,i)=[];
            t=t-1;
        else
            i=i+1;
        end
        counter=counter+1;
    end
    C=C./D;
    toc;
    
elseif w == 2
    %% normalization 2
    tic;
    C=B;
    i=1;
    t=n;
    counter=1;
    d = max(abs(B));
    D = repmat(d,m,1);
    while i <= t
        if d(counter) == 0
            C(:,i)=[];
            D(:,i)=[];
            t=t-1;
        else
            i=i+1;
        end
        counter=counter+1;
    end
    C = C./D;
    toc;
end
%%result
C = [C,A(:,(h-1):h)];
xlswrite('Normalization_Imputation_screening_std.xlsx', C);