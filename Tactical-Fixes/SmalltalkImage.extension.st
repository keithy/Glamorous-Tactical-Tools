Extension { #name : 'SmalltalkImage' }

{ #category : '*Tactical-Fixes' }
SmalltalkImage >> allClasses [

  "Annotation - mark as avoid"
  <ttFix>
	<ttQuirk>
  <ttAvoid>
      
	"Return all the class defines in the SmalltalkImage"
	"Smalltalk allClasses"
	"May be we could discard this one in the future"
	^ globals allClasses
]
