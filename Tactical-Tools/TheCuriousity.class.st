Class {
	#name : 'TheCuriousity',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Curious',
	#package : 'Tactical-Tools',
	#tag : 'Curious'
}

{ #category : 'as yet unclassified' }
TheCuriousity class >> baselines [

  "Baselines"

	<ttSpoke>
	
	^ Pragma allNamed: #baseline
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> classesThatAreUniqueIds [

  "Classes that dont do a lot - unique ids"

	<ttSpoke>
	
	^ BlElementUniqueId allSubclasses
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> pragmaClassSideUnaryMethods [

 "Potential spoke methods"

 <ttSpoke>
 
^ Pragma all select: [ :ea | ea method isClassSide and: [ ea method numArgs == 0 ] ]
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> stencils [

  "Stencils"

	<ttSpoke>
	
	^ BrStencil allSubclasses
]
