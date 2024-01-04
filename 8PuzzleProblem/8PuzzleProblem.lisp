;===========================================================
;	Author		: Meghna Jaglan
;	Student ID	: 1002053631
;===========================================================
;CSE 5360: Artificial Intelligence, Project Assignment 1
;===========================================================
;PROBLEM DESCRIPTION: 8 Puzzle Probem using A*
;===========================================================
;For the initial configuration of the board find a solution.

;Variables: number of squares each having a number from 
;			1 to 8 and one square which is empty
;Domain: a board of 3x3 size
;Constraints:  when moving a tile up, down, left or right:
;	1. there’s no other tile blocking you
;	2. you’re not trying to move outside of the edges
;===========================================================

;-----------------------------------------------------------------------------------
;declartion of variables
;-----------------------------------------------------------------------------------
;initial board configuration or root node
(setf initialConfiguration (make-array 9))

;final board configuration or goal node
(setf finalConfiguration (make-array 9 :initial-contents '(1 2 3 4 5 6 7 8 0)))

;array of visited board configuration
(setf visitedBoardConfiguration (make-array 0 :fill-pointer t :adjustable t)
) 	
;flag to determine whether the a state is already in the search tree. 0--> false, 1-->true
(setf visitedState 0)

;counting the number of states explored
(setf counter 1)

;array to store board configurations and to order them based on cost function
(setf searchTree (make-array 0 :fill-pointer t :adjustable t)) 

;-----------------------------------------------------------------------------------
;defining the structure of each node in the search tree
;-----------------------------------------------------------------------------------
(defstruct state
	boardConfiguration 	; state of the puzzle or the configuration of the board
	heuristic 			; heuristic is h(n) used in A*
	pathCost			; path cost is g(n) used in A*
	parentNode			; parent node links the nodes and helps determine the depth (path cost) of the node in the search tree
)


;-----------------------------------------------------------------------------------
;Function to print the best move that will solve the 8-Puzzle problem
;-----------------------------------------------------------------------------------
(defun printSolution()

	(format t " The below moves will solve the 8-Puzzle problem with minimum cost: ~%")
	(loop for board from 0 to (- (length visitedBoardConfiguration) 1)
		do(format t "~S: ~S ~%" board (state-boardConfiguration (aref visitedBoardConfiguration board)))
		;(loop for i from 0 to (- (length (state-boardConfiguration (aref visitedBoardConfiguration board))) 1)
		;	do(loop for j from i to (+ i 2)
		;		do(if (and (> j 8) (> i 8))
		;			(format t "  ~S ~%" (aref (state-boardConfiguration (aref visitedBoardConfiguration board)) j)))))
		
	)
)


;-----------------------------------------------------------------------------------
;Function to verify whether a board configuration is already in the search tree
;-----------------------------------------------------------------------------------
(defun isVisitedState(board)

	(setf visitedState 0)
	
	;looping through the array of visited board configuration
	(loop for pos from 0 to (- (length visitedBoardConfiguration) 1)
	
		;if the given board configuration is equal to a already present configuration, set the flag as true
		do(if (equalp board (state-boardConfiguration (aref visitedBoardConfiguration pos)))
			(setf visitedState 1)))
)


;-----------------------------------------------------------------------------------
;Function to create or update the search tree
;-----------------------------------------------------------------------------------
(defun createSearchTree()
	
	;setting the current state
	(setf currentState (vector-pop searchTree))

	;adding the current state to the array of visited squares
	(vector-push-extend currentState visitedBoardConfiguration) 
	
	;checking whether the current state is the final desired state
	;OR whether the heuristic cost is 0 (meaning no more misplaced tiles and all are in position)
	(if (or (equalp (state-boardConfiguration currentState) finalConfiguration) (= (state-heuristic currentState) 0))
        
		(format t " Number of states explored: ~S ~% ~%" counter)
		(progn
			
			;setting the available squares that can be moved based on current board configuration
			(setf possibleMoves (generateNextMove (state-boardConfiguration currentState)))

			;setting the position of empty square for the current board configuration
			(setf emptySquare (position 0 (state-boardConfiguration currentState)))
			
			;;for each possible move, find the best move
			
			;for each possible move, checking whether it will result in a already visited board configuration or not
			;if not, we update the search tree
			(loop for i from 0 to (- (length possibleMoves) 1)			
				do (setf nextMove (make-array 9))
					(loop for pos from 0 to (- (length nextMove) 1)					
		        		do(setf (aref nextMove pos) (aref (state-boardConfiguration currentState) pos)))
					
				;creating the board of nextMove
				(setf (aref nextMove (aref possibleMoves i)) 0) 
				(setf (aref nextMove emptySquare) (aref (state-boardConfiguration currentState) (aref possibleMoves i)))
				
				;setting the heuristic cost for the next possible move
				(setf heuristicCost (defineHeuristic nextMove))
				
				;setting the depth of the node in the search tree, g(n)
				(setf pathCost (state-pathCost currentState))	
				
				;checking whether the next move has already been explored
				(isVisitedState nextMove)
				
				;displaying the states/nodes explored in the search tree
				(setf counter (+ counter 1)) 				
				(format t " State ~S: ~S ~%" counter nextMove)
				
				;pushing the nextMove state into the search tree if it has not been visited
				(if (= visitedState 0)
					(vector-push-extend 
						(make-state :boardConfiguration nextMove 
									:heuristic heuristicCost 
									:pathCost (+ pathCost 1) 
									:parentNode (state-boardConfiguration currentState))
						searchTree)))
			
			;ordering the best move using A* cost function, f(n) = h(n) + f(n)    	
			(loop for board from (- (length searchTree) 1) downto 0
				do (loop for eachBoard from 0 to board
					;comparing the f(n) values of two board configurations and ordering them in increasing order
					;i.e. the move with least cost is placed first
					when (< (+(state-heuristic (aref searchTree eachBoard)) (state-pathCost (aref searchTree eachBoard))) (+(state-heuristic (aref searchTree board)) (state-pathCost (aref searchTree board)))) 
						do (rotatef (aref searchTree board) (aref searchTree eachBoard))))
			
			;creating/updating the search tree till we reach the final desired configuration
			(createSearchTree)
        ) 
    ) 
)


;-----------------------------------------------------------------------------------
;Function to generate next possible moves available from current position
;-----------------------------------------------------------------------------------
(defun generateNextMove(board)
	
	;;fetching the possible move based on the position of the empty square
	
	(setf emptySquare (position 0 board))
	
	;for a specified position of the empty square, we can determine which adjacent squares can be moved. The below switch case determines the same.
	(setf nextMove 
		(case emptySquare
			;for emptySquare at position 0, squares at position 1 and 3 can be moved
			((0) (make-array 2 :initial-contents '(1 3)))
			
			;for emptySquare at position 1, squares at position 0,2,4 can be moved
			((1) (make-array 3 :initial-contents '(0 2 4)))
			
			;for emptySquare at position 2, squares at position 1 and 5 can be moved
			((2) (make-array 2 :initial-contents '(1 5)))
			
			;for emptySquare at position 3, squares at position 0,4,6 can be moved
			((3) (make-array 3 :initial-contents '(0 4 6)))

			;for emptySquare at position 4, squares at position 1,3,5,7 can be moved
			((4) (make-array 4 :initial-contents '(1 3 5 7)))
			
			;for emptySquare at position 5, squares at position 2,4,8 can be moved
			((5) (make-array 3 :initial-contents '(2 4 8)))		
			
			;for emptySquare at position 6, squares at position 3 and 7 can be moved
			((6) (make-array 2 :initial-contents '(3 7)))
			
			;for emptySquare at position 7, squares at position 4,6,8 can be moved
			((7) (make-array 3 :initial-contents '(4 6 8)))
			
			;for emptySquare at position 8, squares at position 5,7 can be moved
			((8) (make-array 2 :initial-contents '(5 7)))
		)
	)
	
	;returning the next possible move
	nextMove
)


;-----------------------------------------------------------------------------------
;Function to calculate the heuristic cost
;-----------------------------------------------------------------------------------
(defun defineHeuristic(board)
	
	;variable to count the number of tiles which are not misplaced
	(setf notMisplaced 0)
	
	;;calculating the heuristic cost by calculating the number of misplaced tiles
	
	;counting the number of tiles which are at there correct position
	(loop for pos from 0 to (- (length board) 1) 
		do(if (equalp 0 (- (aref board pos) (aref finalConfiguration pos))) 
			(setf notMisplaced (+ notMisplaced 1))))	;incf didnt work
	
	;final heuristic is the total number of squares minus the number of tiles which are not misplaced
	(setf heuristic (- 9 notMisplaced))
	heuristic
)


;-----------------------------------------------------------------------------------
;Function to verify whether the given board configuration is solvable
;-----------------------------------------------------------------------------------
(defun isValidConfiguration(board)

	;the 8Puzzle is not solvable if it has odd number of inversions
	;inversions: pairs in descending order
	(setf inversionCount 0) 
	
	(loop for i from 0 to 7
		do (loop for pos from (+ i 1) to 8
			;checking whether number at position i is greater than number at position i+1 and either are not zero
			do(if (and (/= (aref board pos) 0) (/= (aref board pos) 0) (> (aref board pos) (aref board pos))) 
				do(setf inversionCount (+ inversionCount 1))
			)))
	
	;condition to check whether inversion count is odd
	(if (oddp inversionCount)
		(error "The given board configuration is unsolvable."))
)


;-----------------------------------------------------------------------------------
;Function for solving 8-Puzzle problem
;-----------------------------------------------------------------------------------
(defun 8PuzzleProblem()
	
	(format t "~% INSTRUCTIONS: ~%")
	(format t "~% 1. Enter the initial configuration of the 8-Puzzle board from left to right. ~%")
	(format t "~% 2. For each number, enter the number and press Enter. ~%")
	(format t "~% 3. Enter 0 for blank square. ~%")
	
	;reading input from the user
	(loop for i from 0 to 8
		do(setf (aref initialConfiguration i) (read)))
			
	;verifying whether the given board coniguration is valid
	(isValidConfiguration initialConfiguration)
	
	;setting the heuristic for the initial board configuration
	(setf heuristicCost (defineHeuristic initialConfiguration))
	
	;finding the next moves available for the initial board configuration
	(generateNextMove initialConfiguration)
	
	;creating the root node
	(vector-push-extend
		(make-state :boardConfiguration initialConfiguration 
					:heuristic heuristicCost
					:pathCost 0
					:parentNode '#(0 0 0 0 0 0 0 0 0)) searchTree)
	
    
	;creating the search tree to find a solution
	(format t " Explored States: ~%")
	(format t " State 1: ~S ~%" initialConfiguration)	;printing the root (initial configuration) node of the search tree
	(createSearchTree)
	
	;print the solution
    (printSolution)
)

(8PuzzleProblem)