package mma;

import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Spinner;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.events.MouseAdapter;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.ModifyEvent;

public class UImma {
	private static Text textIterations;
	private static Text textError;
	private static Text textFinalValue;
	private static Text textInitialValue;
	
	public static Combo comboSelectedTestCase;
	public static Spinner spinnerIterationsMax;
	/**
	 * Launch the application.
	 * @param args
	 */
	public static void main(String[] args) {
		Display display = Display.getDefault();
		Shell shell = new Shell();
		shell.setSize(523, 461);
		shell.setText("MMA Application");
		
		Label lblAlgorithm = new Label(shell, SWT.NONE);
		lblAlgorithm.setBounds(29, 25, 71, 17);
		lblAlgorithm.setText("Algorithm");
		
		Button btnMMA_1 = new Button(shell, SWT.CHECK);
		btnMMA_1.setSelection(true);
		btnMMA_1.setToolTipText("Select the MMA algorithm to test");
		btnMMA_1.setBounds(29, 59, 117, 22);
		btnMMA_1.setText("MMA [1]");
		
		Button btnCheckButton = new Button(shell, SWT.CHECK);
		btnCheckButton.setGrayed(true);
		btnCheckButton.setToolTipText("Not yet implemented");
		btnCheckButton.setBounds(29, 104, 117, 22);
		btnCheckButton.setText("MMA [2]");
		
		Label lblConvergenceTolerance = new Label(shell, SWT.NONE);
		lblConvergenceTolerance.setBounds(152, 64, 163, 17);
		lblConvergenceTolerance.setText("Convergence tolerance:");
		
		Label lblIterationsMax = new Label(shell, SWT.NONE);
		lblIterationsMax.setBounds(152, 109, 231, 17);
		lblIterationsMax.setText("Maximum number of iterations:");
		
		spinnerIterationsMax = new Spinner(shell, SWT.BORDER);
		spinnerIterationsMax.setMaximum(500);
		spinnerIterationsMax.setMinimum(150);
		spinnerIterationsMax.setIncrement(50);
		spinnerIterationsMax.setBounds(389, 100, 110, 35);
		
		Spinner spinnerTolerance = new Spinner(shell, SWT.BORDER);
		spinnerTolerance.setPageIncrement(1);
		spinnerTolerance.setMaximum(16);
		spinnerTolerance.setBounds(389, 59, 110, 35);
		
		Label lblTestCase = new Label(shell, SWT.NONE);
		lblTestCase.setBounds(29, 221, 71, 17);
		lblTestCase.setText("Test case");
		
		textInitialValue = new Text(shell, SWT.BORDER);
		textInitialValue.setText("0.0");
		textInitialValue.setBounds(355, 154, 144, 29);
		
		comboSelectedTestCase = new Combo(shell, SWT.NONE);
		comboSelectedTestCase.addModifyListener(new ModifyListener() {
			public void modifyText(ModifyEvent arg0) {
				int selectedTestCase = comboSelectedTestCase.getSelectionIndex();
				String[] x0 = new String[]{"1.0E-12", "0.25", "-2.5", "-62.0E+100"};
				textInitialValue.setText(x0[selectedTestCase]);
			}
		});
		comboSelectedTestCase.setItems(new String[] {"f_1(x)", "f_2(x)", "f_3(x)", "f_4(x)"});
		comboSelectedTestCase.setToolTipText("Select in the list a test case to run");
		comboSelectedTestCase.setBounds(29, 260, 195, 29);
		comboSelectedTestCase.select(0);
		
		Label lblIterations = new Label(shell, SWT.NONE);
		lblIterations.setBounds(29, 317, 195, 17);
		lblIterations.setText("Number of iterations:");
		
		Label lblError = new Label(shell, SWT.NONE);
		lblError.setBounds(29, 348, 71, 17);
		lblError.setText("Error:");
		
		Label lblOptimum = new Label(shell, SWT.NONE);
		lblOptimum.setBounds(29, 386, 173, 17);
		lblOptimum.setText("Final value:");
		
		textIterations = new Text(shell, SWT.BORDER);
		textIterations.setText("0");
		textIterations.setBounds(255, 301, 244, 29);
		
		textError = new Text(shell, SWT.BORDER);
		textError.setText("0.0");
		textError.setBounds(255, 336, 244, 29);
		
		textFinalValue = new Text(shell, SWT.BORDER);
		textFinalValue.setText("0.0");
		textFinalValue.setBounds(255, 374, 244, 29);
		
		Label lblInitialValue = new Label(shell, SWT.NONE);
		lblInitialValue.setBounds(152, 166, 210, 17);
		lblInitialValue.setText("Initial value:");
		
		
		Button btnRun = new Button(shell, SWT.NONE);
		btnRun.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseDown(MouseEvent e) {
				// Collect data and run selected MMA algorithm
				AlgorithmETNA.runMMA();
			}
		});
		btnRun.setBounds(428, 199, 71, 29);
		btnRun.setText("Run");

		shell.open();
		shell.layout();
		
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
	}
	public static int getMaxIterations() {
		return Integer.valueOf(spinnerIterationsMax.getText());
}
	
	public static int getSelectedTestCase() {
				return comboSelectedTestCase.getSelectionIndex();
	}
	
	public static double getInitialValue() {
		
		double x0;
		x0 = Double.valueOf(textInitialValue.getText());
		return x0;
	}
}
