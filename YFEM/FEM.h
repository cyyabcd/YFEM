#pragma once
#include "Patch.h"
#include "Polynomial.hpp"
using namespace std;
namespace YFEM {
	template<typename T, dgree_t order>
	class FEM
	{
	public:
		FEM(vector<Polynomial>& baseFunctions,
			vector<Patch> patchList,
			vector<index_t> patchIndexOfBaseFunctions)
			: baseFunctionList(move(vector<vector<Polynomial<T>>>[(order + 1)*(order + 2) / 2])),
			patchList(patchList), patchIndexOfBaseFunctions(patchIndexOfBaseFunctions)
		{
			index_t ld;
			for (index_t i = 0; i < baseFunctions.size(); ++i) 
			{
				baseFunctionList[0][i] = baseFunctions[i];
				for (index_t d = 1; d <= order; ++d) 
				{
					ld = (d + 1)*d / 2;
					lld = ld - d;
					for (index_t j = 0; j < d; ++j)
					{
						baseFunctionList[ld + j][i] = baseFunctionList[lld + j][i].Dx();
					}
					baseFunctionList[ld + d][i] = baseFunctionList[lld + d - 1][i].Dy();
				}
			}
		}
	protected:
		std::vector<Patch> patchList;
		std::vector<index_t> patchIndexOfBaseFunctions;
		std::vector<std::vector<Polynomial>> baseFunctionList;
	};
}