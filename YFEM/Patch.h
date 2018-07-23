#pragma once
#include "Common.h"

namespace YFEM
{
	struct Patch
	{
		Patch(count_t elementNum) :elementNum(elementNum)
		{
		}
		Patch(index_t x, index_t y)
			:elementNum(x*y), position(std::vector<index_t[2]>(elementNum))
		{
			maxx = x - 1;
			maxy = y - 1;
			index_t row;
			for (index_t j = 0; j < y; ++j) {
				row = j * x;
				for (index_t i = 0; i < x; ++i) {
					position[row + i][0] = i;
					position[row + i][1] = j;
				}
			}
		}
		count_t elementNum;
		index_t maxx, maxy;
		std::vector<index_t[2]> position;
	};
}