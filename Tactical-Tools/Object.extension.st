Extension { #name : 'Object' }

{ #category : '*Tactical-Tools' }
Object class >> classPragmasNamed: aSymbol [

"The Tactical-Tools hypothesis is that two methods can do most of the work involving 
 pragmas searches and that we are happy to add these to the host-environment"

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
