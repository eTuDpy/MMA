package mma;

public class ObjectiveFunctions {

	/**
	 * <h2>Return the value of the objective function at x</h2>
	 *
	 * @param x
	 * @param testCase
	 * @return
	 */
	public static double getObjectiveFunction(double x, int testCase) {
		return objectiveFunction(x, testCase);
	}

	private static double objectiveFunction(double x, int testCase) {
		double fx = 0;
		switch (testCase) {
		case 0:
			fx = (Math.pow(Math.sin(x), 3) - Math.pow(x, 3)) / 3 + x;
			break;
		case 1:
			fx = Math.exp(Math.pow(x, 2)) / 2 + (x - Math.sin(2 * x) / 2) + 3 * Math.sin(x) + 5 * x;
			break;
		case 2:
			fx = -(Math.pow(x, 3) / 3 + Math.pow(x, 2) * 5 / 2 + 3 * x - Math.exp(x));
			break;
		case 3:
			fx = Math.pow(x - 1, 4) / 4 - 2 * x + 1;
			break;
		default: // Not implemented
			fx = 1.e+100;
			break;
		}
		return fx;
	}
	
	/**
	 * <h2>Return the value of derivative of the objective function at x</h2>
	 *
	 * @param x
	 * @param testCase
	 * @return
	 */

	public static double getDobjectiveFunction(double x, int testCase) {
		return objectiveFunction(x, testCase);
	}

	private static double dobjectiveFunction(double x, int testCase) {
		double dfx = 0;
		switch (testCase) {
		case 0:
			dfx = Math.cos(x) * Math.pow(Math.sin(x), 2) - Math.pow(x, 2) + 1;
			break;
		case 1:
			dfx = x * Math.exp(Math.pow(x, 2)) + (1 - Math.cos(2 * x) / 2) + 3 * Math.cos(x) + 5;
			break;
		case 2:
			dfx = -(Math.pow(x, 2) + x * 5 + 3 - Math.exp(x));
			break;
		case 3:
			dfx = Math.pow(x - 1, 3) - 2;
			break;
		default: // Not implemented
			dfx = 1.e+100;
			break;
		}
		return dfx;
	}

}