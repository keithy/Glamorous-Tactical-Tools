Extension { #name : 'ZnStatusLine' }

{ #category : '*Tactical-Tools' }
ZnStatusLine >> asErrorMessage [

	^ String streamContents: [ :str | self printCodeAndReasonOn: str ]
]
