//standard libraries
#include <iostream>
#include <sstream>
#include <time.h>
#include <omp.h>

//custom includes
#include "dataEntry.h"
#include "dataReader.h"
#include "neuralNetwork.h"

//use standard namespace
using namespace std;

void main()
{	
	//create data set reader
	dataReader d;

	//load data file
	d.loadDataFile("vowel-recognition.csv",4,1);
	d.setCreationApproach( STATIC );

	//create neural network
	neuralNetwork nn(4, 100000, 1);
	nn.enableLogging("trainingResults.csv");
	nn.setLearningParameters(0.001, 0.8);
	nn.setDesiredAccuracy(90);
	nn.setMaxEpochs(10);
	double t1 = omp_get_wtime( );

	//dataset
	dataSet* dset;		
	//clock_t t1 = clock();
	for ( int i=0; i < d.nDataSets(); i++ )
	{
		dset = d.getDataSet();	
		nn.trainNetwork( dset->trainingSet, dset->generalizationSet, dset->validationSet );
	}	
	double t2 = omp_get_wtime( );
	//clock_t t2 = clock();
	std::cout<<"time: "<<(t2-t1)<<std::endl;
	cout << "-- END OF PROGRAM --" << endl;
	char c; cin >> c;
}
