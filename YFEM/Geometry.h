#pragma once
#include "Common.h"
#include "Topology.h"
namespace YFEM
{
	template<typename T>
	struct Point
	{
		Point() :x(0), y(0)
		{
		}
		Point(const T& x, const T& y)
			:x(x), y(y)
		{
		}
		void Set(const T& x, const T& y)
		{
			_x[0] = x;
			_x[1] = y;
		}
		union
		{
			T _x[2];
			T x, y;
		};
	};

	template<typename T>
	struct Rectangle
	{
		Rectangle(T l, T r, T d, T u)
			:l(l), r(r), u(u), d(d)
		{
		}
		T l, r, u, d;
	};

}