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
			this->x = x;
			this->y = y;
		}
		union
		{
			T _x[2];
			struct { T x, y; };
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