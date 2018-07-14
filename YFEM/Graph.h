#pragma once
#include "Topology.h"

namespace YFEM
{
	template <typename Element>
	class Graph
	{
	public:
		Graph(count_t n)
			:ElementList(std::vector<Element>(n))
		{
		}

		~Graph()
		{
		}

	protected:
		std::vector<Element> ElementList;
	};

}