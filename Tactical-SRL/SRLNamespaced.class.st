Class {
	#name : 'SRLNamespaced',
	#superclass : 'SRLRouter',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLNamespaced class >> canRoute: aSymbol [

	^ #(pretty: namespaced: #localname: #namespace:) includes: aSymbol
]

{ #category : 'as yet unclassified' }
SRLNamespaced class >> example [
	<gtExample>
	^ #namespaced: // self name
]

{ #category : 'as yet unclassified' }
SRLNamespaced class >> exampleMatchesShortCut [
	<gtExample>
	^ (#namespaced://self name) == (self namespaced: self name)
]

{ #category : 'as yet unclassified' }
SRLNamespaced class >> namespaced: aClassOrName [

	"local shortcut"
	 ^ self new namespaced:(SRLClass class:aClassOrName)
   
]

{ #category : 'accessing' }
SRLNamespaced >> localname: aClass [

	^ (self namespaced: aClass) value
]

{ #category : 'accessing' }
SRLNamespaced >> namespace: aClass [ 
 
	^ (self namespaced: aClass ) key
]

{ #category : 'accessing' }
SRLNamespaced >> namespaced: aClass [ 

	^ (SRLClass class: #TTNamespaces) namespaced: aClass 
]

{ #category : 'accessing' }
SRLNamespaced >> pretty: aClassOrName [

	^ ((self namespaced: aClassOrName) value ifNil: [ ^'' ]) splitCamelCase joinUsing: ' '
]

{ #category : 'accessing' }
SRLNamespaced >> resolve [

	^ self resolve: (SRLClass class:thing)

	 
]

{ #category : 'accessing' }
SRLNamespaced >> resolve: aClass [

	^ self perform: scheme with: aClass

	 
]
