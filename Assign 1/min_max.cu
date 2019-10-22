code = """

#include<iostream>
#include <cstdio>
#include <cstdlib>
#include<cuda_runtime.h>

using namespace std;

__global__ void minimum(int *input)
{
  int step_size = 1;
  int tid = threadIdx.x;
  int num_threads = blockDim.x;
  
  while(num_threads > 0)
  {
    if(tid < num_threads)
    {
      int first = tid*step_size*2;
      int second = first+step_size;
      if(input[second] < input[first])
        input[first] = input[second];
    }
    step_size *= 2;
    num_threads /= 2; 
  }

}


__global__ void maximum(int *input)
{
  int step_size = 1;
  int tid = threadIdx.x;
  int num_threads = blockDim.x;
  
  while(num_threads > 0)
  {
    if(tid < num_threads)
    {
      int first = tid*step_size*2;
      int second = first+step_size;
      if(input[second] > input[first])
        input[first] = input[second];
    }
    
    step_size *= 2;
    num_threads /= 2; 
  }

}

int main()
{
  int n;
  cin>>n;
  srand(n);
  int a[n];
  
  int min = 20000;
  
  for(int i=0;i<n;i++)
  {
    a[i] = rand()%20000;
    if(a[i] < min)
      min = a[i];
    cout<<a[i]<<"   ";
  }
  
  int size = n*sizeof(int);
  int *arr,result;
  
  cudaMalloc(&arr,size);
  cudaMemcpy(arr,a,size,cudaMemcpyHostToDevice);
  
  minimum<<<1,n/2>>>(arr);
  
  cudaMemcpy(&result,arr,sizeof(int),cudaMemcpyDeviceToHost);
  cout<<"The minimum is :- "<<result;
  
  
  int *arr1,result1;
  
  cudaMalloc(&arr1,size);
  cudaMemcpy(arr1,a,size,cudaMemcpyHostToDevice);
  
  maximum<<<1,n/2>>>(arr1);
  
  cudaMemcpy(&result1,arr1,sizeof(int),cudaMemcpyDeviceToHost);
  cout<<"The maximum is :- "<<result1;
    
  cudaFree(arr);
  cudaFree(arr1);
}

"""
