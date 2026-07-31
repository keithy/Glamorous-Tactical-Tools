Extension { #name : 'Object' }

{ #category : '*Tactical-Tools' }
Object class >> classPragmasNamed: aSymbol [

^ Pragma 
		allNamed: aSymbol
		from: self class
		toButExcluding: Object class 
]

{ #category : '*Tactical-Tools' }
Object class >> pragmasNamed: aSymbol [

^ Pragma 
		allNamed: aSymbol
		from: self
		toButExcluding: Object  
]
