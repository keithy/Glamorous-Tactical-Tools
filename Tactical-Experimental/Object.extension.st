Extension { #name : 'Object' }

{ #category : '*Tactical-Experimental' }
Object >> gtRawFor: aView [
	<gtView>
	^ (#class:// #TTRawTreeView)  new
				root: self;
				theme: self ttTheme;
				setView: aView;
				asRawView
]

{ #category : '*Tactical-Experimental' }
Object >> ttTheme [
	  <ttTheme>
	  ^ (#env://'USER' = 'tudor') ifTrue: [ TTInspectorOriginalTheme ] ifFalse: [ TTInspectorTacticalTheme ]
]
