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
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
Hub class >> // it [

	^  self startDoubleDispatchTo: it
]

{ #category : 'as yet unclassified' }
Hub class >> classHttpClient [

	<ttWall>
	
	"not all environments have ZnClient,this ˆ means, 
	 apply TheHub current ensureClassNamespaceSearchPath"
	 
	^ self getClass: #ˆGuzzler
]

{ #category : 'wall' }
Hub class >> fileReferenceFrom: aThing [
 
	"The best file reference provider... in the world"
 
  	<ttWall>

  	"This allows other classes to play, but we start
  	by going via the current platform-resolved Hub"
  	
 	^ aThing fileReferenceFrom: self current
 	
 	
]

{ #category : 'environment' }
Hub class >> gt [

	"Glamorous Toolkit"
	
	<ttHub>
		
  ^  GlamorousˆHub 
		  
]

{ #category : 'browsing' }
Hub class >> hubHome [

	<ttHub>
	
	^ self getClass: 'ˆHomeHub'
]

{ #category : 'browsing' }
Hub class >> hubWork [

	<ttHub>
	
	^ self getClass: 'ˆWorkHub'
]

{ #category : 'browsing' }
Hub class >> hubs [

	^ self openBrowser hubs
	

]

{ #category : 'handling' }
Hub class >> isWhoAmI [

	<ttWhoAmI>

	"Identity provider from environment image"

	^ true
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
Hub class >> namespaceSearchPath [

	^ #(Pharo '${NICKNAME}' '${LOCATION}' '${COMPANY}' '${PROJECT}' '${PLATFORM}') 
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

{ #category : 'spokes' }
Hub class >> pragmasAll_ttHealthy [

	"Environment health checks"
	
	<ttSpoke>
	
	^ #ttHealthCheck gtPragmas
	

]

{ #category : 'spokes' }
Hub class >> pragmasAll_ttHub [

	"All of the hubs... in the world"
	
	^ Hub sortByComment: (Pragma allNamed: #ttHub)
	
]

{ #category : 'spokes' }
Hub class >> pragmasAll_ttQuirk [

	"All of the <ttQuirk>... in the world"
	
	<ttSpoke>
	
	^ Hub sortByComment: (Pragma allNamed: #ttQuirk)
	
]

{ #category : 'spokes' }
Hub class >> pragmasAll_ttUtility [

	"All of the <ttUtility>... in the world"
	
	<ttSpoke>
	
	^ Hub sortByComment: (Pragma allNamed: #ttUtility)
	
]

{ #category : 'spokes' }
Hub class >> pragmasAll_ttWall [

	"All of the <ttWall>... in the world"
	
	<ttSpoke>
	
	^ Hub sortByComment: (Pragma allNamed: #ttWall)
	
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchFromClassClass: theClass with: aClassNameOrClass [
	"No need to dd in this case"

	aClassNameOrClass == Class
		ifTrue: [ ^ self error: 'avoiding infinite recursion here' ].

	^ self current getClass: aClassNameOrClass
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchFromFileClass: theFileClass with: aClassNameOrClassOrOrigin [
	| aClass |
	"Handle known origin symbols (rather then dd to Symbol)"
	(FileLocator supportedOrigins includes: aClassNameOrClassOrOrigin)
		ifTrue: [ ^ FileLocator origin: aClassNameOrClassOrOrigin ].
 
	aClass := Hub current
			getClass: aClassNameOrClassOrOrigin
			ifAbsent: [ ^ Hub fileReferenceFrom: aClassNameOrClassOrOrigin ].

	^ aClass fileReferenceFrom: aClassNameOrClassOrOrigin
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchFromString: aClassNameOrString with: it [ 

	^(self current getClass: aClassNameOrString) // it
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchTo: it [ 
	^ it // self
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchfromAFileReference: aFileReference with: aClassNameOrClass [

	^ (Hub current getClass: aClassNameOrClass) doubleDispatchFrom: (Hub current) andAFileReference: aFileReference


]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchfromClientClass: anObject with: aClassNameOrClass [ 
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchfromFactoryClass: anObject with: aClassNameOrClass [ 

"Options:
	string - instanciate or report on supporters of a particular vaultAppId
	class - Ask the class to instanciate itself via that particualar factory
	        (e.g. Http/Http) Project Factories for project configured variants
	
	
"




]

{ #category : 'comparing' }
Hub class >> startDoubleDispatchfromPragma: anObject with: aClassNameOrClass [

	"So experimental do not know what this is for yet"
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleDispatchfromPragmaClass: anObject with: aClassNameOrClass [ 

	"So experimental, do not know what it is for yet"
]
