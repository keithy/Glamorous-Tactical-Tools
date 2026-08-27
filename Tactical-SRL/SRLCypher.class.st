Class {
	#name : 'SRLCypher',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLCypher class >> canRoute: aSymbol [
 
	^ #(encypher: decypher:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLCypher >> // aString [

	^ self perform: scheme with: aString
]

{ #category : 'as yet unclassified' }
SRLCypher >> cypher [
| safeChars n shuffled forward reverse |
      safeChars := 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_~*&^%$£#@!()=+}{][\|/?`~.,<>;:'.
      n := safeChars size.

      forward := ByteArray new: 256.
      reverse := ByteArray new: 256.

      shuffled := safeChars asArray shuffledBy: (Random seed: self secretUUID hash).

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

	^ aString copy translateWith: self cypher value
]

{ #category : 'as yet unclassified' }
SRLCypher >> encypher: aString [

	^ aString copy translateWith: self cypher key
]

{ #category : 'as yet unclassified' }
SRLCypher >> secretUUID [

^ GlobalIdentifier uniqueInstance secretUUID
]
