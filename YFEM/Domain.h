#pragma once
#include "Common.h"

namespace YFEM 
{
	template<typename T>
	struct Rectangle
	{
		Rectangle(T& t, T& b, T& l, T&r) 
			:t(t), b(b), l(l), r(r) {}
		T t, b, l, r;

		bool InRect(T x, T y)
		{
			return (x >= l && x <= r && y >= b && y <= t);
		}
	};

	template<typename T>
	class RectangleDomain
	{
	public:
		RectangleDomain()
		{
		}

		~RectangleDomain()
		{

		}

		void AddRectangle(Rectangle& rectangle)
		{
			RectangleList.push_back(rectangle);
		}
		bool InDomain(T x, T y)
		{
			for (auto& rect : RectangleList) {
				if (!rect->InDomain(x, y)) {
					return false;
				}
			}
			return true;
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
		std::vector<Rectangle> RectangleList;
	};

}