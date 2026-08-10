Class {
	#name : 'TTDictionaryOSEnv',
	#superclass : 'TTDictionaryBacked',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryOSEnv >> readSource [
	
	self removeAll.
	self addAll: self source osEnvironment.
	
]
