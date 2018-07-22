#pragma once
#include "Common.h"

namespace YFEM
{
	typedef index_t Vertex;
	Vertex uninitialized = _I32_MIN;
	struct Edge
	{
		Edge(const Vertex& node0, const Vertex& node1)
		{
			node[0] = node0;
			node[1] = node1;
		}
		void Set(const Vertex& node0, const Vertex& node1)
		{
			node[0] = node0;
			node[1] = node1;
		}
		Vertex node[2];
	};
	struct Triangle {
		Triangle(const Vertex& node0, const Vertex& node1, const Vertex& node2)
		{
			node[0] = node0;
			node[1] = node1;
			node[2] = node2;
		}
		void Set(const Vertex& node0, const Vertex& node1, const Vertex& node2)
		{
			node[0] = node0;
			node[1] = node1;
			node[2] = node2;
		}
		Edge OppositeEdge(const index_t i)
		{
			Edge edge(uninitialized, uninitialized);
			if (i == 0) { edge.Set(node[1], node[2]); }
			else if (i == 1) { edge.Set(node[2], node[0]); }
			else if (i == 2) { edge.Set(node[0], node[1]); }
			else
			{
				//“Ï≥£
			}
			return edge;
		}
		Vertex node[3];
	};
	struct Quadrangle
	{
		Quadrangle(const Vertex& node0, const Vertex& node1, const Vertex& node2, const Vertex& node3)
		{
			node[0] = node0;
			node[1] = node1;
			node[2] = node2;
			node[3] = node3;
		}
		Triangle OppositeTriangle(const index_t i) {
			Triangle triangle(uninitialized, uninitialized, uninitialized);
			if (i == 0) { triangle.Set(node[1], node[2], node[3]); }
			if (i == 1) { triangle.Set(node[2], node[3], node[0]); }
			if (i == 2) { triangle.Set(node[3], node[0], node[1]); }
			if (i == 3) { triangle.Set(node[0], node[1], node[2]); }
			else
			{
				//“Ï≥£
			}
		}
		Vertex node[4];
	};
}