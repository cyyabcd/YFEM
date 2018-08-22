#pragma once
#include "Common.h"
#include "Geometry.h"
namespace YFEM 
{
	template<typename T>
	class RectangleDomain
	{
	public:
		RectangleDomain()
			:height(0), width(0), r(real_t<T>::min), l(real_t<T>::max), d(real_t<T>::max), u(real_t<T>::min)
		{
		}

		~RectangleDomain()
		{

		}

		void AddRectangle(Rectangle& rectangle)
		{
			l = MIN(l, rectangle.l);
			r = MAX(r, rectangle.r);
			u = MAX(u, rectangle.u);
			b = MIN(b, rectangle.b);
			height = u - b;
			width = r - l;
			RectangleList.push_back(rectangle);
		}
		bool InDomain(T x, T y)
		{
			for (auto& rect : RectangleList) {
				if (rect->InDomain(x, y)) {
					return true;
				}
			}
			return false;
		}
		count_t BlockNum()
		{
			return RectangleList.size();
		}
		Rectangle& operator[](index_t i)
		{
			return RectangleList[i];
		}


	protected:
		T height, width;
		T l, r, u, d;
		std::vector<Rectangle> RectangleList;
	};

}