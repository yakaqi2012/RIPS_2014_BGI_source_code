OBJS = main.o
CC = g++
DEBUG = -g
CFLAGS = -Wall -c $(DEBUG)
LFLAGS = -Wall -fopenmp  $(DEBUG)

main : main.o
	$(CC) $(LFLAGS) $(OBJS) -o main

main.o : main.cpp dataEntry.h dataReader.h neuralNetwork.h
	$(CC) $(CFLAGS) main.cpp

clean:
	\rm *.o main

tar:
	tar cfv main.tar main.cpp dataEntry.h dataReader.h neuralNetwork.h