MODULE objectiveFunctions

!	USE mytypes

	IMPLICIT NONE

	logical             :: initialGuess
	REAL*8              :: targetMass, errorMin=1.0D+20
	REAL*8              :: x0

	CONTAINS

	SUBROUTINE readInitialData(z0, eps_z0)
        IMPLICIT NONE


		REAL*8 :: z0  		 
		REAL*8 :: eps_z0  
		REAL*8 :: eps = 0.05 !used to compute the deltaX/X

		initialGuess=.TRUE.
        ! dummy value for compilation
        z0 = 0.0
        eps_z0  = 0.0

	END SUBROUTINE readInitialData


	SUBROUTINE objectiveX (X,FX,RES)
		
		IMPLICIT NONE
		
		! Funtion result
		REAL*8,intent (out) :: FX,RES
		! Input argument
		REAL*8, intent (in) :: X

		initialGuess=.FALSE.
        ! Return FX
						
	END SUBROUTINE objectiveX

	SUBROUTINE DobjectiveX (X,DFX,EPS_X,D2FX)
        IMPLICIT NONE
        
		! Funtion result
		REAL*8,intent (out)  :: DFX
		! Input argument
		REAL*8               :: X
		! Dummy argument
		integer                            :: I, N
		!REAL*8, dimension(:),allocatable  :: XLOC
		! Objective function
		REAL*8                             :: fPlus, fMoins, h, fval
		! Funtion result
		REAL*8,intent (out)  :: D2FX
		! Input argument
		REAL*8              :: EPS_X
		! Objective function
		REAL*8                             :: x_save, hL, hU
		REAL*8                             :: fValRef, fValPlus, fValMoins, fRef
		REAL*8, parameter                  :: eps = 0.01
		REAL*8   :: S, T
		REAL*8                             :: STS, STT
                                                       
		N=1
		
		CALL objectiveX (X,fValRef,fRef)
        
		!DO I=1,N
  !         x_save = X(I)
		!	h = EPS_X(I)*dabs(X(I))*eps
  !          X(I)=x_save+h
		!	fValPlus=fValRef
		!	CALL objectiveX (X,fValPlus,fPlus)  ! Calcul of f(x^k + h)
		!	X(I)=x_save-h
		!	fValMoins=fValRef
		!	CALL objectiveX (X,fValMoins,fMoins) ! Calcul of f(x^k - h)
		!	DFX(I)= (fPlus - fMoins)/(2.0*h)
		!	WRITE(*,'(I12,2X,A,D15.6,5X,A,D15.6,5X,A,D15.6)') I,"F+:",fPlus,"F-:",fMoins,"DX:",DFX(I) 
		!	X(I) = x_save
  !
		!	! note : the value returned from objectiveX should be convex
		!	!        it returns the squared deviation, which means that the
		!	!        the values returned should be convex
		!	!        therefore take the positive values only
		!	D2FX(I)= MAX(0.0,(fPlus+fMoins-2*fRef)/(h**2))
		!	S(I) = h
		!	T(I) = D2FX(I) * h
		!END DO
  !
		!STS = DOT_PRODUCT(S,S)
		!STT = DOT_PRODUCT(S,T)
		!D2FX(:)=STT/STS
  !
		!deallocate(S, T) 
	END SUBROUTINE DobjectiveX

	SUBROUTINE D2objectiveX (X,X_P,DFX,DFX_P,D2FX)
	    IMPLICIT NONE
	    
		! Funtion result
		REAL*8,intent (out) :: D2FX
		! Input argument
		REAL*8,intent (in)  :: X,X_P,DFX,DFX_P
		! Dummy argument
		integer :: i, n
		REAL*8 :: S, T
		REAL*8    :: dx, eps, sts, stt,Ak

		N=1
		eps = 1.0D-15


		! Option AMS
		! S = X - X_P
		! T = DXF - DXF_P
		! D2FX = (S^t.T)/(S^t.S) for all 1=1,n
		STS = 0.0
		STT = 0.0
!		DO i=1,n
			S = X - X_P
			T = DFX - DFX_P
			STS  = STS + S*S
			STT  = STT + MAX(eps, T*S)
!		END DO
		D2FX=STT/STS
	END SUBROUTINE D2objectiveX

    !sim, this is new to track the input files

	LOGICAL FUNCTION isLeftOfOptimum(FX)
	    IMPLICIT NONE	    
	    REAL*8 FX
		
		isLeftOfOptimum = FX.lt.targetMass

	END FUNCTION isLeftOfOptimum
	

	!SUBROUTINE saveInputToNumberedFile(iter)
	!	
	!	IMPLICIT NONE
	!	integer             :: iter
	!	! Local intermediate parameters
	!	integer, parameter  :: testInput=33
	!	integer             :: Open_Status
	!	character*80        :: fileName
 !
	!	write(fileName, '(A,I3.3,A)') 'test_',iter,'.in'
 !
	!	! Write Test input file
 !       CLOSE(testInput)
	!	OPEN (unit=testInput, file=fileName, IOSTAT = Open_Status)
 !       IF (Open_Status > 0) STOP "ERROR: test file not opened properly."
 !    	CALL WRITE_TEST_INPUT (testInput,initialData)
 !       CLOSE(testInput)
	!					
	!END SUBROUTINE saveInputToNumberedFile


END MODULE objectiveFunctions
