import numpy

# X is 1084 x 2
# y is 1084 x 1

x_file = open("X.csv", "r")
y_file = open("y.csv", "r")

X = []
y = []
obs = []
for line in y_file:
    y.append(float(line))
# convert to array
y = numpy.asarray(y)

for line in x_file:
    obs = []
    x1,x2 = line.split(",")
    obs.append(float(x1))
    obs.append(float(x2[0:len(x2)-2]))
    obs = numpy.asarray(obs)
    X.append(obs)
# convert X to array
X = numpy.asarray(X)
	
print X
