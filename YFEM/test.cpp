#include "Common.h"
#include "YFEM.h"
#include "Polynomial.h"
#include "Differential.h"
using namespace YFEM;
int main(int argc, char* argv[])
{
	Patch p(3, 3);
	double c[] = { 0.,1.,2.,3.,4.,5. };
	Polynomial<double> P(2,c);
	Polynomial<double> px = Dx(P);
	Polynomial<double> py = Dy(P);
	double val = P(4, 3);
	system("PAUSE");
}