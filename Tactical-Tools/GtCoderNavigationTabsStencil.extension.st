Extension { #name : 'GtCoderNavigationTabsStencil' }

{ #category : '*Tactical-Tools' }
GtCoderNavigationTabsStencil >> gtPackagesFavoritesClassesFor: aView [
	<gtCoderNavigation>
	<ttExtension>
	| explicitView |
	self navigationModel ifNil: [ ^ aView empty ].
	explicitView := aView explicit
			title: 'My Packages';
			priority: 2;
			stencil: [ GtCoderNavigationPackagesTagsClassesElement new
					navigationModel: self navigationModel ].
	self addButtonsTo: explicitView.
	^ explicitView
]
