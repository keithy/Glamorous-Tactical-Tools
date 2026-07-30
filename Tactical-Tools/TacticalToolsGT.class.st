"
A collection of convenience methods extending Bloc for use within Tactical Tools.

It currently provides:

- `BlElement class>>#newEmpty` to construct an element that takes effectively no space in a layout, suitable as a null/placeholder element when adding `BlElement new` would otherwise reserve unwanted space (for example in list presentations).
"
Class {
	#name : 'TacticalToolsGT',
	#superclass : 'Object',
	#category : 'Tactical-Tools-GT',
	#package : 'Tactical-Tools',
	#tag : 'GT'
}

{ #category : 'examples' }
TacticalToolsGT >> blElementNewEmpty [
	<gtExample>
	<return: #BlElement>
	"Show that `BlElement newEmpty` produces an element that is `BlVisibility gone`
	and therefore does not participate in layout."
	
	| anElement |
	anElement := BlElement newEmpty.
	self assert: anElement visibility equals: BlVisibility gone.
	self assert: anElement measuredExtent equals: 0 @ 0.
	^ anElement
]

{ #category : 'examples' }
TacticalToolsGT >> blElementNewEmpty_inVerticalLayout [
	<gtExample>
	<return: #BlElement>
	"Show that placing `BlElement newEmpty` between two real children in a
	vertical linear layout does not add vertical spacing."

	| container empty red blue |
	container := BlElement new
		layout: (BlLinearLayout vertical cellSpacing: 20);
		padding: (BlInsets left: 10 right: 10);
		size: 400 @ 500.

	red := BlElement new
		background: Color red;
		size: 380 @ 100;
		yourself.

	empty := BlElement newEmpty.

	blue := BlElement new
		background: Color blue;
		size: 380 @ 100;
		yourself.

	container addChildren: {red. empty. blue}.
	container forceLayout.

	self assert: blue position y equals: red position y + 100 + 20.
	self assert: blue extent equals: 380 @ 100.

	^ container
]
