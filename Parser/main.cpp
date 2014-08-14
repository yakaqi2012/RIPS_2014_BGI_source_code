#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;
void Tokenize(const string& str,
			  vector<string>& tokens,
			  const string& delimiters = ",")
{
	// Skip delimiters at beginning.
	string::size_type lastPos = str.find_first_not_of(delimiters, 0);
	// Find first "non-delimiter".
	string::size_type pos     = str.find_first_of(delimiters, lastPos);

	while (string::npos != pos || string::npos != lastPos)
	{
		// Found a token, add it to the vector.
		tokens.push_back(str.substr(lastPos, pos - lastPos));
		// Skip delimiters.  Note the "not_of"
		lastPos = str.find_first_not_of(delimiters, pos);
		// Find next "non-delimiter"
		pos = str.find_first_of(delimiters, lastPos);
	}
}

bool is_number(const std::string& s)
{
	std::string::const_iterator it = s.begin();
	while (it != s.end() && isdigit(*it)) ++it;
	return !s.empty() && it == s.end();
}

int main()
{
	int numOflines=1653518;
	//ifstream file("data.txt");
	ifstream file("tumor.real.1100.txt");
	ofstream myfile;
	myfile.open ("error.csv");

	string temp;
	char* p;	
	long double hi=0;

	while(getline(file,temp))
	//for(int i=0;i<numOflines;i++)
	{
		//getline(file,temp);
		hi++;
		/*char*pch=new char[temp.size()+1];
		pch[temp.size()]='\0';
		memcpy(pch,temp.c_str(),temp.size());

		char *p=strtok(pch," ");*/

		size_t found = temp.find_first_of(",;:=");
		while (found!=std::string::npos)
		{
			temp[found]=' ';
			found=temp.find_first_of(",;:=",found+1);
		}

		string buf; // Have a buffer string
		stringstream  ss (temp); // Insert the string into a stream
		vector<string> tokens; // Create vector to hold our words

		while (ss >> buf)
			tokens.push_back(buf);

		for (int i=0;i<tokens.size();i++)
		{
			if (tokens[i]=="chr1")  
			{
				myfile<<tokens[i]<<",";// chr1
				myfile<<tokens[++i]<<",";// pos
				cout<<tokens[i]<<endl;
				myfile<<tokens[++i]<<",";// id

				//myfile<<tokens[++i]<<",";//ref
				//myfile<<tokens[++i]<<",";//base
				while(!is_number(tokens[i]))
					i++;//increment until quality number is found

				myfile<<tokens[i]<<",";//quality score
				myfile<<tokens[++i]<<",";  // 5
			}

		

			if(tokens[i]=="DP" && i< 20)
				myfile<<tokens[++i]<<",";  // 6

			if(tokens[i]=="I16")
			{
				myfile<<tokens[++i]<<",";  //7
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";// 16 elements for I16				22
			}

			if(tokens[i]=="PL")
			{
				myfile<<tokens[i=i+3]<<",";
				myfile<<tokens[++i]<<",";
				myfile<<tokens[++i]<<",";
			}
							
		}
			myfile<<"\n";
			cout<<100*hi/numOflines<<" %"<<endl;

	
	}

	myfile.close();


}