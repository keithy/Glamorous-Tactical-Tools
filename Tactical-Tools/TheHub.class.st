"
I am an interface to Pharo image/environment provided singletons. 

Projects may subclass me to have a customised presentation of that interface. 

If code is to be portable to other smalltalk environments I am that replacable interface.

Values are obtained from the surrounding image context via a resumable notification. This provides a mechanism for these singletons to be overriden within a block context, and customized via subclassing.
"
Class {
	#name : 'TheHub',
	#superclass : 'TTAbstractHub',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TheHub class >> classHttpClient [

	<ttWall>
	
	"not all environments have ZnClient,this ˆ means, 
	 apply TheHub current ensureClassNamespaceSearchPath"
	 
	^ self getClass: #ˆGuzzler
]

{ #category : 'environment' }
TheHub class >> gt [

	"The Glamorous Toolkit"
	
	<ttHub>
		
  ^  TheGlamorousHub 
		  
]

{ #category : 'browsing' }
TheHub class >> hubs [

	^ self openBrowser hubs
	

]

{ #category : 'handling' }
TheHub class >> isWhoAmI [

	<ttWhoAmI>

	"Identity provider from environment image"

	^ true
]

{ #category : 'as yet unclassified' }
TheHub class >> makeNetworkErrorHandler [

	"Network Error Handler"
	
	<ttWall>
	
	"For your Context - Different Context, subclass TheHub"
	
	^ [ :err |
			
				(err isKindOf: NameLookupFailure)
					ifTrue: [  err messageText: 'Network problem?', err messageText ].
					
				err pass.
		  ]
		  
]

{ #category : 'environment' }
TheHub class >> onStartUpBidToBeBrowser [

	^ 1
]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttHealthy [

	"Environment health checks"
	
	<ttSpoke>
	
	^ #ttHealthCheck gtPragmas
	

]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttHub [

	"All of the hubs... in the world"
	
	^ TheHub sortByComment: (Pragma allNamed: #ttHub)
	
]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttQuirk [

	"All of the <ttQuirk>... in the world"
	
	<ttSpoke>
	
	^ TheHub sortByComment: (Pragma allNamed: #ttQuirk)
	
]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttUtility [

	"All of the <ttUtility>... in the world"
	
	<ttSpoke>
	
	^ TheHub sortByComment: (Pragma allNamed: #ttUtility)
	
]

{ #category : 'spokes' }
TheHub class >> pragmasAll_ttWall [

	"All of the <ttWall>... in the world"
	
	<ttSpoke>
	
	^ TheHub sortByComment: (Pragma allNamed: #ttWall)
	
]
