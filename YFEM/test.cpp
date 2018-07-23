#include "Common.h"
#include "YFEM.h"
#include "Polynomial.hpp"
#include "Differential.h"
#include "Integration.h"
using namespace YFEM;
double f(const double a, const double b)
{
	return b;
}
int main(int argc, char* argv[])
{
	double cons[] = { 1 };
	double p[] = { 0,0,1,0,0,0 };
	double c[] = { 0.,1,0.,0.,0,0 };
	Polynomial<double> consp(0, cons);
	Polynomial<double> fp(2, p);
	Polynomial<double> P(2, c);
	Polynomial<double> px = Dx(P);
	Polynomial<double> py = Dy(P);
	double val = P(4, 3);
	double ip = InnerProduct(fp, P);
	Rectangle<double> rect(-1, 1, -1, 1);
	val = InnerProduct(f, 1, 0, rect);

	system("PAUSE");
}