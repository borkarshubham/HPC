#include<iostream>
#include<cuda_runtime.h>

using namespace std;

__global__ void mat_mul(int *a,int *b,int *c,int m,int n,int p)
{
  int row = blockIdx.y*blockDim.y+threadIdx.y;
  int col = blockIdx.x*blockDim.x+threadIdx.x;
  int sum = 0;
  
  if(col < p && row < m)
  {
        for(int i=0;i<n;i++)
          sum += a[row*n+i]*b[i*p+col];
        
        c[row*p+col] = sum;    
  }
}

int main()
{
  int m = 5;
  int n = 4;
  int p = 3;
  
  int a[m*n],b[n*p],c[m*p];
    
   for(int i =0;i<m;i++)
   {
      for(int j=0;j<n;j++)
        a[i*n+j] = rand()%100;
   }
   
   for(int i =0;i<n;i++)
   {
      for(int j=0;j<p;j++)
        b[i*p+j] = rand()%100;
   }
  
  cout<<"The 1st matrix is :- "<<endl;
  for(int i =0;i<m;i++)
   {
      for(int j=0;j<n;j++)
        cout<<a[i*n+j]<<"  ";
       cout<<endl;
   }
   
   cout<<"The 2nd matrix is :- "<<endl;
   for(int i =0;i<n;i++)
   {
      for(int j=0;j<p;j++)
        cout<<b[i*p+j]<<"  ";
       cout<<endl;
   }
    
   int mat_size1 = m*n*sizeof(int);
   int mat_size2 = n*p*sizeof(int);
   int a_size = m*p*sizeof(int);
     
   int *d_v,*d_m,*d_a;
   
   cudaMalloc(&d_v,mat_size1);
   cudaMalloc(&d_m,mat_size2);
   cudaMalloc(&d_a,a_size);
   
   cudaMemcpy(d_v,a,mat_size1,cudaMemcpyHostToDevice);
   cudaMemcpy(d_m,b,mat_size2,cudaMemcpyHostToDevice);
   
   dim3 dimGrid(1,1);
   dim3 dimBlock(16, 16);
   
   mat_mul<<<dimGrid,dimBlock>>>(d_v,d_m,d_a,m,n,p);
   
   cudaMemcpy(c,d_a,a_size,cudaMemcpyDeviceToHost);
   
   cout<<endl;
   cout<<"The result is :- "<<endl;   
   for(int i =0;i<m;i++)
   {
      for(int j=0;j<p;j++)
        cout<<c[i*p+j]<<"  ";
       cout<<endl;
   }
    
   cudaFree(d_v);
   cudaFree(d_m);
   cudaFree(d_a);
   
}

"""
