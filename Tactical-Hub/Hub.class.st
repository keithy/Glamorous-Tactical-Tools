"
I am an interface to Pharo image/environment provided singletons. 

Projects may subclass me to have a customised presentation of that interface. 

If code is to be portable to other smalltalk environments I am that replacable interface.

Values are obtained from the surrounding image context via a resumable notification. This provides a mechanism for these singletons to be overriden within a block context, and customized via subclassing.
"
Class {
	#name : 'Hub',
	#superclass : 'TTNotifyingHubAbstract',
	#category : 'Tactical-Hub-Entrypoint',
	#package : 'Tactical-Hub',
	#tag : 'Entrypoint'
}

{ #category : 'environment' }
Hub class >> gt [

	"Glamorous Toolkit"
	
	<ttHub>
		
  ^  #class://#GlamorousˆHub 
		  
]

{ #category : 'browsing' }
Hub class >> hubHome [

	<ttHub>
	"Home Hub"
	
	^ #class:// 'ˆHomeHub'
]

{ #category : 'browsing' }
Hub class >> hubWork [

	<ttHub>
	"Work Hub"
	
	^ #class:// 'ˆWorkHub'
]

{ #category : 'browsing' }
Hub class >> hubs [

	^ self openHubBrowser hubs
	

]

{ #category : 'as yet unclassified' }
Hub class >> makeNetworkErrorHandler [

	"Network Error Handler"
	
	<ttWall>
	
	"For your Context - Different Context, subclass TheHub"
	
	^ [ :err |
			
				(err isKindOf: NameLookupFailure)
					ifTrue: [  err messageText: 'Network problem?', err messageText ].
					
				err pass.
		  ]
		  
]

{ #category : 'as yet unclassified' }
Hub class >> namespacedSearchPath [

	^ #('${NICKNAME}' '${LOCATION_ID}' '${COMPANY_ID}' '${PROJECT_ID}' '${PLATFORM_ID}') 
]

{ #category : 'environment' }
Hub class >> onStartUpBidToBeCurrent [

	^ 1
]

{ #category : 'instance creation' }
Hub class >> open [

	"convenience"
	
	^ self openHubCodeBrowser
			
	 
		  
]
