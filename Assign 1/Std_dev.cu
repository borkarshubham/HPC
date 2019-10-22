 int *arr2;
  int result2;
  cudaMalloc(&arr2,size);
  cudaMemcpy(arr2,a,size,cudaMemcpyHostToDevice);
  
  std_dev<<<1,n/2>>>(arr2,avg);
  
  cudaMemcpy(&result2,arr2,sizeof(int),cudaMemcpyDeviceToHost);
  
  cout<<"****"<<result2;
  float result3 = result2/n;
  result3 = sqrt(result3);
  
  cout<<endl;
  cout<<"The standard deviation is :- "<<result3;
    
  cudaFree(arr1);
  cudaFree(arr2);



__global__ void std_dev(int *input,int a)
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
      
      input[first] = ((input[first]-a) * (input[first]-a));
      input[second] = ((input[second]- a) * (input[second] - a));
      input[first] += input[second];
    }
    
    step_size *= 2;
    num_threads /= 2; 
  }

}
