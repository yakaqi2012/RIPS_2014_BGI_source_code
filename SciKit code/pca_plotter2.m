function [X,y] = pca_plotter2(file_name)

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
plot(SCORES(1:748,1),SCORES(1:748,2),'o')
hold on
plot(SCORES(749:1070,1),SCORES(749:1070,2),'rx')
xlabel('Principle Component 1')
ylabel('Principle Component 2')
legend('somatic','non-somatic')

X = SCORES(:,1:2);
y = A(:,end);

csvwrite('X2.csv', X)
csvwrite('y2.csv', y)
end
