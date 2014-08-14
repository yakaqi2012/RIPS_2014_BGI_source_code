#!/usr/bin/python
# -*- coding: utf-8 -*-

import numpy as np
import pylab as pl
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import make_moons, make_circles, make_classification
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.lda import LDA
from sklearn.qda import QDA


names = ["Nearest Neighbors", "Linear SVM", "RBF SVM", "Decision Tree",
         "Random Forest","AdaBoost", "Naive Bayes", "LDA", "QDA"]
classifiers = [
    KNeighborsClassifier(3),
    SVC(kernel="linear", C=0.025),
    SVC(gamma=2, C=1),
    DecisionTreeClassifier(max_depth=5),
    RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    AdaBoostClassifier(),
    GaussianNB(),
    LDA(),
    QDA()]
    
    
 #read training features,training label and testing set   
i_filename = raw_input("Your testing features file name? ")
threshold = input("set your threshold for classification (<1) : ")


x_file = open("training_features.csv", "r")
y_file = open("training_label.csv", "r")
i_file = open(i_filename,"r")


X = []
y = []
I = []
obs = []

#read the training label
for line in y_file:
	y.append(float(line))
# convert to array
y = np.asarray(y)


#read the training features
for line in x_file:
	obs = []
	line = line.split(",")
	for element in line:
		element=float(element)
		obs.append(element)
	X.append(obs[0:62])	
# convert X to array
X = np.asarray(X)


#read the testing features and keep position
for line in i_file:
	obs = []
	line = line.split(",")
	for element in line:
		element=float(element)
		obs.append(element)
	I.append(obs[0:62])
# convert I to array
I = np.asarray(I)



#combine training features and testing features to do PCA
X =  np.concatenate((X,I))

pca = PCA(n_components=2)
pca.fit_transform(X)
PCA(copy=True, n_components=2, whiten=False)
print("******variance ratio******")
print(pca.explained_variance_ratio_)
X=pca.transform(X)

#split the set into training set and testing set
X_train = X[:840]
X_test = X[840:]

linearly_separable = (X_train, y)
datasets = [linearly_separable]
i=1

# iterate over datasets
h=0.05
for ds in datasets:
	# preprocess dataset, split into training and test part
	X_train, y_train = ds
    	X_train = StandardScaler().fit_transform(X_train)
	X_test = StandardScaler().fit_transform(X_test)
	
	
	x_min, x_max = min(X_train[:, 0].min(),X_test[:,0].min()) - .5, max(X_train[:, 0].max(),X_test[:,0].max()) + .5
	y_min, y_max = min(X_train[:, 1].min(),X_test[:,1].min()) - .5, max(X_train[:, 1].max(),X_test[:,1].max()) + .5
	xx, yy = np.meshgrid(np.arange(x_min, x_max, h),np.arange(y_min, y_max, h))

	# just plot the dataset first
	cm = pl.cm.RdBu
	i += 1

i=1
# iterate over classifiers
for name, clf in zip(names, classifiers):
	plt.figure(i) 
	clf.fit(X_train, y_train)
	if hasattr(clf, "predict_proba"):
		label = clf.predict_proba(X_test)[:,1]
		color = ["red" for item in label]
		for t in range(0,len(label)):
			if label[t]>=threshold:
				label[t]=1
				color[t]="blue"
			else:
				label[t]=0
	else:
     		label = clf.predict(X_test)
     		color = ["red" for item in label]
     		for t in range(0,len(label)):
			if label[t]==1:
				color[t]="blue"
     	
    
	# Plot the decision boundary. For that, we will assign a color to each
	# point in the mesh [x_min, m_max]x[y_min, y_max].
	ax = pl.figure(i)
	ax = pl.subplot(len(datasets), 1, 1)
	if hasattr(clf, "decision_function"):
		Z = clf.decision_function(np.c_[xx.ravel(), yy.ravel()])
	else:
		Z = clf.predict_proba(np.c_[xx.ravel(), yy.ravel()])[:, 1]

	# Put the result into a color plot
	Z = Z.reshape(xx.shape)
	ax.contourf(xx, yy, Z, cmap=cm, alpha=.8)

	# and testing points
	ax.scatter(X_test[:, 0], X_test[:, 1], c = color ,alpha=0.6)
	ax.set_xlim(xx.min(), xx.max())
	ax.set_ylim(yy.min(), yy.max())
	ax.set_xticks(())
	ax.set_yticks(())
	ax.set_title(name)
	i += 1

pl.show()

#close all files
x_file.close()
y_file.close()
i_file.close()

