#!/usr/bin/python
# -*- coding: utf-8 -*-

import numpy as np
import sys
import csv

from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import make_moons, make_circles, make_classification
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.lda import LDA
from sklearn.qda import QDA

np.set_printoptions(threshold=sys.maxint)


names = ["Nearest Neighbors", "Linear SVM", "RBF SVM", "Decision Tree","Random Forest", "AdaBoost", "Naive Bayes", "LDA", "QDA"]
classifiers = [
	KNeighborsClassifier(3),
	SVC(kernel="linear", C=0.025),
	SVC(gamma=2, C=1),
	DecisionTreeClassifier(max_depth=5),
	RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
	AdaBoostClassifier(),
	GaussianNB(),
	LDA(),
	QDA()
	]

#read training features,training label and testing set
i_filename = raw_input("Your testing features file name? ")
o_filename = raw_input("Your output label file name? ")
pcacomponents = input("number of PCA components (>=2): ")
threshold = input("set your threshold for classification (<1) : ")


x_file = open("training_features.csv", "r")
y_file = open("training_label.csv", "r")
i_file = open(i_filename,"r")
o_file = open(o_filename,"w")
wr = csv.writer(o_file, quoting=csv.QUOTE_NONE)




X = []
y = []
I = []
pos= []
obs = []
Table = [[],[],[],[],[],[],[],[],[],[],[]]

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
	X.append(obs)
	
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
	pos.append(obs[63])
# convert I to array
I = np.asarray(I)
pos = np.asarray(pos)


#combine training features and testing features to do PCA
X =  np.concatenate((X,I))

pca = PCA(n_components=pcacomponents)
pca.fit_transform(X)
PCA(copy=True, n_components=pcacomponents, whiten=False)
print("******variance ratio******")
print(pca.explained_variance_ratio_)
X=pca.transform(X)

    
#split the set into training set and testing set
X_train = X[:840]#training set
X_test = X[840:]#testing set

linearly_separable = (X_train, y)
datasets = [linearly_separable]
i = 1
# iterate over datasets
for ds in datasets:
	# preprocess dataset, split into training and test part
	X_train, y_train = ds
	X_train = StandardScaler().fit_transform(X_train)
	X_test = StandardScaler().fit_transform(X_test)
	i += 1

j = 1
# iterate over classifiers
for name, clf in zip(names, classifiers):
	#fit the training features and training labels into the classifiers
	clf.fit(X_train, y_train)
	if hasattr(clf, "predict_proba"):
		label = clf.predict_proba(X_test)[:,1]
		for t in range(0,len(label)):
			if label[t]>=threshold:
				label[t]=1
			else:
				label[t]=0
        else:
        	label = clf.predict(X_test)
	Table[j-1][0:] = label
	j += 1
#take the sum of the 9 classifiers

Table[9] = np.add(Table[0],Table[1])
for k in range(2,9):
	Table[9] = np.add(Table[9],Table[k])
	
	
Table[10][0:] = pos
#convert to list
Table = np.asarray(Table).T.tolist()
#output file
wr.writerows(Table)
#close files
x_file.close()
y_file.close()
i_file.close()
o_file.close()
