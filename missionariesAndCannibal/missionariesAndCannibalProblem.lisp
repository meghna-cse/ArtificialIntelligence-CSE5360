;========================================================
;	Author		: Meghna Jaglan
;	Student ID	: 1002053631
;========================================================
;CSE 5360: Artificial Intelligence, Project Assignment 1
;========================================================
;PROBLEM DESCRIPTION: Missionaries and Cannibals Problem
;========================================================
;The number of missionaries and cannibals on the left
;side of the river, on the boat, and on the right side
;of the river. We can represent it as
;		[L(Mn, Cn), B(Mn, Cn), R(Mn, Cn)], where
; L(Mn, Cn) is the number of missionaries and cannibals
;			on the left side of the river,
; B(Mn, Cn) is the number of missionaries and cannibals
;			on the boat,
; R(Mn, Cn) is the number of missionaries and cannibals
;			on the right side of the river.

;CONSTRAINTS: Following are the constraints that the
;		configuration of the number of missionaries and
;		cannibals must adhere to when crossing the river:
;			1. Mn >= Cn 
;			2. For B(Mn, Cn),  Mn + Cn <= 6
;			3. Total Mn and Cn are both greater than 0
;========================================================

;-----------------------------------------------------------------------------------
;declaration of variables
;-----------------------------------------------------------------------------------
;final configuration on the left side of the river or goal state
(setf finalConfiguration '#(0 0 0))

;setting boat capacity as 6
(setf boatCapacity 6)

;array to save the number of missionaries on the boat, number of cannibals on the boat, and the position of the boat
(setf boatConfiguration (make-array 3))

;array to store different missionaries and cannibals configurations and to order them
(setf searchTree (make-array 0 :fill-pointer t :adjustable t))

;array of visited missionaries and cannibals configurations
(setf visitedConfigurations (make-array 0 :fill-pointer t :adjustable t))

;array of moves made
(setf movesArray (make-array 0 :fill-pointer t :adjustable t))

;; counter variable 
(setf counter 0)

;flag to determine whether the a state is already in the search tree. 0--> false, 1-->true
(setf visitedState 0)

;-----------------------------------------------------------------------------------
;defining the structure of each node in the search tree
;-----------------------------------------------------------------------------------
(defstruct state
	configuration ; an array contatining the number of missionary, number of cannibals and boat position
	heuristic	; heuristic
	id	    	; id of the node for linking
	parentNode			; parent node links the nodes child node to its parent
)

;-----------------------------------------------------------------------------------
;Function for solving Missionaries and Cannibals Problem
;-----------------------------------------------------------------------------------
(defun missionaryCannibalProblem()

	(format t "~% INSTRUCTIONS: ~%")
	(format t "~% 1. Enter the initial configuration of Missionaries and Cannibals Problem. ~%")
	(format t "~% 2. First enter the number of missionaries. ~%")
	(format t "~% 3. Second enter the number of cannibals. ~%")
	
	(setf nMissionaries (read))
	(setf nCannibals (read))
	
	;creating the root node in the search tree
    (createRootNode nMissionaries nCannibals boatCapacity)
	
    ;creating the search tree to find a solution
	(searchTree nMissionaries nCannibals boatCapacity)	
	
    ;call the determineBestPath function to find and order the search tree for best moves
	(determineBestPath)
	
	;remove the initial state
    (setf lastMove (vector-pop movesArray))
    (format t "~%L(Mn,Cn)           Boat(Mn,Cn)             R(Mn,Cn)")
	
	;print the solution
    (printSolution)
)	


;------------------------------------------------------------------------------------------
;Function to create the root node with the entered values and saving it in the search tree
;------------------------------------------------------------------------------------------
(defun createRootNode (nMissionaries nCannibals boatCapacity)
    (setf initialState (make-array 3))
    (setf (aref initialState 0) nMissionaries)
    (setf (aref initialState 1) nCannibals)
    (setf (aref initialState 2) 1)
	
    (vector-push-extend
		(make-state 
			:configuration initialState 
			:heuristic (/ (+ nMissionaries nCannibals) boatCapacity) 
			:id 0 
			:parentNode 0 
		) searchTree)
)


;-----------------------------------------------------------------------------------
;Function to create or update the search tree
;-----------------------------------------------------------------------------------
(defun searchTree(nMissionaries nCannibals boatCapacity)

    ;setting the current state
	(setf currentState (vector-pop searchTree))
	
    ;;adding the current state to the array of visitedConfigurations
	(vector-push-extend currentState visitedConfigurations)
	
	;checking whether the current state is the final desired state
	(if (equalp (state-configuration currentState) finalConfiguration)
        (progn 0)	;is goal state
		(progn
		    (loop for numberOfMissionaries from 0 to boatCapacity do
			    (loop for numberOfCannibals from 0 to boatCapacity do

                    ;finding configurations of the number of cannibals and missionaries that satisfy all the constraints
			        (if (and (and (< (+ numberOfMissionaries numberOfCannibals) (+ boatCapacity 1)) (> (+ numberOfMissionaries numberOfCannibals) 0)) 
								(or (<= numberOfCannibals numberOfMissionaries) (= 0 numberOfMissionaries) (= 0 numberOfCannibals)))
				        (progn
                            (setf (aref boatConfiguration 0) numberOfMissionaries)
                            (setf (aref boatConfiguration 1) numberOfCannibals) 
				            (setf (aref boatConfiguration 2) 1) 	
                            
							;create valid states for each configuration of missionaries and cannibals
                            (generateNextMove currentState boatConfiguration nMissionaries)
                        )
                    )
                )
            )
			
            ;ordering the best move using the heuristic value
		    (determineBestMove searchTree)
			
            ;creating/updating the search tree till we reach the final desired configuration
		    (searchTree nMissionaries nCannibals boatCapacity)))
)	


;--------------------------------------------------------------------------------------------
;Function to generate next possible moves available from moving the boat and the search tree
;--------------------------------------------------------------------------------------------
(defun generateNextMove((state-configuration currentState) boatConfiguration nMissionaries)

	(setf nextMove (make-array (length (state-configuration currentState))))
	(setf heuristic 0)

	(loop for mcMovement from 0 to (- (length (state-configuration currentState)) 1) do		
		(if (= (aref (state-configuration currentState) 2) 1)
			;if the boat is on the left side of the river
            (progn
                ;updating the missionaries and cannibals count left on the left of the river after the moving the boat to the right
		        (setf (aref nextMove mcMovement) (- (aref (state-configuration currentState) mcMovement)(aref boatConfiguration mcMovement))))
			;if the boat is on the right side of the river
            (progn
                ;updating the missionaries and cannibals count left on the right of the river after the moving the boat to the left
		        (setf (aref nextMove mcMovement) (+ (aref (state-configuration currentState) mcMovement)(aref boatConfiguration mcMovement))))))
				

    ;calculating the heuristic cost
	(setf heuristic (/ (+ (aref nextMove 0) (aref nextMove 1)) boatCapacity))
	
    ;verify whether the next move is already in the search tree
	(isVisitedState nextMove)
	
    ;update the search tree if the next move is valid
	(if (and (= 1 (isValidState nextMove nMissionaries)) (= visitedState 0))
        (progn
			(vector-push-extend 
				(make-state 
					:configuration nextMove 
					:heuristic heuristic 
					:id (incf counter)  
					:parentNode (state-id currentState)
				) searchTree)))
)


;-----------------------------------------------------------------------------------
;Function to verify whether the next move is valid
;-----------------------------------------------------------------------------------
(defun isValidState(nextMove nMissionaries)
    
	;;checking whether all constraints are met
	
    (if (or (< (aref nextMove 0) 0) (< (aref nextMove 1) 0) (> (aref nextMove 0) nMissionaries) (> (aref nextMove 1) nMissionaries))
    	0
	    (progn
            ;check for Cn !> Mn
	        (if(and (> (aref nextMove 1) (aref nextMove 0)) (/= 0 (aref nextMove 1)) (/= 0 (aref nextMove 0)))
		        0
                (progn
                    ;check whether constraints are met after the nextMove
                    (if (and (> (- nMissionaries (aref nextMove 1)) (- nMissionaries (aref nextMove 0))) (/= 0 (- nMissionaries (aref nextMove 0))) (/= 0 (- nMissionaries (aref nextMove 1))))
		                0			
		                1) ;is valid
                ))))
)			


;-----------------------------------------------------------------------------------
;Function to verify a configuration is already in the search tree
;-----------------------------------------------------------------------------------
(defun isVisitedState(configuration)
	(setf visitedState 0)
    
	;looping through the array of visited configuration
	(loop for i from 0 to (1- (length visitedConfigurations)) do
		;if the given configuration is equal to a already present configuration, set the flag as true
		(if (equalp configuration (state-configuration (aref visitedConfigurations i)))
	    	(setf visitedState 1)
        )
    )
)


;-----------------------------------------------------------------------------------
;Function to determine the best move based on the heuristic value
;-----------------------------------------------------------------------------------
(defun determineBestMove(possibleMoves)
    		
 	(setq temp possibleMoves)
    	(loop for i from (1- (length possibleMoves)) downto 0
       		do(loop for j from 0 to i
				;comparing the f(n) values and ordering them in increasing order
				;i.e. the move with least cost is placed first
				when (> (state-heuristic (aref temp i)) (state-heuristic (aref temp j)))
					do(rotatef (aref temp i) (aref temp j))
            )
        )
        temp
)


;-----------------------------------------------------------------------------------
;Function to determine best path to reach the goal using backtracking
;-----------------------------------------------------------------------------------
(defun determineBestPath()

    ;number of traversed states/nodes
	(setq traversedNodeIndex (1- (length visitedConfigurations)))
	
    ;updated the moves array with the node visited or traversed
	(vector-push-extend (state-configuration (aref visitedConfigurations traversedNodeIndex)) movesArray)
	
	;setting the parent of the current node
    (setq currentStateParent (state-parentNode (aref visitedConfigurations traversedNodeIndex)))
	(loop
        ;return if root node
		(if (= 0 traversedNodeIndex)
		    (return)
        )
		;if not the root node
		(loop
			(if (= currentStateParent (state-id (aref visitedConfigurations traversedNodeIndex)))
			    (progn 
                    ;updated the moves array with the parent node visited or traversed
                    (vector-push-extend (state-configuration (aref visitedConfigurations traversedNodeIndex)) movesArray)
                    
					;setting parent node id for the next loop
                    (setq currentStateParent (state-parentNode (aref visitedConfigurations traversedNodeIndex))) 
                    (return))
				;decrement till we reach root
                (decf traversedNodeIndex))))
)


;---------------------------------------------------------------------------------------
;Function to print the best move that will solve the Missionaries and Cannibals problem
;---------------------------------------------------------------------------------------
(defun printSolution()
 
	(if (= (length movesArray) 0)
		(format t "~%...........")	;print if goal reached
		(progn
			(let((this_move (vector-pop movesArray)))
        	    (if (= (aref this_move 2) 0)	;if boat is on the left side
					(format t "~%(~S ~S)            -- (~S ~S) --->         (~S ~S)" 
						( aref lastMove 0) (aref lastMove 1) (- (aref lastMove 0) 
						(aref this_move 0)) (- (aref  lastMove 1)
						(aref this_move 1)) 
						(- (aref initialState 0) (aref this_move 0))
						(- (aref initialState 1) (aref this_move 1))
					)
					(format t "~%(~S ~S)           <--- (~S ~S) --          (~S ~S)"
						(+ (aref lastMove 0) (- (aref this_move 0) 
																(aref lastMove 0))) 
						(+ (aref lastMove 1) (- (aref  this_move 1) 
																(aref lastMove 1)))
						(- (aref this_move 0) (aref lastMove 0)) 
						(- (aref  this_move 1) (aref lastMove 1)) 
						(+ (- (aref initialState 0) (aref this_move 0)) 
										(- (aref this_move 0) (aref lastMove 0)))  
						(+ (- (aref initialState 1) (aref this_move 1)) 
										(- (aref  this_move 1) (aref lastMove 1)))
			    ))
		        (setf lastMove this_move)
		    )
	        (printSolution)
	    )
    )
)

(missionaryCannibalProblem)