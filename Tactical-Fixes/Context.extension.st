Extension { #name : 'Context' }

{ #category : '*Tactical-Fixes' }
Context >> logMe [

  <ttUtility>
  "Print this method invocation to the transcript"
  "In package Tactical-Fixes so it is loaded first"
  
	Transcript crShow: self method printString.
]
