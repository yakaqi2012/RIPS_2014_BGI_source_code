function pca_plotter2 
% load .csv file into a matrix
% A = load(file_name);
B = xlsread('Normalization_Done_1.xlsx');
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
csvwrite('PrinciComp_1.csv', Vector);

k=1;
%% plot data 
figure
for i=1:4
    for j=(i+1):5
        %string = strcat('label_vector_1.',num2str(i),num2str(j),'.xlsx');
%         plotclr(SCORES(1:m,i),SCORES(1:m,j),xlsread('label_VEctor.1.xlsx'));
        subplot(2,5,k);
        plotclr(SCORES(1:m,i),SCORES(1:m,j),xlsread('label_VEctor.1.xlsx'));
%         plotc(SCORES(1:m,i),SCORES(1:m,j),'.');
        string1 = strcat('Principal Component ',num2str(i));
        string2 = strcat('Principal Component ',num2str(j));
        xlabel(string1);
        ylabel(string2);
        k=k+1;
        %hold on
    end
end
        

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