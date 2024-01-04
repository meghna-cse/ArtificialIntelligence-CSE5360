(define (problem DLOG-2-2-2)
	(:domain driverlog)
	
	(:objects
    	driver1 - driver
    	driver2 - driver
    	driver3 - driver
    	truck1 - truck
    	truck2 - truck
    	truck3 - truck
    	package1 - obj
    	package2 - obj
    	package3 - obj
    	s0 - location
    	s1 - location
    	s2 - location
    	s3 - location
	)
	
	(:init
	    ;for drive1, package1, truck1
    	(at driver1 s0)
    	(at truck1 s0)
	    (empty truck1)
	    (= (load truck1) 0)
	    (= (fuel-per-minute truck1) 10)
	    (at package1 s0)
	    
	    ;for drive2, package2, truck2
    	(at driver2 s0)
    	(at truck2 s0)
	    (empty truck2)
	    (= (load truck2) 0)
	    (= (fuel-per-minute truck2) 10)
	    (at package2 s0)
	    
	    ;for drive3, package3, truck3
    	(at driver3 s0)
	    (at truck3 s0)
	    (empty truck3)
	    (= (load truck3) 0)
	    (= (fuel-per-minute truck3) 10)
    	(at package3 s0)
	
	    ;linking locations
	    ;s0 and s1
    	(link s0 s1)
    	(link s1 s0)
    	(= (time-to-drive s0 s1) 70)
    	(= (time-to-drive s1 s0) 70)
        ;s0 and s2
    	(link s0 s2)
    	(link s2 s0)
    	(= (time-to-drive s0 s2) 47)
    	(= (time-to-drive s2 s0) 47)
    	;s1 and s2
    	(link s2 s1)
    	(link s1 s2)
    	(= (time-to-drive s2 s1) 24)
    	(= (time-to-drive s1 s2) 24)
    	;s0 and s3
    	(link s0 s3)
    	(link s3 s0)
    	(= (time-to-drive s3 s0) 15)
    	(= (time-to-drive s0 s3) 15)
    	;s2 and s3
    	(link s2 s3)
    	(link s3 s2)
    	(= (time-to-drive s3 s2) 50)
    	(= (time-to-drive s2 s3) 50)
    	;s1 and s2
    	(link s1 s3)
    	(link s3 s1)
    	(= (time-to-drive s3 s1) 30)
    	(= (time-to-drive s1 s3) 30)
	    (= (fuel-used) 0)
    )

	(:goal (and
    	(at driver1 s1)
    	(at truck1 s1)
    	(at package1 s1)
    	(at driver2 s2)
    	(at truck2 s2)
    	(at package2 s2)
    	(at driver3 s3)
    	(at truck3 s3)
    	(at package3 s3)
	))

    (:metric minimize (+ (* 1 (total-time)) (* 3 (fuel-used))))

)