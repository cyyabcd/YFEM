#pragma once
#include "Common.h"

namespace YFEM
{
	template<typename T>
	inline T Inner33(const T a[3], const T b[3])
	{
		return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
	}
}