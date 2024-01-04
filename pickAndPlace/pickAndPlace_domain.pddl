(define (domain pickAndPlace)
    (:types
    ball ball robotArm robotArm room - object
  )
      
    (:requirements 
		:equality
		:existential-preconditions
	)

    (:predicates
        (robotAtRoom ?r - room)
        (ballAtRoom ?b - ball ?r - room)
        (handFree ?h - robotArm)
        (inHand ?b - ball ?h - robotArm)
    )

    (:action pickOneBall
        :parameters (?b1 - ball ?left - robotArm ?right - robotArm ?room - room)
        
        :precondition 
        (and
            (ballAtRoom ?b1 ?room)  
            (robotAtRoom ?room) 
            (handFree ?left) 
            (handFree ?right) 
            (not (inHand ?b1 ?left))
            (not (inHand ?b1 ?right))
        )
        :effect 
        (and 
			(inHand ?b1 ?left) 
			(not (ballAtRoom ?b1 ?room)) 
			(not (handFree ?left))
			(handFree ?right)  
        )
    )

    (:action pickTwoBall
        :parameters (?b1 - ball ?left - robotArm ?b2 - ball ?right - robotArm ?room - room)
        
        :precondition 
        (and 
			(not (= ?b1 ?b2))
            (ballAtRoom ?b1 ?room)
			(ballAtRoom ?b2 ?room)  
            (robotAtRoom ?room) 
            (handFree ?left)
			(handFree ?right) 
            (not (inHand ?b1 ?left))
            (not (inHand ?b2 ?right))
        )
        :effect 
        (and 
			(inHand ?b1 ?left)   
			(not (ballAtRoom ?b1 ?room))    
			(not (handFree ?left))
            (inHand ?b2 ?right)
			(not (ballAtRoom ?b2 ?room))
			(not (handFree ?right))
        )
    )
    
    (:action  placeOneBall
        :parameters (?b1 - ball  ?left - robotArm ?right - robotArm ?room - room)
        
        :precondition 
        (and 
            (not (ballAtRoom ?b1 ?room))
            (handFree ?right)
            (inHand ?b1 ?left) 
            (robotAtRoom ?room)
        )
        :effect 
        (and 
            (handFree ?right)
            (ballAtRoom ?b1 ?room)
            (handFree ?left)  
            (not (inHand ?b1 ?left))
			(not (inHand ?b1 ?right)) 
        )
    )
    
    (:action  placeTwoBall
        :parameters (?b1 - ball ?left - robotArm ?b2 - ball ?right - robotArm ?room - room)
        
        :precondition 
        (and
            (not (ballAtRoom ?b1 ?room))
			(not (= ?b1 ?b2))
			(not (ballAtRoom ?b2 ?room))
            (inHand ?b1 ?left)
            (inHand ?b2 ?right)
            (robotAtRoom ?room)
        )
        :effect 
        (and
			(ballAtRoom ?b1 ?room)
			(handFree ?left)
			(not (inHand ?b1 ?left))
			(ballAtRoom ?b2 ?room)
			(handFree ?right)
			(not (inHand ?b2 ?right))      
        )
    )
    
    (:action move 
        :parameters (?rooma - room ?roomb - room)
        :precondition (robotAtRoom ?rooma)
        :effect (and (robotAtRoom ?roomb) (not (robotAtRoom ?rooma)))
    )
    
)