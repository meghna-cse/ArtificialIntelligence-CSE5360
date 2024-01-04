(define (problem pickAndPlace_10Balls)

    (:domain pickAndPlace)
    
    (:objects
        rooma roomb - room
        ball1 ball2 ball3 ball4 ball5 ball6 ball7 ball8 ball9 ball10 - ball
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
		(ballAtRoom ball6 rooma)
		(ballAtRoom ball7 rooma)
		(ballAtRoom ball8 rooma) 
		(ballAtRoom ball9 rooma)
		(ballAtRoom ball10 rooma) 		
    )

    (:goal 
		(and 
			(ballAtRoom ball1 roomb)
			(ballAtRoom ball2 roomb)
			(ballAtRoom ball3 roomb)
			(ballAtRoom ball4 roomb)
			(ballAtRoom ball5 roomb)
            (ballAtRoom ball6 roomb)
			(ballAtRoom ball7 roomb)
			(ballAtRoom ball8 roomb)
			(ballAtRoom ball9 roomb)
			(ballAtRoom ball10 roomb)
		)
    )

)