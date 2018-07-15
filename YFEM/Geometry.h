#pragma once
#include "Common.h"
#include "Topology.h"
namespace YFEM
{
	template<typename T>
	struct Point
	{
		Point(T& x, T& y)
		{
			x[0] = x;
			x[1] = y;
		}
		Set(T&x, T&y)
		{
			x[0] = x;
			x[1] = y;
		}
		T x[2];
	};

}