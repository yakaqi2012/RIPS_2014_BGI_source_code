%% program for merging normal and tumor files
pos_col = 1;                      %% POS column 
alt_col_NS = 12;%% ALT column
alt_col_NG = 27;
alt_col_TS = 20;
alt_col_TG = 39;
%A = textscan('normal.sam.50000.csv','Delimiter',',');  %% normal xlsx
%B = textscan('tumor.sam.50000.csv','Delimiter',','); %% tumor xlsx
%A = csvread('normal.real.1.csv');
%B = csvread('tumor.real.1.csv');

NR_file = fopen('normal.real.12.csv');
TR_file = fopen('tumor.real.12.csv');
%NR_file = fopen('normal.sam.50000.csv');
%TR_file = fopen('tumor.sam.50000.csv');
textLineN = fgetl(NR_file);
textLineT = fgetl(TR_file);
output_fileN = fopen('writeNormal.12.csv','w');
output_fileT = fopen('writeTumor.12.csv','w');

%nhand = 1; %% points to current position in normal genome
%thand = 1; %% points to current position in tumor genome
%[m n] = size(A);                  
%[s t] = size(B);
numLine=0;
tic;
while (ischar(textLineN)==1) && (ischar(textLineT)==1) 
    tokenN = textscan(textLineN,'%s','delimiter',',');
    tokenN = tokenN{1,1};
    tokenN = transpose(tokenN);
    tokenT = textscan(textLineT,'%s', 'delimiter', ',');
    tokenT = tokenT{1,1};
    tokenT = transpose(tokenT);
    posN = str2double(tokenN(1));
    posT = str2double(tokenT(1));
     if posN == posT
                         %% start to write a line
%                 outputline1='';
%                 for i=1:29
%                     outputline1=strcat(outputline1,tokenN(i));
%                     outputline1=strcat(outputline1,',');
%                 end 
%                 outputline1=strcat(outputline1,tokenN(30));
                fprintf(output_fileN,'%s\n',textLineN);
%                 outputline2='';
%                 for i=1:41
%                     outputline2=strcat(outputline2,tokenT(i));
%                     outputline2=strcat(outputline2,',');
%                 end
%                 outputline2=strcat(outputline2,tokenT(42));
                fprintf(output_fileT,'%s\n',textLineT);
                if (~feof(NR_file))&&(~feof(TR_file))
                    textLineN = fgetl(NR_file);
                    textLineT = fgetl(TR_file);
                    tokenN = cell(1,30);
                    tokenT = cell(1,42);
                    numLine=numLine+1;
                else break;
                end
     elseif posN > posT
         if ~feof(TR_file)
             textLineT = fgetl(TR_file);
             tokenT = cell(1,42);
         else break;
         end
     else %%posN<posT
         if ~feof(NR_file)
             textLineN = fgetl(NR_file);
             tokenN = cell(1,30);
         else break;
         end
     end
      %% get the next line and refresh          
end
    
    
%% Get rid of positions which are not present in both the normal and cancer files

% while nhand<=size(A(:,1),1) && thand <= size(B(:,1),1)
%     %% If the positions are the same, keep both rows
%     if A(nhand,pos_col) == B(thand,pos_col)
%         nhand = nhand + 1;
%         thand = thand + 1;
%     %% If the position on the normal genome is greater, throw out current tumor position
%     elseif A(nhand,pos_col) > B(thand,pos_col)
%         B(thand,:) = [];
%     %% If the position on the tumor genome is greater, throw out current normal position
%     elseif A(nhand,pos_col) < B(thand,pos_col)
%         A(nhand,:) = [];
%     end
% end

%% deleting the rest rows
% [x y] = size(A)
% [a b] = size(B)
% if x>a
%     A((a+1):x,:)=[];
% elseif x<a
%     B((x+1):a,:)=[];
% end
toc;
%% close the files
fclose(output_fileN);
fclose(output_fileT);

