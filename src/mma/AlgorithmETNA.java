package mma;

public class AlgorithmETNA {

	public static void runMMA() {
		mmaEtna();
	}

	private static void mmaEtna() {
		// Control variables
		int maxIter;
		double epsl = 4.0, epsu = 4.0, epsx = 1.0e-5;
		double eps = 1.0e-12;
		double epsilon;
		int iter, i;
		// Current and previous points
		double xk, xk_P, xk0, xkMin;
		// Objective function and residual error
		double fxk, res;
		// First order derivatives, second order diagonal terms
		double dfxk, dfxk_P, ak;
		// Asymptotes L^k and U^k
		double lk, uk;
		// Intermediate alpha and beta variables
		double alphak, betak, dx;
		double resMin = 1.0e+20;
		// Additional control variables
		double eps_lower, eps_upper;
		int i_eps;
		// Deviation ratio for Dobjectiv and delta XK limits
		double eps_xk = 1.e-3, delta_xk;
		// First order derivatives, second order diagonal terms
		double ak_max;
		// objective function result variables
		double res_p = 1.e+20;
		boolean sideOfOptimum, sideOfOptimum_P;

		// X0 is imported from an initial guess
		xk = UImma.getInitialValue();

		// Initial calculation with a first guess
		fxk = ObjectiveFunctions.getObjectiveFunction(xk, UImma.getSelectedTestCase());
		// CALL objectiveX (XK,FXK,RES)
		// sideOfOptimum = isLeftOfOptimum(FXK)
		xk0 = xk;
		iter = 0;
		eps_lower = epsl;
		eps_upper = epsu;
		i_eps = 0;
		delta_xk = 2.0 * eps_xk;
		double tiny = Math.pow(0.0001, 2);
		int max_iter = UImma.getMaxIterations();
		while ((iter < max_iter) && (resMin > tiny)) {
			iter++;
			System.out.println("Iteration:" + iter);
		}
	}
}
