function pca_plotter2 
% load .csv file into a matrix
% A = load(file_name);
B = xlsread('Normalization_Imputation_screening_max.xlsx');
[m n] = size(B);
A=B(:,1:n-2);
% run PCA on all columns except the last (this is the label column)
[COEFF, SCORES, latent, tsquare] = princomp(A);
[m n] = size(A);
% How much of the variance is accounted for by the first two principle
% components? How about the first three?
%% latent: the dominant eigenvalues vector
variance = cumsum(latent)./sum(latent);
eigenval1 = variance(1)
eigenval2 = variance(2)
eigenval3 = variance(3)

%% print the result for the first two principal component
Vector = [SCORES(:,1),SCORES(:,2)];
csvwrite('PrincipalComponent_max.csv', Vector);
COEff = [COEFF(:,1),COEFF(:,2)];
csvwrite('coeff_max.csv', COEff);

k=1;
%% plot data 
for i=1:4
    for j=(i+1):5
        figure
        plotclr(SCORES(1:m,i),SCORES(1:m,j),xlsread('output.labels.xlsx'));
        string1 = strcat('Principal Component ',num2str(i));
        string2 = strcat('Principal Component ',num2str(j));
        xlabel(string1);
        ylabel(string2);
        hold on
    end
end

figure
plotclr(SCORES(1:m,1),SCORES(1:m,2),xlsread('output.labels.part.xlsx'));
hold on 

figure
plotclr(SCORES(1:m,4),SCORES(1:m,5),xlsread('output.labels.part.xlsx'));
hold on         

% plot data
% plotclr(SCORES(1:m,1),SCORES(1:m,2),xlsread('label_VEctor.1.xlsx'))
% hold on
% plot(SCORES(749:1070,1),SCORES(749:1070,2),'rx')
% xlabel('Principle Component 1')
% ylabel('Principle Component 2')
% legend('somatic','non-somatic')
% 
% figure
% plotclr(SCORES(1:m,1),SCORES(1:m,3),xlsread('label_VEctor.1.xlsx'))
% hold on
% plot(SCORES(751:1084,1),SCORES(751:1084,3),'rx')
% xlabel('Principle Component 1')
% ylabel('Principle Component 3')
% 
% figure
% plotclr(SCORES(1:m,2),SCORES(1:m,3),xlsread('label_VEctor.1.xlsx'))
% hold on
% plot(SCORES(751:1084,2),SCORES(751:1084,3),'rx')
% xlabel('Principle Component 2')
% ylabel('Principle Component 3')
% 
% figure 
% plot3(SCORES(1:750,1),SCORES(1:750,2),SCORES(1:750,3),'.')
% hold on
% plot3(SCORES(751:1084,1),SCORES(751:1084,2),SCORES(751:1084,3),'r.')