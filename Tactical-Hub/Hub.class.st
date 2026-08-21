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

{ #category : 'as yet unclassified' }
Hub class >> classHttpClient [

	<ttWall>
	
	"not all environments have ZnClient,this ˆ means, 
	 apply TheHub current ensureClassNamespaceSearchPath"
	 
	^ self getClass: #ˆGuzzler
]

{ #category : 'usl-schemes' }
Hub class >> client: aClassNameOrSymbol [
 
  ^ ((#class:// aClassNameOrSymbol) newFor: self current)  
	
	
]

{ #category : 'usl-schemes' }
Hub class >> factory: aClassOrName [
 
  ^ ((#class://aClassOrName) basicNewFor: self current) initialize
]

{ #category : 'usl-schemes' }
Hub class >> file: aThing [
 
	^ (self fileSRL: aThing) asFileReference
	
]

{ #category : 'browsing' }
Hub class >> fileReferenceFromString: aString [

  <ttWall>

  "prefer #file: // aThing"
	^ SRLFile fileReferenceFromString: aString
	
]

{ #category : 'usl-schemes' }
Hub class >> fileSRL: aThing [
 
  "as file: but late bound to environment"
	^ SRLFile fromHub: self current fileWith: aThing
	
	
]

{ #category : 'environment' }
Hub class >> gt [

	"Glamorous Toolkit"
	
	<ttHub>
		
  ^  GlamorousˆHub 
		  
]

{ #category : 'usl-schemes' }
Hub class >> http: aThing [
	(aThing isClass or: [ aThing isSymbol])
		ifTrue: [ ^ SRLOldClassHolder fromHub: self current httpWithClass: aThing ].

	^ (self http: TTApiThinClient) // aThing	"string or Symbol"
]

{ #category : 'usl-schemes' }
Hub class >> https: aThing [
	(aThing isClass or: [ aThing isSymbol])
		ifTrue: [ ^ SRLOldClassHolder fromHub: self current httpsWithClass: aThing ].

	^ (self https: TTApiThinClient) // aThing	"string or Symbol"
]

{ #category : 'browsing' }
Hub class >> hubHome [

	<ttHub>
	"Home Hub"
	
	^ self getClass: 'ˆHomeHub'
]

{ #category : 'browsing' }
Hub class >> hubWork [

	<ttHub>
	"Work Hub"
	
	^ self getClass: 'ˆWorkHub'
]

{ #category : 'browsing' }
Hub class >> hubs [

	^ self openBrowser hubs
	

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

{ #category : 'browsing' }
Hub class >> mapVarsInto: entry [
	| value env |
	
	value := entry.
	
	(entry allRangesOfRegexMatches: '\$\{[^}]*\}')
		do: [ :r | 
			env := entry copyFrom: r first + 2 to: r last - 1.	"lookup - not logged"	"self _at: env ifPresent: [ :v | value := value copyReplaceAll: ('${', env, '}') with: v ]"	"lookup - logged"
			self
				assocAt: env
				ifPresent: [ :assoc | value := value copyReplaceAll: '${' , env , '}' with: assoc value ].	"subst env vars"
			self osEnvironment
				at: env
				ifPresent: [ :v | value := value copyReplaceAll: '${' , env , '}' with: v ] ].

	^ value
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

{ #category : 'usl-schemes' }
Hub class >> pragma: aClassNameOrClass [
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromHub: receiverHub to: aThing [ 

"aHub is the original reciever of //, (self is aHub current)"
"stack overflow = problem!  (Hub//File)"
	^ aThing doubleSlashFromHub: receiverHub to: aThing andCH: self
]

{ #category : 'comparing' }
Hub class >> startDoubleSlashfromPragma: anObject with: aClassNameOrClass [

	"So experimental do not know what this is for yet"
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashfromPragmaClass: anObject with: aClassNameOrClass [ 

	"So experimental, do not know what it is for yet"
]

{ #category : 'usl-schemes' }
Hub class >> url: aThing [

	"opportunity to defer decision to a class goes via SRL"
	(aThing isClass or: [ aThing isSymbol])
		ifTrue: [ ^ SRLOldClassHolder fromHub: self current urlWithClass: aThing ].

  "direct action policy determined locally by the hub"
	^ (self url: TTApiThinClient) // aThing	"string"
]
