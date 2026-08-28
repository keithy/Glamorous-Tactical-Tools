Class {
	#name : 'StringTemplate',
	#superclass : 'ByteString',
	#type : 'bytes',
	#category : 'Tactical-SRL-Vault',
	#package : 'Tactical-SRL',
	#tag : 'Vault'
}

{ #category : 'printing' }
StringTemplate >> envSubst: aDict [
	| in |
	in := self readStream.

	^ String
		streamContents: [ :out | 
			[ out nextPutAll: (in upToAll: '${').
			in atEnd ]
				whileFalse: [ | var |
					var := in upTo: $}.
					out nextPutAll: (aDict at: var ifAbsent: [ var ]) ] ]
]

{ #category : 'printing' }
StringTemplate >> isTemplate [

	^ true
]
