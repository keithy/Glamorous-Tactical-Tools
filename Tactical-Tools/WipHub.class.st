Class {
	#name : 'WipHub',
	#superclass : 'Object',
	#category : 'Tactical-Tools-Demo',
	#package : 'Tactical-Tools',
	#tag : 'Demo'
}

{ #category : 'as yet unclassified' }
WipHub class >> TacticalHub [ 

	"Tactical Tools"
	
	<ttHub>
		
  ^  #TTTacticalToolsHub asClass 
]

{ #category : 'as yet unclassified' }
WipHub class >> currentVault [

	"Vicarious Vault (current)"
	
	<ttSpoke>
	
	^ Hub currentVault
]

{ #category : 'as yet unclassified' }
WipHub class >> fileLocatorSupportedOriginsResolved [
 
   "FileLocator Named file origins RESOLVED"

   <ttSpoke>
 	
 	| origins |
 	
 	origins := OrderedCollection new.
 	
	FileLocator supportedOriginsDo: [ :aResolver :selector |
			origins add: (FileLocator origin: selector) resolve
	].
	
	^ origins
]

{ #category : 'as yet unclassified' }
WipHub class >> imageFileSystemsInfo [
	
	"Filesystems in-image"
	
	<ttSpoke>

	^ ImageStore imageFileSystemsInfo
]

{ #category : 'as yet unclassified' }
WipHub class >> isHub [ 

  <ttIsHub>
  
	"Work In Progress"
	
	^  true
]

{ #category : 'as yet unclassified' }
WipHub class >> pragmasAll_ttUtility [

	"To Dos"
	
	<ttSpoke>
	
	^ Pragma allNamed: #ttToDo
	
]

{ #category : 'as yet unclassified' }
WipHub class >> supportedOriginResolvers [
 
   "Named file origin resolvers"

   <ttSpoke>
 	
 	| origins |
 	
 	origins := OrderedCollection new.
 	
	FileLocator supportedOriginsDo: [ :aResolver :selector |
			origins add:  aResolver printString , ' >> ', selector
	].
	^ origins
]

{ #category : 'as yet unclassified' }
WipHub class >> theHub [
	
	<ttHub>
	
	"The Current Hub"

	^ Hub current
]

{ #category : 'as yet unclassified' }
WipHub class >> theVault [

	"Vicarious Vault"
	
	<ttSpoke>
	
	^ TTVault currentVault
]
