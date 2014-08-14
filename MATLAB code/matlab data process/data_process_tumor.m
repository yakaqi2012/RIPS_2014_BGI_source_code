clear all;
tic;
inputFileName1 = input('input tumor file name for samtools? *.txt/*.csv ', 's');
inputFileName2 = input('input tumor file name for GATK? *.txt/*.csv ', 's');
outputFileName = input('output file name?  *.txt ', 's');


output = cell (1,42);%construct the outputFile!!!remember to modify


%% start to combine
%to read samtools and GATK
inputFile1 = fopen(inputFileName1);
textLine1 = fgetl(inputFile1);%read a line
inputFile2 = fopen(inputFileName2);
textLine2 = fgetl(inputFile2);
outputFile = fopen(outputFileName,'w');

numLine=1;

while (ischar(textLine1)==1)&&(ischar(textLine2)==1)
    
    token1 = textscan(textLine1,'%s','delimiter',{',','/',';','"','=',':','\t',' ','\b'},'MultipleDelimsAsOne',true);
    token1 = token1{1,1};
    token1 = transpose(token1);
    tokenSize1 = size(token1);
    
    token2 = textscan(textLine2,'%s','delimiter',{',','/',';','"','=',':','\t',' ','\b'},'MultipleDelimsAsOne',true);
    token2 = token2{1,1};
    token2 = transpose(token2);
    tokenSize2 = size(token2);
    
    %count the number of alternative genotype G1 in samtools
    t1=5;
    altGeno1 = char(token1(t1));
    while (isletter(altGeno1)==1)
         t1=t1+1;
         altGeno1 = char(token1(t1));
    end
    if(altGeno1=='.')
         t1=t1+1;    
    end
        G1=t1-5;
        
    %count the number of alternative genotype G2 in GATK
    t2=5;
    altGeno2 = char(token2(t2));
    while (isletter(altGeno2)==1)
         t2=t2+1;
         altGeno2 = char(token2(t2));
    end
    if (altGeno2=='.')
       t2=t2+1;
    end
        G2=t2-5;
    
              
    %% check the position
    currentpos1 = str2double(token1{1,2});
    currentpos2 = str2double(token2{1,2});
    
    if (currentpos1==currentpos2)
            
        % check ref and alt length
        if (length(token1{1,4})==1)&&(length(token2{1,4})==1)&&(length(token1{1,5})==1)&&(length(token2{1,5})==1)      
    % for the common part chr and position
    
    output{1,1} = token1{1,2};%the position  #1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %for the samtools part
    

    
    %the reference genome #19
    if(token1{1,4}=='X')
                    refgenoIndex1 = '0';
    elseif(token1{1,4}=='A')
                    refgenoIndex1 = '1';
    elseif(token1{1,4}=='C')
                    refgenoIndex1 = '2';
    elseif(token1{1,4}=='G')
                    refgenoIndex1 = '3';
    elseif(token1{1,4}=='T')
                    refgenoIndex1 = '4';
    else            refgenoIndex1 = '.';
    end
       output{1,19} = refgenoIndex1;

    %the alternative genome #20
                altgeno1 = '';
    for k=1:G1 
                if(token1{1,4+k}=='X')
                    altgenoIndex = '0';
                elseif(token1{1,4+k}=='A')
                    altgenoIndex = '1';
                elseif(token1{1,4+k}=='C')
                    altgenoIndex = '2';
                elseif(token1{1,4+k}=='G')
                    altgenoIndex = '3';
                elseif(token1{1,4+k}=='T')
                    altgenoIndex = '4';
                end
                altgeno1 = strcat(altgeno1,altgenoIndex);
    end
                output{1,20} = altgeno1;
                
    
    for j = 1:tokenSize1(2);
        read1 = token1(j);
        if j < 13
            if (sum((read1{1,1}=='D')+(read1{1,1}=='P'))==2)%set DP 1 compoment #2
                output(1,2) = token1(j+1);
            end
        end 
            if (strcmp(read1,'I16')==1)%set I16 16 components #3-18
                output(1,3) = token1(j+1);
                output(1,4) = token1(j+2);
                output(1,5) = token1(j+3);
                output(1,6) = token1(j+4);
                output(1,7) = token1(j+5);
                output(1,8) = token1(j+6);
                output(1,9) = token1(j+7);
                output(1,10) = token1(j+8);
                output(1,11) = token1(j+9);
                output(1,12) = token1(j+10);
                output(1,13) = token1(j+11);
                output(1,14) = token1(j+12);
                output(1,15) = token1(j+13);
                output(1,16) = token1(j+14);
                output(1,17) = token1(j+15);
                output(1,18) = token1(j+16);
            elseif (strcmp(read1,'PL')==1)%set PL 3 components   #21-23
                output{1,21} = token1{1,j+3};
                plmax = 0;
                plsum = 0;
            for k=2:3*G1;
                plmax = max(plmax,str2double(token1{1,j+2+k}));
                plsum = plsum + str2double(token1{1,j+2+k});
            end
                output{1,22} = num2str(plmax);
                output{1,23} = num2str(plsum);
            end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %for the GATK part
    
    %the QUAL from GATK #24
    output{1,24} = token2{1,5+G2};
    
    %set DP 1 compoment #28
    for j = 1:tokenSize2(2);
        read2 = token2(j);
        if j==tokenSize2(2)-3
            if (sum((read2{1,1}=='D')+(read2{1,1}=='P'))==2)
                output{1,28} = token2{j+3};
            end
        elseif j==tokenSize2(2)-8
            if (sum((read2{1,1}=='D')+(read2{1,1}=='P'))==2)
                output{1,28} = token2{j+1};
            end
        elseif j==tokenSize2(2)-11
            if (sum((read2{1,1}=='D')+(read2{1,1}=='P'))==2)
                output{1,28} = token2{j+7};
            end
        end
        
        
            if (sum((read2{1,1}=='A')+(read2{1,1}=='C'))==2)%set AC 1 compoment #25
                output(1,25) = token2(j+1);
            elseif (sum((read2{1,1}=='A')+(read2{1,1}=='F'))==2)%set AF 1 compoment #26
                output(1,26) = token2(j+1); 
            elseif (sum((read2{1,1}=='A')+(read2{1,1}=='N'))==2)%set AN 1 component #27
                output(1,27) = token2(j+1);
            elseif (sum((read2{1,1}=='D')+(read2{1,1}=='e')+(read2{1,1}=='l')+(read2{1,1}=='s'))==4)%set Dels 1 compoment #29
                output(1,29) = token2(j+1); 
            elseif (strcmp(read2,'HaplotypeScore')==1)%set HaplotypeScore 1 compoment #30
                output(1,30) = token2(j+1);
            elseif (strcmp(read2,'MQ')==1)%set MQ 1 compoment #31
                output(1,31) = token2(j+1);    
            elseif (strcmp(read2,'MQ0')==1)%set MQ0 1 compoment #32
                output(1,32) = token2(j+1);
            elseif (sum((read2{1,1}=='Q')+(read2{1,1}=='D'))==2)%set QD 1 compoment #33
                output(1,33) = token2(j+1);
            elseif (sum((read2{1,1}=='S')+(read2{1,1}=='B'))==2)%set SB 1 compoment #34
                output(1,34) = token2(j+1);  
            elseif (sum((read2{1,1}=='A')+(read2{1,1}=='D'))==2)%set AD 2 compoment #35-36
                output(1,35) = token2(j+6);
                output(1,36) = token2(j+7);
            elseif (sum((read2{1,1}=='G')+(read2{1,1}=='Q'))==2)%set GQ 1 compoment #37
                output(1,37) = token2(j+7);
            elseif (strcmp(read2,'PL')==1)%set PL G components #40-42  
            for k=1:3;
                output(1,39+k) = token2(j+6+k);
            end
            end
     end
            %the reference genome #38
             if(token2{1,4}=='X')||(token2{1,4}=='.')
                    refgenoIndex2 = '0';
             elseif(token2{1,4}=='A')
                    refgenoIndex2 = '1';
             elseif(token2{1,4}=='C')
                    refgenoIndex2 = '2';
             elseif(token2{1,4}=='G')
                    refgenoIndex2 = '3';
             elseif(token2{1,4}=='T')
                    refgenoIndex2 = '4';
             else refgenoIndex2 = '.';
             end
       output{1,38} = refgenoIndex2;
            %the alternative genome #39
             altgeno2 = '';
    for k=1:G2
               
                if(token2{1,4+k}=='X')
                    altgenoIndex = '0';
                elseif(token2{1,4+k}=='A')
                    altgenoIndex = '1';
                elseif(token2{1,4+k}=='C')
                    altgenoIndex = '2';
                elseif(token2{1,4+k}=='G')
                    altgenoIndex = '3';
                elseif(token2{1,4+k}=='T')
                    altgenoIndex = '4';
                end
                altgeno2 = strcat(altgeno2,altgenoIndex);
    end
                output{1,39} = altgeno2;
                
                %% start to write a line
                outputline='';
               
                for i=1:42
                    outputline=strcat(outputline,output(i));
                    outputline=strcat(outputline,',');
                end
                
                fprintf(outputFile,'%s\n',outputline{1,1});
    
                %% get the next line and refresh 
                
                if (~feof(inputFile1))&&(~feof(inputFile2))
                textLine1 = fgetl(inputFile1);
                textLine2 = fgetl(inputFile2);
                output = cell(1,42);
                numLine=numLine+1;
                else break;
                end
                

                disp(numLine);
                
        
        end
        elseif(currentpos1>currentpos2)
            if (~feof(inputFile2))
            textLine2 = fgetl(inputFile2);
            else textLine2 = -1;
            end
            continue;
        elseif(currentpos1<currentpos2)
            if (~feof(inputFile1))
            textLine1 = fgetl(inputFile1);
            else textLine1 = -1;
            end
            continue;
    end
end

fclose(inputFile1);
fclose(inputFile2);
fclose(outputFile);
toc;