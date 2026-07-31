Extension { #name : 'GtSourceCoderEditorElement' }

{ #category : '*Tactical-Fixes' }
GtSourceCoderEditorElement >> onViewModelEvaluationStatusChanged: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new
				action: [ anAnnouncement evaluationStatus
						handleStatusChangedAnnouncement: anAnnouncement
						sourceCoderElement: self.
					self requestManualStyling ])
]
