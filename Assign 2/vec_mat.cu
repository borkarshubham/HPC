code= """

#include<iostream>
#include<cuda_runtime.h>

using namespace std;

__global__ void vec_mat(int *a,int *b,int *c,int m,int n)
{
  int tid = blockIdx.x*blockDim.x+threadIdx.x;
  int sum = 0;
  if(tid < n)
  {
    if(tid < n)
    {
        for(int i=0;i<m;i++)
          sum += a[i]*b[i*n+tid];
         
         c[tid] = sum;
    
    }
    
  }
}

int main()
{
  int m = 3;
  int n = 4;
  
  int a[n],b[n*m],c[n];
  
  for(int i = 0;i<m;i++)
    a[i] = rand()%100;
    
   for(int i =0;i<m;i++)
   {
      for(int j=0;j<n;j++)
        b[i*n+j] = rand()%100;
   }
  
  cout<<"The vector is :- ";
  for(int i = 0;i<m;i++)
    cout<<a[i]<<"  ";
    
    
     cout<<endl;
    cout<<"The matrix is :- ";
    for(int i =0;i<m;i++)
   {
      for(int j=0;j<n;j++)
        cout<<b[i*n+j]<<"  ";
       cout<<endl;
   }
  
   int v_size = m*sizeof(int);
   int mat_size = n*m*sizeof(int);
   int a_size = n*sizeof(int);
     
   int *d_v,*d_m,*d_a;
   
   cudaMalloc(&d_v,v_size);
   cudaMalloc(&d_m,mat_size);
   cudaMalloc(&d_a,a_size);
   
   cudaMemcpy(d_v,a,v_size,cudaMemcpyHostToDevice);
   cudaMemcpy(d_m,b,mat_size,cudaMemcpyHostToDevice);
   
   int n_threads = 256;
   
   vec_mat<<<n/256+1,n_threads>>>(d_v,d_m,d_a,m,n);
   
   cudaMemcpy(c,d_a,a_size,cudaMemcpyDeviceToHost);
   
   cout<<endl;
   cout<<"The result is :- ";   
   for(int j=0;j<n;j++)
      cout<<c[j]<<"  ";
    
   cudaFree(d_v);
   cudaFree(d_m);
   cudaFree(d_a);
   
}

"""
