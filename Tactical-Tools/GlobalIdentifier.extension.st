Extension { #name : 'GlobalIdentifier' }

{ #category : '*Tactical-Tools' }
GlobalIdentifier >> unobfuscate: aMaskedHash [

	^ aMaskedHash bitXor: self secretUUID hash
]
