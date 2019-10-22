#include<iostream>
#include <mpi.h>
#include<chrono>
#include <time.h>

using namespace std;
using namespace std::chrono;

void binary_serach(int a[],int k,int n,int r,int bsz)
{
	int flag = 0;
	int mid;
	int f = r*4/n;
	f++;
	
	while(r < bsz)
	{
		mid = (r+bsz)/2;
		
		if(k == a[mid])
		{	
			cout<<"The key is found at Processor No. "<<f<<" at index "<<mid<<endl;
			flag = 1;
			break;
		}
		
		else if(k < a[mid])
			bsz = mid;
			
		else
			r = mid+1;
	}
	
	if(flag == 0)
		cout<<"Not found at Processor No. "<<f<<"\n";
} 


int main(int argc, char **argv)
{
	int n = 8000;
	int key = 3000;
	int a[n];
	
	for(int i=0;i<n;i++)
		a[i] = i;
		
	int rank,size;
	
	MPI_Init(&argc,&argv);
	
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	
	size = n/4;
	
	if(rank == 0)
	{
		double start = MPI_Wtime();
		
		binary_serach(a,key,n,rank*size,(rank+1)*size-1);
		
		double end = MPI_Wtime();
		
		cout<<"The time taken by 1st processor :- "<<(end-start)*1000<<endl;
	}
	 
	if(rank == 1)
	{
		double start = MPI_Wtime();
		
		binary_serach(a,key,n,rank*size,(rank+1)*size-1);
		
		double end = MPI_Wtime();
		
		cout<<"The time taken by 2nd processor :- "<<(end-start)*1000<<endl;
	}
	
	if(rank == 2)
	{
		double start = MPI_Wtime();
		
		binary_serach(a,key,n,rank*size,(rank+1)*size-1);
		
		double end = MPI_Wtime();
		
		cout<<"The time taken by 3rd processor :- "<<(end-start)*1000<<endl;
	}
	
	if(rank == 3)
	{
		double start = MPI_Wtime();
		
		binary_serach(a,key,n,rank*size,(rank+1)*size-1);
		
		double end = MPI_Wtime();
		
		cout<<"The time taken by 4th processor :- "<<(end-start)*1000<<endl;
	}

	MPI_Finalize();

}
