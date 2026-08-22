Class {
	#name : 'TheCuriousity',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TheCuriousity class >> baselines [

  "Baselines"

	<ttSpoke>
	
	^ Pragma allNamed: #baseline
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> chicken [

  "The Chicken?"

	<ttSpoke>
	
	^ BlChicken bouncingChicken
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> classesThatAreUniqueIds [

  "Classes that dont do a lot - unique ids"

	<ttSpoke>
	
	^ BlElementUniqueId allSubclasses
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> isHub [

  <ttIsHub>
  
	"Curious Things"
	
	^ true
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> pragmaClassSideUnaryMethods [

 "Potential spoke methods"

 <ttSpoke>
 
^ Pragma all select: [ :ea | ea method isClassSide and: [ ea method numArgs == 0 ] ]
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> pragmasAllFixes [

	"Fixes to base environment <ttFix>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttFix
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> stencils [

  "Stencils"

	<ttSpoke>
	
	^ BrStencil allSubclasses
]
