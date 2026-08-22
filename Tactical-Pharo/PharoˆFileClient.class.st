Class {
	#name : 'PharoˆFileClient',
	#superclass : 'ZnClient',
	#instVars : [
		'localPathString',
		'fileReference',
		'fileUrl'
	],
	#category : 'Tactical-Pharo-Guzzler',
	#package : 'Tactical-Pharo',
	#tag : 'Guzzler'
}

{ #category : 'as yet unclassified' }
PharoˆFileClient >> execute [

	^ self
]

{ #category : 'as yet unclassified' }
PharoˆFileClient >> isHttp [
	
	"guard allowing clients to avoid treating us as an http client"
	
	^ false
]

{ #category : 'as yet unclassified' }
PharoˆFileClient >> response [

	" hand over to SRLFile"
	^ #file:/ (fileUrl withoutPrefix: 'file://')
	
]

{ #category : 'as yet unclassified' }
PharoˆFileClient >> url [ 
	
	^ fileUrl  
]

{ #category : 'as yet unclassified' }
PharoˆFileClient >> url: aUrl [

"at this point ZnClient is not interested in handling file:// scheme type,
it starts checking hosts and authentication. From this point on being
a subclass of ZnClient is not of any use to us.

If our callers use #isHttp to guard against treating us like an Http
client we dont need to be"

	fileUrl := aUrl  
]
