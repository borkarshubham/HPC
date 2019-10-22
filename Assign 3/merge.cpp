#include<iostream>
#include<omp.h>
#include<chrono>
#include "omp.h"

using namespace std;
using namespace std::chrono;

void gen(int a[], int b[],int n)
{
	for(int i=0;i<n;i++)
		a[i]=b[i] = n-i;
}

void merge(int a[],int i1,int i2,int e1,int e2)
{
	int* temp = new int[e2-i1+1];
	
	int s1 = i1;
	int s2 = e1;
	
	int k=0;
	
	while(s1 <= i2 && s2 <= e2)
	{
		if(a[s1] < a[s2])
			temp[k++] = a[s1++];
			
		else
			temp[k++] = a[s2++];
	}
	
	while(s1 <= i2)
		temp[k++] = a[s1++];
		
	while(s2 <= e2)
		temp[k++] = a[s2++];
		
	s2 = 0;
	
	for(s1 = i1;s1<= e2;s1++)
		a[s1] = temp[s2++]; 
}

void serial_merge(int a[], int low, int high)
{
	int mid;
	
	if(low < high)
	{
		mid = (high + low)/2;
		serial_merge(a,low,mid);
		serial_merge(a,mid+1,high);
		merge(a,low,mid,mid+1,high);	
	}
}

void parallel_merge(int a[], int low, int high)
{
	int mid;
	
	omp_set_num_threads(2);
	
	if(low < high)
	{
		mid = (high + low)/2;
		
		#pragma omp sections
		{
			#pragma omp section
			{
				serial_merge(a,low,mid);
			}
			
			#pragma omp section
			{
				serial_merge(a,mid+1,high);
			}
		}
		
		merge(a,low,mid,mid+1,high);	
	}
}

int main()
{
	int n;
	cout<<"Enter the size :- ";
	cin>>n;
	
	int a[n];
	int b[n];
	
	gen(a,b,n);
	
	time_point<system_clock> start,end;
	start = system_clock::now();
	serial_merge(a,0,n-1);
	end = system_clock::now();
	
	duration<double> time = end-start;
	cout<<"\nThe time for serial merge is :- "<<time.count()*1000<<endl; 
	
	cout<<"The sorted array is:- "<<endl;
	for(int i=0;i<n;i++)
		cout<<a[i]<<"  ";
	
	cout<<endl;
	start = system_clock::now();
	parallel_merge(b,0,n-1);
	end = system_clock::now();
	
	time = end-start;
	cout<<"\nThe time for parallel merge is :- "<<time.count()*1000<<endl;
	 
	cout<<"The sorted array is:- "<<endl;	
	for(int i=0;i<n;i++)
		cout<<a[i]<<"  ";
}
