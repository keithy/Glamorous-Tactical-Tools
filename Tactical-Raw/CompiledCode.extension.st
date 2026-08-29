Extension { #name : 'CompiledCode' }

{ #category : '*Tactical-Raw' }
CompiledCode >> asString [

	  ^self sourceCode
]

{ #category : '*Tactical-Raw' }
CompiledCode >> ttType [
	^ #compiled
]
