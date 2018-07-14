#pragma once
#include <iostream>
#include <vector>
#include <math.h>
#define _USE_MKL
#define _USE_CUDA

#ifdef _USE_MKL
#include <mkl.h>
#endif // _USE_MKL


#ifdef _USE_CUDA
#include "cuda_runtime.h"
#include "cuda.h"
#include "device_launch_parameters.h"
#endif // _USE_CUDA

#define MAX(a,b) (a>b)?a:b
#define MIN(a,b) (a<b)?a:b

namespace YFEM
{
	typedef int				index_t;
	typedef int				dgree_t;
	typedef unsigned int	count_t;
	typedef unsigned char	byte_t;
	typedef unsigned short	word_t;
	typedef unsigned int	dword_t;


}

#define TEST 1