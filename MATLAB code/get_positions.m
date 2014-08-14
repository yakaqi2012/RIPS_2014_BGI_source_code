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
A = csvread(scikit_output);

%% For each row, look at the sum. Return the row if it is more than 
%% the threshold. 
while i <= size(A,1)
    if A(i,10) < threshold
        A(i,:) = [];
    else 
        i++
    end
end

%% Print the position column to a csv document
csvwrite('threshold_positions.csv', A(:,11));
end