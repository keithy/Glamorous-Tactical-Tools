Class {
	#name : 'TTDictionaryOSEnv',
	#superclass : 'TTDictionaryBacked',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryOSEnv class >> makeAsTier [

	<gtExample>

	^  self makeAsTierWithKey: #os source: Hub 
]

{ #category : 'as yet unclassified' }
TTDictionaryOSEnv class >> new [

 	"super new initializes the dictionary, 
 	 topTier runs our own #initialize after all tiers have been composed"

	^ (super new)
			setSource: Hub;
			yourself
]

{ #category : 'as yet unclassified' }
TTDictionaryOSEnv >> readSource [
	
	self removeAll.
	self addAll: self source osEnvironment.
	
]
