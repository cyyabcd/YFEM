#pragma once
#include "Polynomial.h"

namespace YFEM
{
	template<typename T>
	Polynomial<T> Dx(Polynomial<T>& p)
	{
		Polynomial<T> px(MAX(0, p.dgree - 1));
		if (p.dgree > 0) 
		{
			for (dgree_t k = 0; k < p.dgree; ++k)
			{
				for (index_t i = 0; i <= k; ++i) 
				{
					px[k*(k + 1) / 2 + i] = (k - i + 1)*p[(k + 1)*(k + 2) / 2 + i];
				}
			}
		}
		return px;
	}
	template<typename T>
	Polynomial<T> Dy(Polynomial<T>& p)
	{
		Polynomial<T> py(MAX(0, p.dgree - 1));
		if (p.dgree > 0)
		{
			for (dgree_t k = 0; k < p.dgree; ++k)
			{
				for (index_t i = 0; i <= k; ++i)
				{
					py[k*(k + 1) / 2 + i] = (i + 1)*p[(k + 1)*(k + 2) / 2 + i + 1];
				}
			}
		}
		return py;
	}
}