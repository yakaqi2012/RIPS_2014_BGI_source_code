%% read in the file
%% normalization with the imputation
function normalization_std_filtering
w = input('Normalization method number: ')
A = xlsread('real.emerged.xlsx');
X = xlsread('label.emerged.xlsx');
[m h] = size(A) %% m=808 n=65 807*64
[f g] = size(X)
%% m is the number of length for the labels
n=h-2;
B = A(:,1:n); %%n=62
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
end

Record = zeros(20000,1);
order=1;
COUNTER=1;
%j=1;
%% deleting the  >3  features 
tic;
for i=1:n
    j=1;
    COUNTER=1;
    while j <= m
        if C(j,i) > 3
            Record(order)=A(COUNTER,h);
            C(j,:)=[];
            A(COUNTER,:)=[];
            X(COUNTER)=[];
            m=m-1;
            order=order+1;
        else
            j=j+1;
            COUNTER=COUNTER+1;
        end
    end
end
toc;
%%result1
C = [C,A(:,(h-1):h)];
[m n] = size(C);
xlswrite('Normalization_Imputation_Screening_filtered.xlsx', C);
xlswrite('list_of_deletingSNPs.xlsx', Record);
xlswrite('output.labels.xlsx',X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%