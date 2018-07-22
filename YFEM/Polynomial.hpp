#pragma once
#include "Common.h"

namespace YFEM
{
	template <typename T>
	struct Polynomial
	{
		Polynomial(dgree_t d)
			:dgree(d),
			p(std::vector<T>((d + 2)*(d + 1) / 2, static_cast<T>(0)))
		{
		}
		Polynomial(dgree_t d, T* coefficient)
			:dgree(d), p(std::vector<T>(coefficient, coefficient + (d + 2)*(d + 1) / 2))
		{
		}

		T operator() (T x, T y) {
			T sum = 0;
			count_t k;
			for (index_t i = 0; i <= dgree; ++i) {
				k = i * (i + 1) / 2;
				for (index_t j = 0; j <= i; ++j)
				{
					sum += p[k + j] * pow(x, i - j)*pow(y, j);
				}
			}
			return sum;
		}

		T& operator[] (const index_t i)
		{
			return p[i];
		}
		const T& operator[] (const index_t i) const
		{
			return p[i];
		}

		Polynomial Dx()
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

		Polynomial Dy()
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
		dgree_t dgree;
		std::vector<T> p;
	};


}