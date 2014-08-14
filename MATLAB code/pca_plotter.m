function [X,y] = pca_plotter(file_name)

% load .csv file into a matrix
A = load(file_name);

% run PCA on all columns except the last (this is the label column)
[COEFF, SCORES, latent, tsquare] = princomp(A(:,1:end-1));

% How much of the variance is accounted for by the first two principle
% components? How about the first three?
variance = cumsum(latent)./sum(latent);
'Variance accounted for by first two components: ' + variance(2)
'Variance accounted for by first three components: ' + variance(3)



% plot data
plot(SCORES(1:750,1),SCORES(1:750,2),'o')
hold on
plot(SCORES(751:1084,1),SCORES(751:1084,2),'rx')
xlabel('Principle Component 1')
ylabel('Principle Component 2')


figure
plot(SCORES(1:750,1),SCORES(1:750,3),'x')
hold on
plot(SCORES(751:1084,1),SCORES(751:1084,3),'rx')
xlabel('Principle Component 1')
ylabel('Principle Component 3')

figure
plot(SCORES(1:750,2),SCORES(1:750,3),'.')
hold on
plot(SCORES(751:1084,2),SCORES(751:1084,3),'rx')
xlabel('Principle Component 2')
ylabel('Principle Component 3')

figure 
plot3(SCORES(1:750,1),SCORES(1:750,2),SCORES(1:750,3),'.')
hold on
plot3(SCORES(751:1084,1),SCORES(751:1084,2),SCORES(751:1084,3),'r.')

X = SCORES(:,1:2);
y = A(:,end);
end