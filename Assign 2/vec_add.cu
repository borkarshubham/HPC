#include<iostream>
#include<cuda_runtime.h>

using namespace std;

__global__ void vec_add(int *a,int *b,int *c,int n)
{
  int tid = blockIdx.x*blockDim.x+threadIdx.x;
  
  if(tid < n)
  {
    c[tid] = a[tid] +b[tid];
  }
}

int main()
{
  int n = 100;
  
  int a[n],b[n],c[n];
  
  for(int i = 0;i<n;i++)
  {
    a[i] = rand()%100;
    b[i] = rand()%100;
  }
  
  cout<<"The 1st array is :- ";
  for(int i = 0;i<n;i++)
    cout<<a[i]<<"  ";
  
  cout<<endl;
  cout<<"The 2nd array is :- ";
  for(int i = 0;i<n;i++)
    cout<<b[i]<<"  ";
     
   int size = n*sizeof(int);  
     
   int *d_a,*d_b,*d_c;
   
   
   cudaMalloc(&d_a,size);
   cudaMalloc(&d_b,size);
   cudaMalloc(&d_c,size);
   
   cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
   cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);
   
   int n_threads = 256;
   int grid_sz = (int) ceil((float)n/n_threads);
   
   vec_add<<<grid_sz,n_threads>>>(d_a,d_b,d_c,n);
   
   cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
   
    cout<<endl;
    cout<<"The result is :- ";
    for(int i = 0;i<n;i++)
      cout<<c[i]<<"  ";
    
   cudaFree(d_a);
   cudaFree(d_b);
   cudaFree(d_c);
   
 
}
