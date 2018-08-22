#pragma once
#include "Topology.h"
#include "Domain.h"
#include "Geometry.h"
namespace YFEM
{
	template<typename T>
	class RectangleMesh
	{
	public:
		RectangleMesh(count_t M, count_t N, const RectangleDomain& domain)
			:M(M), N(N)
		{
			
		}

		~Mesh()
		{

		}

	protected:
		count_t M, N;
		std::vector<Point> PointList;
		std::vector<Quadrangle> RectangleList;

	};

}