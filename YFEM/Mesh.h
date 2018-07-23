#pragma once
#include "Topology.h"
#include "Domain.h"
#include "Geometry.h"
namespace YFEM
{
	template<typename T>
	class Mesh
	{
	public:
		Mesh()
		{
		}

		~Mesh()
		{
		}

	protected:

		std::vector<Point> PointList;
		std::vector<Quadrangle> RectangleList;

	};

}