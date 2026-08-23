Class {
	#name : 'SRLJira',
	#superclass : 'SRLUrl',
	#category : 'Tactical-SRL-Schemes',
	#package : 'Tactical-SRL',
	#tag : 'Schemes'
}

{ #category : 'as yet unclassified' }
SRLJira >> canRoute: aSymbol [
 
	^ #jira: == aSymbol
]
