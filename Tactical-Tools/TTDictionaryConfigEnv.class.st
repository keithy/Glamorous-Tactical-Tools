Class {
	#name : 'TTDictionaryConfigEnv',
	#superclass : 'TTDictionaryBacked',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTDictionaryConfigEnv class >> makeAsTier [
	"our test show it all"

	<gtExample>
	| firstTier newTier |
	self searchPath
		do: [ :assoc | 
			| tierKey file |
			tierKey := assoc key.
			file := assoc value.

			FileNotification signal: file.

			file exists
				ifTrue: [ newTier := self makeAsTierWithKey: tierKey source: file.

					firstTier
						ifNil: [ firstTier := newTier ]
						ifNotNil: [ firstTier tierAppend: newTier ] ] ].

	^ firstTier
]

{ #category : 'as yet unclassified' }
TTDictionaryConfigEnv class >> newTest [

	<gtExample>
	
	^ self newSource: 

	'HELLO=WORLD
	HELLO1=WORLD1
	HELLO2_PASS="WORLD2" 
	HELLO3_ENCODED="V09STEQz"';
	    yourself
]

{ #category : 'instance creation' }
TTDictionaryConfigEnv class >> searchPath [
	<gtExample>
 
	^ self searchPathFor: (Hub currentTestable)
]

{ #category : 'instance creation' }
TTDictionaryConfigEnv class >> searchPathFor: whoami [
	"Prefer / (a,'.env) over / a , 'env' " 

	| vmId hubId |
	
	(whoami askFor: #isWhoAmI) ifFalse: [ self error: 'Must provide identity' ].
	
	vmId := whoami vmId asLowercase.
	hubId := whoami hubId asLowercase.

	^ {
		#cwd     -> ((hubId , '.env') asFileReference).
		
		"per user"
		#'user-config' -> (#file: // #config / vmId / (hubId , '.env')) resolve.
	  #'user-prefs' -> (#file: // #preferences / (vmId,'.', hubId , '.env') ) resolve.
	   
	}
]

{ #category : 'instance creation' }
TTDictionaryConfigEnv class >> traceCurrentSearchPath [
	
	<gtExample>
	
	^ FileNotification collectDuring: [ self makeAsTier ]
]

{ #category : 'as yet unclassified' }
TTDictionaryConfigEnv >> gtFileReferencePathFor: aView [
	<gtView>
	^ aView forward
		title: 'Source';
		priority: 1;
		object: [ self source asFileReference ];
		view: #gtContentsFor:
]

{ #category : 'as yet unclassified' }
TTDictionaryConfigEnv >> readFromStream: aStream [

	"A little rudimentary"
	[ [ aStream atEnd ]
		whileFalse: [ | line key value |
			line := aStream nextLine readStream.
			key := line upTo: $=.
			value := line upToEnd.
			(key beginsWith: '#')
				ifFalse: [ value isEmpty
						ifFalse: [ self at: key write: value trimRight withoutQuoting ] ] ] ]
						
		ensure: [ aStream close ]
]

{ #category : 'as yet unclassified' }
TTDictionaryConfigEnv >> readSource [
	
	self removeAll.
	self readFromStream: self source readStream.
	
]
