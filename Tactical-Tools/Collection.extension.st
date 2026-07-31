Extension { #name : 'Collection' }

{ #category : '*Tactical-Tools' }
Collection >> gtViewsInContext: aContext [
	"This collects all views for the current object.
	By default, it simply looks for the #gtView pragma.
	The inspector can decide whether or not a presentation should be displayed.
	Subclasses might want to override it for more special behavior.
	aContext holds the context of the inspection session (i.e, the previous steps)"

	^ (super gtViewsInContext: aContext) , (self ttViewsInCollectionContext: aContext)
]

{ #category : '*Tactical-Tools' }
Collection >> merge: aBlockOrSymbol [ 
	"
		result := server users.
		results := servers merge: #users.
	
	  Similiar to #flatCollect: but returns the same species as the original method.
	  results species == result species. (e.g. merging dictionaries)
	  
		({ server1. server2. } flatCollect: [ :server | server users ]) species == Array
	"
	
	^ self inject: nil into: [ :result :each  | 
			result ifNil: [ (aBlockOrSymbol rsValue: each) copy ]
						  ifNotNil: [ result addAll: (aBlockOrSymbol rsValue: each) ]
		]
]

{ #category : '*Tactical-Tools' }
Collection >> ttViewsInCollectionContext: aContext [

	"Views delegated to the contained object class"

	self isEmpty ifTrue: [  ^ (aContext optionAt: #whenEmpty ifAbsent: #()) value ].

	aContext
		optionAt: #theCollection put: self.
	
	^ (GtPhlowViewsCollector new
		pragmaNames: #(#ttViewInCollection);
		fromObject: ([ self anyOne class ] ifError: [ :ex | nil ]);
		context: aContext) collect
]
