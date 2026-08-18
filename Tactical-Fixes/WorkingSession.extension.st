Extension { #name : 'WorkingSession' }

{ #category : '*Tactical-Fixes' }
WorkingSession >> runList: aList do: aBlock [

	<ttFix>
	
	"Fix Resilience - Handle missing classes in startup process"
	
	aList do: [ :each |
		[ [ aBlock value: each ] on: KeyNotFound do: [ :knf | Transcript crShow: (knf description, ' (stale entry in SessionManager startupList)') ] ]
			on: Exception
			do: [ :error | self errorHandler handleError: error] ]
]
