Class {
	#name : 'SRLCypher',
	#superclass : 'SRLRouter',
	#instVars : [
		'type'
	],
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLCypher class >> canRoute: aSymbol [
 
	^ #(encypher: decypher:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLCypher class >> ed25519 [

^ (#file://'{home}/.ssh/id_ed25519') contents
]

{ #category : 'as yet unclassified' }
SRLCypher class >> rsa [

^ (#file://'{home}/.ssh/id_rsa') contents
]

{ #category : 'as yet unclassified' }
SRLCypher class >> secret [

^ ((#file://'{home}/.ssh/secrets') / ((Hub current hubId) asUppercase, '_SECRET')) contents
]

{ #category : 'as yet unclassified' }
SRLCypher class >> testCypher [

	"Cypher is only safe to use on short randomly generated keys"
	
	<gtExample>

	| message cyphered decyphered |
	message := 'The quick brown fox jumps! over the lazy dog.'.
	cyphered := #encypher://message.
	decyphered := #decypher://cyphered.

	self assert: message equals: decyphered.
	 
]

{ #category : 'as yet unclassified' }
SRLCypher class >> uuid [

^ GlobalIdentifier uniqueInstance secretUUID
]

{ #category : 'as yet unclassified' }
SRLCypher >> cypher [
| safeChars n shuffled forward reverse |
      safeChars := 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_~*&^%$£#@!()=+}{][\|/?`.,<>;:'.
      n := safeChars size.

      forward := ByteArray new: 256.
      reverse := ByteArray new: 256.

      shuffled := safeChars asArray shuffledBy: self randomizer.

      1 to: n do: [ :i |
          | in out |
          in := (safeChars at: i) asciiValue.
          out := (shuffled at: i) asciiValue.
          forward at: in + 1 put: out.
          reverse at: out + 1 put: in ].

      ^ forward -> reverse
]

{ #category : 'as yet unclassified' }
SRLCypher >> decypher: aString [

	^ (aString copyAfter: $_) translateWith: self cypher value
]

{ #category : 'as yet unclassified' }
SRLCypher >> encypher: aString [

	| cypher encyphered decyphered original |
	
	cypher:= self cypher.
	original := aString copyAfter: $_.
	encyphered := original copy translateWith: cypher key.
	decyphered := encyphered copy translateWith: cypher value.
	
	self assert: decyphered equals: original.
	
	^ type, '_', encyphered
	
]

{ #category : 'as yet unclassified' }
SRLCypher >> initialize [

	type := (thing copyUpTo: $_) asSymbol
]

{ #category : 'as yet unclassified' }
SRLCypher >> randomizer [

	^ Random seed: (self class askFor: type ifAbsent: [ self error: 'Seed type not provided, see SRLCypher class comment']) hash.
]

{ #category : 'as yet unclassified' }
SRLCypher >> resolve: aString [
 
	^ self perform: scheme with:  aString
]
