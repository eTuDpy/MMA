PROGRAM ASYMPTOTES
	 
	USE objectiveFunctions 
!	USE MYTYPES

	IMPLICIT none

	! Space dimension - Number of parameters
	INTEGER, PARAMETER :: N=1
	! Control variables
	INTEGER, PARAMETER :: MAX_ITER=	500

    REAL*8, PARAMETER    :: EPSL=4.0, EPSU=4.0, EPSX=1.0D-5
	REAL*8, PARAMETER    :: EPS=1.0D-12 !, EPSILON=5.0e-03
	REAL*8               :: EPSILON
	INTEGER              :: ITER, I
	! Current and previous points
	REAL*8 :: XK,XK_P,XK0,XKmin
	! Objective function and residual error
	REAL*8               :: FXK,RES
	! First order derivatives, second order diagonal terms 
	REAL*8 :: DFXK, DFXK_P,AK
	! Asymptotes L^k and U^k
	REAL*8 :: LK, UK
	! Intermediate alpha and beta variables
	REAL*8 :: ALPHAK, BETAK, DX, resMin=1.0D+20
	! Output file Results 
	CHARACTER (LEN=10)  :: FileName 
	INTEGER, PARAMETER  :: FileUnit = 36

    ! Control variables
	REAL*8             :: EPS_LOWER, EPS_UPPER 
	INTEGER            :: I_EPS
	! Deviation ratio for Dobjectiv and delta XK limits
	REAL*8 :: EPS_XK, DELTA_XK
	! First order derivatives, second order diagonal terms 
	REAL*8                           :: AK_MAX
	! objective function result variables
	REAL*8  :: RES_P=1.D+20
	LOGICAL :: sideOfOptimum, sideOfOptimum_P
	! Output file Results 
	INTEGER :: Open_Status, itest
	REAL*8  :: XKN
	
	FileName = "sleq.rst"
	OPEN (UNIT= FileUnit, FILE=FileName, STATUS="unknown", IOSTAT = Open_Status)
	IF (Open_Status > 0) STOP "ERROR: sleq.rst file not opened properly."


	! X0 is imported from an initial guess
	CALL readInitialData(XK, EPS_XK)

	! Initial calculation with a first guess
	CALL objectiveX (XK,FXK,RES)
	sideOfOptimum = isLeftOfOptimum(FXK)
	XK0 = XK
	!STOP "Intermediate implementation"

	ITER=0
	WRITE(*,1000) ITER,FXK,RES
	WRITE(fileUnit,1100) ITER,FXK,RES,XK,LK,UK

!	call saveInputToNumberedFile(ITER) 

	EPS_LOWER   = EPSL
	EPS_UPPER   = EPSU
	I_EPS       = 0              
	DELTA_XK = 2.0 * EPS_XK
	
!	call ResetConvergenceCheck

	optimizationLoop: DO WHILE ((ITER < MAX_ITER) .and. (resMin > 0.0001**2))

		ITER = ITER + 1

		CALL DobjectiveX (XK,DFXK,EPS_XK,AK)
		IF (ITER > 1) THEN
			CALL D2objectiveX (XK,XK_P,DFXK,DFXK_P,AK)
		END IF

		DFXK_P = DFXK ! sim, moved from above
		XK_P   = XK   ! sim, moved from above

		sideOfOptimum_P = sideOfOptimum

		! Find the largest value of AK
		AK_MAX = 0.0
		DO I=1,N
			!IF (dabs(DFXK) .le. EPS) CYCLE
			IF (DFXK .lt. 0.0) THEN
				!LK < XK + 2.0*DFXK/AK --> EPS_L > 2.0
				LK = XK + EPS_LOWER*DFXK/AK
				! Limit AK such that LK does not exceed the boundaries.
				IF ((XK-LK) .LT. EPSX) THEN
					AK = EPS_LOWER*DFXK / MIN(EPS_LOWER*DFXK,-EPSX)
				ELSEIF (LK.LT.(XK-dabs(XK*DELTA_XK))) THEN
					AK = EPS_LOWER*DFXK / (-XK*DELTA_XK)
				END IF
			ELSE
				!UK > XK + 2.0*DFXK/AK  --> EPS_U > 2.0
				UK = XK + EPS_UPPER*DFXK/AK
				! Limit AK such that UK does not exceed the boundaries.
				IF ((UK-XK) .LT. EPSX) THEN
					AK = EPS_UPPER*DFXK / MAX(EPS_UPPER*DFXK,EPSX)
				ELSEIF (UK.gt.(XK+dabs(XK*DELTA_XK))) THEN
					AK = EPS_UPPER*DFXK / (XK*DELTA_XK)
				END IF
			ENDIF
			AK_MAX = MAX(AK_MAX, AK)
		END DO 

		AK = AK_MAX
		! Update the position of asymptotes
		I_Loop: DO I=1,N
			!IF (dabs(DFXK) .le. EPS) CYCLE
			IF (DFXK .lt. 0.0) THEN
				!LK < XK + 2.0*DFXK/AK --> EPS_L > 2.0
				LK = XK + EPS_LOWER*DFXK/AK
				XK = LK - (LK - XK_P) * DSQRT(EPS_LOWER/(EPS_LOWER - 2.0)) 

				XK = XK_P + DFXK/AK*EPS_LOWER*(1.0 - DSQRT(EPS_LOWER/(EPS_LOWER - 2.0)))
			ELSE
				!UK > XK + 2.0*DFXK/AK  --> EPS_U > 2.0
				UK = XK + EPS_UPPER*DFXK/AK
				XK = UK - (UK - XK) * DSQRT(EPS_UPPER/(EPS_UPPER - 2.0)) 

				XK = XK_P + DFXK/AK*EPS_UPPER*(1.0 - DSQRT(EPS_UPPER/(EPS_UPPER - 2.0)))
			ENDIF
		END DO I_Loop

		XK0 = XK

		! Current calculation of the objective function
		CALL objectiveX (XK,FXK,RES)
!		CALL saveInputToNumberedFile(ITER)

		sideOfOptimum = isLeftOfOptimum(FXK)


		WRITE(*,1000) ITER,FXK,RES
		IF (RES < resMin) THEN
			resMin=RES
			XKmin=XK
			WRITE(fileUnit,1100) ITER,FXK,RES,XK,LK,UK

		ELSE
			WRITE(fileUnit,1100) ITER,FXK,RES,XK,LK,UK
		END IF

		IF ((RES > RES_P).AND.(EPS_LOWER.LT.64).AND.(EPS_UPPER.LT.64)) THEN
		    I_EPS     = I_EPS+1
			EPS_LOWER = 2.0 * EPS_LOWER
			EPS_UPPER = 2.0 * EPS_UPPER
		ENDIF
		RES_P = RES
	END DO optimizationLoop

	! Current calculation of the objective function at optimum to get the optimal mesh
    WRITE(*,*) ''
    WRITE(*,*) '-- at optimum ----------------------------'
	CALL objectiveX (XKmin,FXK,RES)
    WRITE(*,1000) ITER,FXK,RES
    WRITE(*,*) '-- end -----------------------------------'


    !CALL ReportConvergenceResults	

	CLOSE(FileUnit)

 1000  FORMAT("ITER: ",I3,'  F:',f10.2,"  E:",f10.6)
 1100  FORMAT(I3,';',f10.2,";",f10.6,30(";",e20.6))
     

END PROGRAM ASYMPTOTES
