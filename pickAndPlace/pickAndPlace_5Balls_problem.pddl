(define (problem pickAndPlace_5Balls)

    (:domain pickAndPlace)
    
    (:objects
        rooma roomb - room
        ball1 ball2 ball3 ball4 ball5 - ball
        left right - robotArm
    )

    (:init  
        (robotAtRoom rooma)
        (handFree left)
        (handFree right)
        (ballAtRoom ball1 rooma)
		(ballAtRoom ball2 rooma)
		(ballAtRoom ball3 rooma) 
		(ballAtRoom ball4 rooma)
		(ballAtRoom ball5 rooma)		
    )

    (:goal 
		(and 
			(ballAtRoom ball1 roomb)
			(ballAtRoom ball2 roomb)
			(ballAtRoom ball3 roomb)
			(ballAtRoom ball4 roomb)
			(ballAtRoom ball5 roomb)
		)
    )

)