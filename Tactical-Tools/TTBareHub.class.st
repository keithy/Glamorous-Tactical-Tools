Class {
	#name : 'TTBareHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTBareHub class >> openHubBrowser [

^ (TheHub getClass: #TTHubBrowser) newBrowsing: self
			
]

{ #category : 'as yet unclassified' }
TTBareHub class >> openHubCodeBrowser [

^ (TheHub getClass: #TTHubCodeBrowser) newBrowsing: self
			
]
