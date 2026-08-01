Extension { #name : 'Array' }

{ #category : '*Tactical-Tools' }
Array >> <= aCollection [
	
	<ttExtension>
	
	"using only a <= allows for a and b to be arrays, only #<= needs implementing"
	
	self with: aCollection do: [ :a :b | (a = b) ifFalse: [ ^ (a <= b) ] ].
	
 ^ true
]
