"
I am an interface to Pharo image/environment provided singletons. 

Projects may subclass me to have a customised presentation of that interface. 

If code is to be portable to other smalltalk environments I am that replacable interface.

Values are obtained from the surrounding image context via a resumable notification. This provides a mechanism for these singletons to be overriden within a block context, and customized via subclassing.
"
Class {
	#name : 'Hub',
	#superclass : 'TTNotifyingHubAbstract',
	#traits : 'TNamespaced',
	#classTraits : 'TNamespaced classTrait',
	#category : 'Tactical-Hub-Entrypoint',
	#package : 'Tactical-Hub',
	#tag : 'Entrypoint'
}

{ #category : 'as yet unclassified' }
Hub class >> // it [

	^  Hub current startDoubleSlashFromHub: self to: it
]

{ #category : 'as yet unclassified' }
Hub class >> classHttpClient [

	<ttWall>
	
	"not all environments have ZnClient,this ˆ means, 
	 apply TheHub current ensureClassNamespaceSearchPath"
	 
	^ self getClass: #ˆGuzzler
]

{ #category : 'usl-schemes' }
Hub class >> client: aClassOrName [
 
  ^ ((self class: aClassOrName) basicNewFor: self current) initialize
	
	
]

{ #category : 'usl-schemes' }
Hub class >> factory: aClassOrName [
 
  ^ ((self class: aClassOrName) basicNewFor: self current) initialize
]

{ #category : 'usl-schemes' }
Hub class >> file: anOriginClassOrString [
 
	^ (TTFileResourceLocator newStart: anOriginClassOrString) next
	
	
]

{ #category : 'browsing' }
Hub class >> fileReferenceFromString: aString [

  <ttWall>

  "prefer #file: // aThing"
	^ TTFileResourceLocator fileReferenceFromString: aString
	
]

{ #category : 'usl-schemes' }
Hub class >> fileX: anOriginClassOrString [

	"previous implementation"
	| aClass |
	
	"Handle known origin SYMBOLS (cache?)"
	(FileLocator supportedOrigins includes: anOriginClassOrString)
		ifTrue: [ ^ FileLocator origin: anOriginClassOrString ].
 
  "are we a class"
   anOriginClassOrString isClass ifTrue: [ ^ self fileReferenceFrom: anOriginClassOrString ].

	^ aClass fileReferenceFrom: anOriginClassOrString
]

{ #category : 'environment' }
Hub class >> gt [

	"Glamorous Toolkit"
	
	<ttHub>
		
  ^  GlamorousˆHub 
		  
]

{ #category : 'usl-schemes' }
Hub class >> http: aClassOrName [
 
  ^ ((self class: aClassOrName) basicNewFor: self current) beHttp initialize
]

{ #category : 'usl-schemes' }
Hub class >> https: aClassOrName [
 
  ^ ((self class: aClassOrName) basicNewFor: self current) initialize
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

{ #category : 'usl-schemes' }
Hub class >> localname: aClassOrName [

	^ (self namespaced: aClassOrName) value
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

{ #category : 'usl-schemes' }
Hub class >> namespace: aClassOrName [
 
	^ (self namespaced: aClassOrName) key
]

{ #category : 'as yet unclassified' }
Hub class >> namespacedSearchPath [

	^ #('${NICKNAME}' '${LOCATION_ID}' '${COMPANY_ID}' '${PROJECT_ID}' '${PLATFORM_ID}') 
]

{ #category : 'usl-schemes' }
Hub class >> new: aThing [

 "not sure about this one"
 
	^ (self class: aThing) new
	
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

{ #category : 'usl-schemes' }
Hub class >> pretty: aClassOrName [

	^ ((self namespaced: aClassOrName) value ifNil: [ ^'' ]) splitCamelCase joinUsing: ' '
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
