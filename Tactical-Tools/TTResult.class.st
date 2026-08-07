Class {
	#name : 'TTResult',
	#superclass : 'Object',
	#instVars : [
		'tool',
		'workingDirectory',
		'stdout',
		'output',
		'stderr',
		'request',
		'thePayload',
		'payloadReducers',
		'payloadTailReducers',
		'mappers',
		'mapped'
	],
	#classInstVars : [
		'exe'
	],
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTResult class >> @ workingDirectory [

	^ self new 
			workingDirectory: workingDirectory;
			yourself
 
]

{ #category : 'as yet unclassified' }
TTResult class >> findExecutable [
	^ (self findExecutable: self toolName) output stdout
]

{ #category : 'as yet unclassified' }
TTResult class >> findExecutable: tool [

	"^ GtOsSystemInfo current findExecutable: tool"
	
	^ (self makeShell:'/usr/bin/which ', tool) output stdout
]

{ #category : 'as yet unclassified' }
TTResult class >> initialize [
	
	self sessionManager
		registerSystemClassNamed: self name
		atPriority: 50.
	
	self startUp: true.
]

{ #category : 'as yet unclassified' }
TTResult class >> makeRawShell: script [

^ GtExternalProcessBuilder new
			command: self osSHELL;
			args: {
				'-c'.
			  script asString }.
	
]

{ #category : 'as yet unclassified' }
TTResult class >> makeShell: script [

	"Others add the -l flag we load the non-interative startup file"
	
^ (self makeRawShell: script) in: [ :exec |
			
			(exec command endsWith:'bash')
				ifTrue: [ exec env: 'BASH_ENV' value: '~/.bashrc' ].
  
  ]; yourself
		  
]

{ #category : 'as yet unclassified' }
TTResult class >> osHOME [

	^ Smalltalk os environment at: 'HOME' ifAbsent: '/bin/sh'.
]

{ #category : 'as yet unclassified' }
TTResult class >> osPATH [

	^ Smalltalk os environment at: 'PATH' ifAbsent: '/bin/sh'.
]

{ #category : 'as yet unclassified' }
TTResult class >> osSHELL [

	^ Smalltalk os environment at: 'SHELL' ifAbsent: '/bin/sh'.
]

{ #category : 'as yet unclassified' }
TTResult class >> path [

^ '~/.local/bin:~/.bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin' 
			copyReplaceAll: '~' with: self osHOME.
]

{ #category : 'as yet unclassified' }
TTResult class >> reset [

	exe := nil.
	
^ self
	
]

{ #category : 'as yet unclassified' }
TTResult class >> startUp: restarting [

	self withAllSubclassesDo: [ :toolClass | toolClass reset ]
]

{ #category : 'as yet unclassified' }
TTResult class >> testForNoisyBashProfile [

	<gtExample>
	<ttHealthy>
	 
	| path |
	path := GtOsSystemInfo current findExecutable: 'ls'.
	
	self assert: (path  exists) description: 'Files sourced by shell -l must not write any output (add guard clause)'

	

]

{ #category : 'as yet unclassified' }
TTResult class >> testPing [

	<gtExample>
	
	self assert: ((self makeShell: 'echo pong') output stdout = 'pong') description: 'Shell is not starting cleanly. Check ~/.bashrc etc.'
]

{ #category : 'as yet unclassified' }
TTResult class >> toolDescription [

^ self class comment
	
]

{ #category : 'as yet unclassified' }
TTResult class >> toolExe [
	^ exe ifNil: [ exe := self findExecutable ]
]

{ #category : 'as yet unclassified' }
TTResult class >> toolName [

^ self subclassResponsibility
	
]

{ #category : 'as yet unclassified' }
TTResult class >> toolShortDescription [

^ self class comment lines first
	
]

{ #category : 'accessing' }
TTResult >> buildShell [
 
" ^ GtExternalProcessBuilder new
			command: self osSHELL;
			args: {
				'-c'.
			  script asString }.
^ (self makeRawShell: script) in: [ :exec |
			
			(exec command endsWith:'bash')
				ifTrue: [ exec env: 'BASH_ENV' value: '~/.bashrc' ].
  
  ]; yourself"
]

{ #category : 'as yet unclassified' }
TTResult >> getMapped [

  ^ mapped ifNil: [ 
  
			mapped := self inject: nil into: (mappers ifNil: #getMappingStart).
		] 
]

{ #category : 'as yet unclassified' }
TTResult >> getMappingStart [
 
   "do not be tempted to refactor this method away, may be customized by subclasses"
	 ^ self getPayload
]

{ #category : 'as yet unclassified' }
TTResult >> getOutput [

	output ifNil: [ output := request 
										ifNotNil: [ :req | req output ] 
										ifNil:    [ self error: 'what a to do' ] ].
	
	^ output 
]

{ #category : 'as yet unclassified' }
TTResult >> getPayload [

  ^ thePayload ifNil: [ 
  
			self payload: payloadTailReducers.
			thePayload := self inject: nil into: (payloadReducers ifNil: #getPayloadStart).
		].
	
 
]

{ #category : 'as yet unclassified' }
TTResult >> getPayloadStart [
 
   "do not be tempted to refactor this method away, may be customized by subclasses"
	 ^ self getStdout
]

{ #category : 'as yet unclassified' }
TTResult >> getStderr [

	stderr ifNil: [ stderr := output stderr ].
	
	^ stderr 
]

{ #category : 'as yet unclassified' }
TTResult >> getStdout [

	stdout ifNil: [ stdout := self getOutput stdout ].
	
	^ output 
]

{ #category : 'accessing' }
TTResult >> inject: batch into: actionBlockSymbolArrayOrNil [ 
	
	| action |
	
	action := actionBlockSymbolArrayOrNil.
	
	action ifNil: [ ^ batch ].
	
	action isSymbol ifTrue: [ ^ self perform: actionBlockSymbolArrayOrNil withEnoughArguments: { batch } ].
	
	action isBlock ifTrue: [ ^ action cull: batch cull: self ].

	action isArray ifTrue: [ ^ action inject: batch into: [ :out :each | self inject: out into: each ] ].
	
	self error: 'someone did not plan for this option'
	

]

{ #category : 'as yet unclassified' }
TTResult >> mapping: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      mappers ifNil: [ mappers := OrderedCollection with: #getMappingStart ].
      mappers add: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> payload: actionBlockSymbolArrayOrNil [
 
 		 actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      payloadReducers ifNil: [ payloadReducers := OrderedCollection with: #getPayloadStart ].
      payloadReducers add: actionBlockSymbolArrayOrNil
]

{ #category : 'as yet unclassified' }
TTResult >> payloadTail: actionBlockSymbolArrayOrNil [

			actionBlockSymbolArrayOrNil ifNil: [ ^ self ].
      payloadTailReducers ifNil: [ payloadTailReducers := OrderedCollection new ].
      payloadTailReducers add: actionBlockSymbolArrayOrNil
]

{ #category : 'accessing' }
TTResult >> request [
	^ request
]

{ #category : 'accessing' }
TTResult >> request: anObject [
	request := anObject
]

{ #category : 'accessing' }
TTResult >> tool [
	^ tool
]

{ #category : 'accessing' }
TTResult >> tool: anObject [
	tool := anObject
]

{ #category : 'accessing' }
TTResult >> toolExe [

	 ^ self class toolExe 
]

{ #category : 'accessing' }
TTResult >> workingDirectory [
	^ workingDirectory
]

{ #category : 'accessing' }
TTResult >> workingDirectory: anObject [
	workingDirectory := anObject
]
