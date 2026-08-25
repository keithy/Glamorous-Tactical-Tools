Class {
	#name : 'TTToolRequest',
	#superclass : 'TTRequestAbstract',
	#instVars : [
		'tool',
		'workingDirectory',
		'request',
		'thePayload',
		'readPayloadUsing'
	],
	#classInstVars : [
		'exe'
	],
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTToolRequest class >> findExecutable [
	^ (self findExecutable: self toolName) output stdout
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> findExecutable: tool [

	"^ GtOsSystemInfo current findExecutable: tool"
	
	^ (self makeShell:'/usr/bin/which ', tool) output stdout
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> makeRawShell: script [

^ GtExternalProcessBuilder new
			command: self osSHELL;
			args: {
				'-c'.
			  script asString }.
	
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> makeShell: script [

	"Others add the -l flag we load the non-interative startup file"
	
^ (self makeRawShell: script) in: [ :exec |
			
			(exec command endsWith:'bash')
				ifTrue: [ exec env: 'BASH_ENV' value: '~/.bashrc' ].
  
  ]; yourself
		  
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> osHOME [

	^ Smalltalk os environment at: 'HOME' ifAbsent: '/bin/sh'.
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> osPATH [

	^ Smalltalk os environment at: 'PATH' ifAbsent: '/bin/sh'.
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> osSHELL [

	^ Smalltalk os environment at: 'SHELL' ifAbsent: '/bin/sh'.
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> path [

^ '~/.local/bin:~/.bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin' 
			copyReplaceAll: '~' with: self osHOME.
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> reset [

	exe := nil.
	
^ self
	
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> startUpAtToolPriority: restarting [

	<ttStartUp>
	
	self withAllSubclassesDo: [ :toolClass | toolClass reset ]
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> testForNoisyBashProfile [

	<gtExample>
	<ttHealthCheck>
	 
	| path |
	path := GtOsSystemInfo current findExecutable: 'ls'.
	
	self assert: (path  exists) description: 'Files sourced by shell -l must not write any output (add guard clause)'

	

]

{ #category : 'as yet unclassified' }
TTToolRequest class >> testPing [

	<gtExample>
	
	self assert: ((self makeShell: 'echo pong') output stdout = 'pong') description: 'Shell is not starting cleanly. Check ~/.bashrc etc.'
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> toolDescription [

^ self class comment
	
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> toolExe [
	^ exe ifNil: [ exe := self findExecutable ]
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> toolName [

^ self subclassResponsibility
	
]

{ #category : 'as yet unclassified' }
TTToolRequest class >> toolShortDescription [

^ self class comment lines first
	
]

{ #category : 'accessing' }
TTToolRequest >> buildShell [
 
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
TTToolRequest >> getOutputProvider [

	output ifNil: [ output := request 
										ifNotNil: [ :req | req output ] 
										ifNil:    [ self error: 'what a to do' ] ].
	
	^ output 
]

{ #category : 'as yet unclassified' }
TTToolRequest >> getPayload [

	thePayload ifNil: [ thePayload := self verifiedContents ].
	
	^ thePayload 
]

{ #category : 'as yet unclassified' }
TTToolRequest >> getStderr [

	stderr ifNil: [ stderr := output stderr ].
	
	^ stderr 
]

{ #category : 'as yet unclassified' }
TTToolRequest >> getVerifiedContents [

	stdout ifNil: [ stdout := self getOutputProvider stdout ].
	
	^ output 
]

{ #category : 'as yet unclassified' }
TTToolRequest >> payload: actionBlockSymbolArrayOrNil [
	readPayloadUsing := Array
			with: (readPayloadUsing ifNil: #verifiedContents)
			with: actionBlockSymbolArrayOrNil
]

{ #category : 'accessing' }
TTToolRequest >> tool [
	^ tool
]

{ #category : 'accessing' }
TTToolRequest >> tool: anObject [
	tool := anObject
]

{ #category : 'accessing' }
TTToolRequest >> toolExe [

	 ^ self class toolExe 
]

{ #category : 'accessing' }
TTToolRequest >> workingDirectory [
	^ workingDirectory
]

{ #category : 'accessing' }
TTToolRequest >> workingDirectory: anObject [
	workingDirectory := anObject
]
