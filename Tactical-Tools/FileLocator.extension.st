Extension { #name : 'FileLocator' }

{ #category : '*Tactical-Tools' }
FileLocator class >> namedFileLocations [
 
 	<gtExample>
 	
 	| origins | 
 	
 	origins := Dictionary new.
 	
	 self supportedOriginsDo: [ :resolver :selector | 
		 	
		 		origins at: selector put: (FileLocator origin: selector) 
	 ].
	 
	 ^ origins
]
