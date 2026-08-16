Class {
	#name : 'TTBareHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Hub',
	#package : 'Tactical-Tools',
	#tag : 'Hub'
}

{ #category : 'as yet unclassified' }
TTBareHub class >> isHub [

  <ttIsHub>
  
	"Tactical Tools"
	
	^ TTBareHub !==self
]

{ #category : 'as yet unclassified' }
TTBareHub class >> openHubBrowser [

^ (Hub getClass: #TTHubBrowser) newBrowsing: self
			
]

{ #category : 'as yet unclassified' }
TTBareHub class >> openHubCodeBrowser [

^ (Hub getClass: #TTHubCodeBrowser) newBrowsing: self
			
]
