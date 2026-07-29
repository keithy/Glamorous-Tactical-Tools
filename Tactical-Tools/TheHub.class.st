"
I am an interface to Pharo image/environment provided singletons. 

Projects may subclass me to have a customised presentation of that interface. 

If code is to be portable to other smalltalk environments I am that replacable interface.

Values are obtained from the surrounding image context via a resumable notification. This provides a mechanism for these singletons to be overriden within a block context, and customized via subclassing.
"
Class {
	#name : 'TheHub',
	#superclass : 'Notification',
	#classVars : [
		'CurrentHubClass'
	],
	#classInstVars : [
		'ramdiskFileSystem'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'accessing' }
TheHub class >> _openFileBrowser [

  "open a file browser, but a more discoverable option would be to list the locations"
  
	^ '.' asFileReference
]

{ #category : 'environment' }
TheHub class >> _ramdiskFileSystem [
	
	"class instance variable provides inherant image persistence, but use public method"
	^ ramdiskFileSystem ifNil: [  ramdiskFileSystem := FileSystem memory ]
]

{ #category : 'environment' }
TheHub class >> _ramdiskFileSystemClobber [
	
	ramdiskFileSystem := nil
]

{ #category : 'accessing' }
TheHub class >> classNamed: aName [

	^ Smalltalk at: aName asSymbol
]

{ #category : 'accessing' }
TheHub class >> classNamed: aName ifAbsent: aBlock [

	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TheHub class >> current [
	
	^ CurrentHubClass ifNil: [ self ]
]

{ #category : 'environment' }
TheHub class >> during: aBlock use: substituteValue for: methodSelector [
	
	^ aBlock on: self current do: [  :ex | 
	
			ex tag == methodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'environment' }
TheHub class >> fileReferenceFrom: aString [

	"Answer a FileReference or FileLocator from the supplied string.
	FileLocator origins are available as formatted strings, e.g.
		{home}/lepiter
	is the equivalent of
		FileLocator home / 'lepiter'"

	| namedDirectories regex dirName path |

	namedDirectories := self namedDirectories. 
	
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
TheHub class >> for: instanceMethodSelector respondWith: substituteValue during: aBlock [
	
	^ aBlock on: CurrentHubClass do: [  :ex | 
	
			ex tag == instanceMethodSelector
				ifTrue: [ ex resume: substituteValue ] 
				ifFalse: [ ex pass ]
		]
]

{ #category : 'accessing' }
TheHub class >> globalAt: aName ifAbsent: aBlock [

	^ Smalltalk at: aName asSymbol ifAbsent: aBlock
]

{ #category : 'environment' }
TheHub class >> httpClientMaximumEntitySize [

	^ CurrentHubClass _httpClientMaximumEntitySize
		
]

{ #category : 'environment' }
TheHub class >> initialize [
	
	self sessionManager
		registerSystemClassNamed: self name
		atPriority: 50.
	
	self startUp: true.
]

{ #category : 'accessing' }
TheHub class >> lookupClass: aName [

	"testable equivalent of #MyClass asClass"
	
	
]

{ #category : 'environment' }
TheHub class >> namedDirectories [
	<ttSpoke>
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> onStartUpBidToBeCurrentHubClass [

	^ 1
]

{ #category : 'accessing' }
TheHub class >> openFileBrowser [

  "open a file browser, via the current project hub"
  
	^ self current _openFileBrowser
]

{ #category : 'environment' }
TheHub class >> osEnvironment [
	<ttSpoke>
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> osPlatform [
   <ttSpoke>
   
	^ self osEnvironment platform
]

{ #category : 'environment' }
TheHub class >> ramdisk [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> ramdiskFileSystem [
	
	^ CurrentHubClass _ramdiskFileSystem 
]

{ #category : 'environment' }
TheHub class >> ramdiskReset [
	
	self current _ramdiskReset
	
]

{ #category : 'environment' }
TheHub class >> ramdiskTmpUseDuring: aBlock [
	
	^ self for: #ramdisk respondWith: FileSystem memory during: aBlock
]

{ #category : 'environment' }
TheHub class >> sessionManager [
	
	^ self signalAuto
]

{ #category : 'environment' }
TheHub class >> signalAuto [	

	^ self signal: thisContext sender selector withTag: thisContext sender selector
	

]

{ #category : 'environment' }
TheHub class >> spokes [

^ self spokesPragmas collect: [ :ea | ea method ]
		 
		
" ^ self class allMethods select: [ :ea | ea hasPragmaNamed: #ttSpoke ]
"
]

{ #category : 'environment' }
TheHub class >> spokesPragmas [

^ Pragma
		allNamed: #ttSpoke
		from: self current class
		to: TheHub class
		 
		
" ^ self class allMethods select: [ :ea | ea hasPragmaNamed: #ttSpoke ]
"
]

{ #category : 'environment' }
TheHub class >> startUp [
	
	| max bid |
	
	CurrentHubClass := self. 
	
	max := 0.
	self allSubclassesDo: [ :hubClass | 
	
		bid := hubClass onStartUpBidToBeCurrentHubClass.
		
		bid > max ifTrue: [
				
				CurrentHubClass := hubClass. 
				max := bid.
				
		]
	].
]

{ #category : 'environment' }
TheHub class >> unixMillisToDate: millisSinceUnixEpoch [

	<ttUtility>

	^ (DateAndTime unixEpoch + ((millisSinceUnixEpoch ifNil: [ ^ nil ]) / 1000)) asDate
]

{ #category : 'environment' }
TheHub >> cypher [

	^ self class cypher 
	

]

{ #category : 'environment' }
TheHub >> defaultAction [

	^ self perform: tag
]

{ #category : 'environment' }
TheHub >> namedDirectories [

	^ (FileLocator supportedOrigins collect: [ :origin | origin -> (FileLocator origin: origin) ]) asDictionary
	
]

{ #category : 'environment' }
TheHub >> osEnvironment [

	^ OSEnvironment current
]

{ #category : 'environment' }
TheHub >> ramdisk [
	
	^ self current _ramdiskFileSystem
]

{ #category : 'environment' }
TheHub >> ramdiskReset [
	
	CurrentHubClass _ramdiskFileSystemClobber
	
]

{ #category : 'environment' }
TheHub >> sessionManager [

 <ttSpoke>
 
	^ SessionManager default
]
