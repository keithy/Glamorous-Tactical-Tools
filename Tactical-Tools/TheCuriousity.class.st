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
TheCuriousity class >> pragmasAllFixes [

	"Fixes to base environment <ttFix>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttFix
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> pragmasAllToDo [

	"To do flags <ttToDo>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttToDo
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> pragmasAllUtility [

	"Tactical-Tools utility methods <ttUtility>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttUtility
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> pragmasAllWall [

	"Tactical-Tools wall methods <ttWall>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttWall
	

]

{ #category : 'as yet unclassified' }
TheCuriousity class >> pragmasExtensions [

	"Worthy extensions <ttExtension>"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttExtension
]

{ #category : 'as yet unclassified' }
TheCuriousity class >> stencils [

  "Stencils"

	<ttSpoke>
	
	^ BrStencil allSubclasses
]
