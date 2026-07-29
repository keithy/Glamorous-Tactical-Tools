Extension { #name : 'WorkingSession' }

{ #category : '*Tactical-Tools-Fixes' }
WorkingSession >> runList: aList do: aBlock [
	aList do: [ :each |
		[ [ aBlock value: each ] on: KeyNotFound do: [ :knf | Transcript crShow: knf ] ]
			on: Exception
			do: [ :error | self errorHandler handleError: error] ]
]
