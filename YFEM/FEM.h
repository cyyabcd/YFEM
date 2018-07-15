#pragma once
#include "Patch.h"
#include "Polynomial.h"
namespace YFEM {
	template<typename T>
	class FEM
	{


	protected:
		std::vector<Patch> PatchList;
		std::vector<Polynomial> BaseFunction;
		std::vector<Polynomial> BaseFunction_DX;
		std::vector<Polynomial> BaseFunction_DY;
		dgree_t maxdeg;
		count_t PatchNum;
	};
}