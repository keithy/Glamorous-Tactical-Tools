Class {
	#name : 'TTEmptyHub',
	#superclass : 'Object',
	#category : 'Tactical-Hub-Browser',
	#package : 'Tactical-Hub',
	#tag : 'Browser'
}

{ #category : 'as yet unclassified' }
TTEmptyHub class >> isHub [

  <ttIsHub>
  
	"Tactical Tools"
	
	^ TTEmptyHub ~~self
]

{ #category : 'as yet unclassified' }
TTEmptyHub class >> openHubBrowser [

^ (Hub getClass: #TTHubCodeBrowser) newBrowsing: self
			
]

{ #category : 'as yet unclassified' }
TTEmptyHub class >> openHubCodeBrowser [

^ (Hub getClass: #TTHubBrowser) newBrowsing: self
			
]
