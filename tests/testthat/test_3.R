# TEST SUIT 3: PARTIAL ETS and Arima validation against Rob Hyndman's implementation

# REFERENCE: 
# http://robjhyndman.com/researchtips/tscvexample/

#ARIMA Model, skip 12
test_that("CV 12, Growing-Window ARIMA", {
  
	#Define Answer <- Rob Hyndman has changed his Arima() function
  oldHynd <- c(0.529179597555492, 0.670143933508085, 0.678300753565447, 0.499836923147352, 
                0.864497506546911, 0.579423735387968, 0.843747164557209, 0.914486932327702, 
                0.902607186986663, 0.793847163325815, 0.579405192053736, 0.687352737930688
                )
  
  #Define Answer <- Hyndman's new Arima Function
  Hynd <- c(0.52957723789386, 0.670781860408808, 0.678193749591462, 0.500156903265079, 
            0.86503326894027, 0.58011027227358, 0.844119075392931, 0.91423460941329, 
            0.901971912510654, 0.793277270746339, 0.579700698345303, 0.686975392891812
            )

	#Cross-validate model
	myControl <- list(	minObs=60,
						stepSize=12, 
						maxHorizon=12, 
						fixedWindow=FALSE,
            preProcess=FALSE,
						summaryFunc=tsSummary
					)
	result <- cv.ts(a10, arimaForecast, myControl, order=c(3,0,1), 
		seasonal=list(order=c(0,1,1), period=12), 
		include.drift=TRUE, lambda=0, method="ML")[['results']][1:12,'MAE']

	expect_that(result, equals(Hynd))
}
)

#ETS Model, skip 12
test_that("CV 12, Growing-Window ETS", {

	#Define Answer
	Hynd <- c(0.353431521763042, 0.628265545392106, 0.675731072294083, 0.628647304479674, 
				0.915347954006543, 1.0837159908616, 0.90615566133361, 0.790857576269784, 
				0.997481060941866, 0.639003378132452, 0.882186328692234, 1.01293201087573
				)

	#Cross-validate model
	myControl <- list(	minObs=60,
						stepSize=12, 
						maxHorizon=12, 
						fixedWindow=FALSE,
            preProcess=FALSE,
						summaryFunc=tsSummary
					)
	result <- cv.ts(a10, etsForecast, myControl, model="MMM", damped=TRUE)[['results']][1:12,'MAE']

	expect_that(result, equals(Hynd))
}
)