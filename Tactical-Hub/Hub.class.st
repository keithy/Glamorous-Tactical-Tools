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

{ #category : 'browsing' }
Hub class >> fileReferenceFromString: aString [

  <ttWall>

	"Should be subclass responsibility - but if Hub current is = Hub there is a problem"

	| namedDirectories regex dirName path |
	
	
	(Hub current == Hub) ifTrue: [ Transcript crShow: 'Hub>>#fileReferenceFromString: reports that - Hub current == Hub' ].

	namedDirectories := self namedFileLocations. 
	
	regex := '\{([a-zA-Z]+)\}(.*)' asRegex.
	
	^ (regex matches: aString) 
			ifFalse: [ aString asFileReference ]
			ifTrue: [ 
				dirName := regex subexpression: 2.
				path := regex subexpression: 3.
				namedDirectories at: dirName
					ifPresent: [ :locator | path ifEmpty: [ locator resolve ] ifNotEmpty: [ locator resolve resolve: path allButFirst ] ]
					ifAbsent: [ self error: 'Unknown directory: ', dirName printString ] ]
	
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

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromAFileReference: aFileReference with: aClassNameOrClass [

	^ (self getClass: aClassNameOrClass) doubleDispatchFromAFileReference: aFileReference andCH: (self)


]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromClassClass: theClass with: aClassNameOrClass [
	"No need to dd in this case"

	aClassNameOrClass == Class
		ifTrue: [ ^ self error: 'avoiding infinite recursion here' ].

	^ self current getClass: aClassNameOrClass
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromClientClass: aClientClass with: aSymbolUrlStringOrClass [
	"Hub is vaultable"

	^ aClientClass doubleDispatchWithCH: self to: aSymbolUrlStringOrClass  
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromFactoryClass: aFactory to: aClassNameOrClass [ 

"Options:
	string - instanciate or report on supporters of a particular vaultAppId
	class - Ask the class to instanciate itself via that particualar factory
	        (e.g. Http/Http) Project Factories for project configured variants
"
 
 ^ ( self getClass: aClassNameOrClass) doubleSlashFromFactoryClass: aFactory andCH: self  

	



]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromFileClass: theFileClass with: aClassNameOrClassOrOrigin [
	| aClass |
	"Handle known origin symbols (rather then dd to Symbol)"
	(FileLocator supportedOrigins includes: aClassNameOrClassOrOrigin)
		ifTrue: [ ^ FileLocator origin: aClassNameOrClassOrOrigin ].
 
	aClass := self
			getClass: aClassNameOrClassOrOrigin
			ifAbsent: [ ^ self fileReferenceFrom: aClassNameOrClassOrOrigin ].

	^ aClass fileReferenceFrom: aClassNameOrClassOrOrigin
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromHub: receiverHub to: aThing [ 

"aHub is the original reciever of //, (self is aHub current)"
"stack overflow = problem!  (Hub//File)"
	^ aThing doubleSlashFromHub: receiverHub to: aThing andCH: self
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashFromString: aClassNameOrString with: it [ 

	^(self getClass: aClassNameOrString) // it
]

{ #category : 'comparing' }
Hub class >> startDoubleSlashfromPragma: anObject with: aClassNameOrClass [

	"So experimental do not know what this is for yet"
]

{ #category : 'as yet unclassified' }
Hub class >> startDoubleSlashfromPragmaClass: anObject with: aClassNameOrClass [ 

	"So experimental, do not know what it is for yet"
]