%% next procedure: Throw out positions that are not SNP sites in either the normal or the tumor files
nuMLine=0;
NR_file = fopen('writeNormal.12.csv');
TR_file = fopen('writeTumor.12.csv');
textLineN = fgetl(NR_file);
textLineT = fgetl(TR_file);
output_fileN = fopen('condensedNormal.12.csv','w');
output_fileT = fopen('condensedTumor.12.csv','w');

while (ischar(textLineN)==1) && (ischar(textLineT)==1) 
    tokenN = textscan(textLineN,'%s','delimiter',',');
    tokenN = tokenN{1,1};
    tokenN = transpose(tokenN);
    tokenT = textscan(textLineT,'%s', 'delimiter', ',');
    tokenT = tokenT{1,1};
    tokenT = transpose(tokenT);
    altNS = str2double(tokenN(12));
    altNG = str2double(tokenN(27));
    altTS = str2double(tokenT(20));
    altTG = str2double(tokenT(39));
    if (altNS ~=0) || (altNG~=0) || (altTS~=0) || (altTG~=0)
%         outputline1='';
%         for i=1:30
%             outputline1=strcat(outputline1,tokenN(i));
%             outputline1=strcat(outputline1,',');
%         end
        fprintf(output_fileN,'%s\n',textLineN);
%         outputline2='';
%         for i=1:42
%             outputline2=strcat(outputline2,tokenT(i));
%             outputline2=strcat(outputline2,',');
%         end
        fprintf(output_fileT,'%s\n',textLineT);
        if ~feof(NR_file)  %% &&(~feof(TR_file))
            textLineN = fgetl(NR_file);
            textLineT = fgetl(TR_file);
            tokenN = cell(1,30);
            tokenT = cell(1,42);
            nuMLine=nuMLine+1;
        else break;
        end
    else
        if ~feof(TR_file)
            textLineT = fgetl(TR_file);
            tokenT = cell(1,42);
            textLineN = fgetl(NR_file);
            tokenN = cell(1,30);
        else break;
        end
    end
end
fclose(output_fileN);
fclose(output_fileT);    
   
A = xlsread('condensedNormal.12.csv');
B = xlsread('condensedTumor.12.csv');
%% Throw out positions that are not SNP sites in either the normal or the tumor files
i = 1;
while i <= size(A(:,1),1)
    if A(i,alt_col_NS)==0 && A(i, alt_col_NG)==0 && B(i,alt_col_TS)==0 && B(i,alt_col_TG)==0
        A(i,:) = [];
        B(i,:) = [];
    else
        i = i + 1;
    end
end
%% print the size of normal and tumor matrices
[x y] = size(A)
[a b] = size(B)
%% record the vector D for assumed labels
D=zeros(x,1);
tic;
for i=1:x
    if  A(i,alt_col_NS)~=B(i,alt_col_TS) || A(i,alt_col_NG)~=B(i,alt_col_TG)            
        %%(A(i,alt_col_12)~=0 && B(i,alt_col_20)~=0) && (A(i,alt_col_27)~=0 && B(i,alt_col_39)~=0) 
              %% case for germline
        D(i)=0.2; %% somatic mutation is red
    else
        D(i)=2; %% germline is blue
    end
end
D(x) = 0;
%xlswrite('label_vector_1.xlsx', D);
xlswrite('label_VECtor.12.xlsx', D);
toc;
%% C: the matrix which includes all the features we need
C=zeros(x,64);
%% first 20 features for normal by SAMtools; next 20 features for tumor by GATK
C(:,1:9) = A(:,2:10);
C(:,10:12) = A(:,13:15);
C(:,13:29) = B(:, 2:18);
C(:,30:32) = B(:, 21:23);
%%
C(:,33:42) = A(:,16:25);
C(:,43:45) = A(:,28:30);
C(:,46:59) = B(:,24:37);
C(:,60:62) = B(:,40:42);
C(:,63) = round(rand(x,1));
C(:,64) = A(:,1);
%% sorting and finding method

%% print out C which lists all the features from SAMtools and GATK for both normal and tumor
%xlswrite('sam_emerged.xlsx', C);
xlswrite('real.emerged.12.xlsx',C);



