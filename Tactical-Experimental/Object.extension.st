Extension { #name : 'Object' }

{ #category : '*Tactical-Experimental' }
Object >> gtRawFor: aView [
	<gtView>
	^ self ttTheme viewRawOn: self for: aView
]

{ #category : '*Tactical-Experimental' }
Object >> ttTheme [
	  <ttTheme>
	  ^ (#env://'USER' = 'tudor') ifTrue: [ TTRawOriginalTheme ] ifFalse: [ TTRawTacticalTheme ]
]
