Class {
	#name : 'TTVault',
	#superclass : 'Object',
	#instVars : [
		'store'
	],
	#classInstVars : [
		'currentVault'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'instance creation' }
TTVault class >> currentVault [

^ currentVault ifNil: [ currentVault := self new ]
]

{ #category : 'instance creation' }
TTVault class >> newTest [
	
	<gtExample>
	<return: #String>
	
	| dotEnv cache|
	
	dotEnv := TTDictionaryDotEnv newWithStoreKey: #dotEnv.
	cache  := TTDictionaryTiered newCache.
							
	cache appendTier: dotEnv.
							
	^ self basicNew
		store: cache
		initialize
]

{ #category : 'accessing' }
TTVault >> store: anObject [
	store := anObject
]
