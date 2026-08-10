Extension { #name : 'GtL' }

{ #category : '*Tactical-Tools' }
GtL class >> gt [
	^ GtLChatRegistry current newGtChat
]

{ #category : '*Tactical-Tools' }
GtL class >> tt [
	^ GtLChatRegistry current newTTChat
]
