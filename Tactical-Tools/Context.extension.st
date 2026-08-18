Extension { #name : 'Context' }

{ #category : '*Tactical-Tools' }
Context >> logMe [

  <ttUtility>
  "Print this method invocation to the transcript"
  
	Transcript crShow: self method printString.
]
