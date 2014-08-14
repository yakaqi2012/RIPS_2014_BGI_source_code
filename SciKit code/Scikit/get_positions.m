%%  This program takes the output of SciKit, as modified for 
%%  the purposes of RIPS-BGI, and selects only the SNP positions
%%  which more than some threshold number of algorithms classified
%%  as somatic. For example, if the input parameter is 4, then we 
%%  return a list of positions that 4 or more algorithms classified
%%  as the site of a somatic mutation.

function get_positions(scikit_output, threshold)

%% Instance variables
SUM_COLUMN = 10;  

%% Load the scikit output
tic
A = csvread(scikit_output);
display('csv read completed')
toc

%% For each row, look at the sum. Return the row if it is more than 
%% the threshold. 
i=1;
tic
while i <= size(A,1)
    if A(i,10) < threshold
        A(i,:) = [];
    else 
        i=i+1;
    end
end
toc
%% Print the position column to a csv document
%csvwrite('threshold_positions.csv', num2char(A(:,11)),'-double');
tic
writetable(array2table(A(:,11)),'threshold_position.0.9.9.txt','WriteVariableNames',false)
toc
end