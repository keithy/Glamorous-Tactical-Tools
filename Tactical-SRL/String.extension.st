Extension { #name : 'String' }

{ #category : '*Tactical-SRL' }
String >> envSubstUsing: aDictionary [
	| in |
	in := self readStream.

	^ String
		streamContents: [ :out | 
			[ out nextPutAll: (in upToAll: '${').
			in atEnd ]
				whileFalse: [ | var |
					var := in upTo: $}.
					out nextPutAll: (aDictionary at: var ifAbsent: [ var ]) ] ]
]
