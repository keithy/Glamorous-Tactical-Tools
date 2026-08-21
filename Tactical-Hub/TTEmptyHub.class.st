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
TTEmptyHub class >> open [
	"subclasses choose their preferred view"
	
^ self openHubCodeBrowser

]

{ #category : 'as yet unclassified' }
TTEmptyHub class >> openHubBrowser [

^ (#class:// #TTHubBrowser) newBrowsing: self
			
]

{ #category : 'as yet unclassified' }
TTEmptyHub class >> openHubCodeBrowser [

^ (#class:// #TTHubCodeBrowser) newBrowsing: self
			
]
