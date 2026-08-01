Extension { #name : 'GtGitAddRepositoryStencil' }

{ #category : '*Tactical-GT' }
GtGitAddRepositoryStencil >> collectGitRepositoriesUnder: rootPath asJob: job [
	"Walk `rootPath` recursively (skipping hidden directories) and answer an
	OrderedCollection of directories that contain a git repository. We defer
	registration to a separate phase so work-in-progress stays responsive.
	`.git` directories themselves are never descended into, since they
	are not user repositories — they are children of a git root we already
	record. We also cycle-protect by tracking the directories we have
	already enqueued and we tolerate per-directory errors so one broken
	location does not abort the whole walk."

	| queue found visited |
	queue := OrderedCollection with: rootPath.
	found := OrderedCollection new.
	visited := Set new.
	[ queue isEmpty ] whileFalse: [ 
		| current |
		current := queue removeFirst.
		(visited includes: current resolve pathString) ifTrue: [ ^ self ].
		visited add: current resolve pathString.
		(current isDirectory
			and: [ current basename ~= '.git'
			and: [ (FileSystemDirectoryEntry reference: current) isHidden not ] ])
			ifTrue: [ 
				| isGitRoot |
				isGitRoot := [ IceRepositoryCreator isGitRoot: current ]
					on: Error do: [ false ].
				isGitRoot
					ifTrue: [ found add: current ]
					ifFalse: [ 
						[ current children
								select: [ :c | c isDirectory ]
								thenDo: [ :c | queue add: c ] ]
							on: Error do: [ :ex | 
								job
									label: 'Skipping ' , current basename , ' (' , ex printString , ')';
									currentValue: visited size ] ] ] ].
	job
		max: found size;
		currentValue: 0.
	job label: 'Found ' , found size asString , ' repositories'.
	^ found
]

{ #category : '*Tactical-GT' }
GtGitAddRepositoryStencil >> initialPage [
	^ BrVerticalPane new fitContent
		addChild: (BrSimpleList new
				itemStencil: [ BrLabel new
						vFitContent;
						hMatchParent;
						aptitude: BrGlamorousLabelAptitude
							+ (BrStyleCommonAptitude new
									hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredListItemColor ]) ];
				itemDataBinder: [ :anItemElement :anItemObject :anItemIndex | 
					anItemElement
						text: anItemObject first;
						id: anItemObject second;
						when: BlClickEvent do: anItemObject third ];
				fitContent;
				padding: (BlInsets all: 3);
				items: {{'Clone a remote repository'.
							#'git-remote'.
							[ self openRemotePage ]}.
						{'Load a local repository'.
							#'git-local'.
							[ self openLocalPage ]}.
						{'Load all repositories from a directory...'.
							#'git-load-all-local'.
							[ self openLoadAllLocalPage ]}.
						{'Create a new repository'.
							#'git-initial'.
							[ self openInitialize ]}})
]

{ #category : '*Tactical-GT' }
GtGitAddRepositoryStencil >> loadAllLocalPage [
	"Answer a BrFileSelector configured to recursively walk the chosen directory,
	registering every existing git repository it finds (skipping locations already
	registered with Iceberg). The work happens inside a GtJob so large directory
	trees do not block the UI."

	| fileBrowser |
	fileBrowser := BrFileSelector new margin: (BlInsets all: 5).
	fileBrowser vExact: 400.
	fileBrowser hExact: 464.

	fileBrowser buttonLabel: 'Load all'.
	fileBrowser buttonId: #'git-load-all-button'.
	fileBrowser
		okAction: [ :rootPath | 
			self
				loadAllRepositoriesFromDirectory: rootPath
				into: IceRepository repositoryClass ].

	fileBrowser
		fileFilterBlock: [ :aFileReference | 
			aFileReference isDirectory
				and: [ (FileSystemDirectoryEntry reference: aFileReference) isHidden not ] ].
	^ fileBrowser
]

{ #category : '*Tactical-GT' }
GtGitAddRepositoryStencil >> loadAllRepositoriesFromDirectory: rootPath into: repositoryClass [
	"Walk `rootPath` recursively and register any subdirectory containing a
	`.git/config` file as an Iceberg repository. Already-registered locations are
	skipped silently. Execution happens inside a GtJob so the picker stays
	responsive; progress is shown via a GtNotificationJob."

	| gtJob |
	gtJob := GtJob
			block: [ :job | 
				| results |
				job
					title: 'Loading repositories';
					label: 'Scanning directory...'.
				results := self
						collectGitRepositoriesUnder: rootPath
						asJob: job.
				self
					loadRepositories: results
					ofClass: repositoryClass
					asJob: job ].
	GtNotificationJob new
		summaryClass: GtSingleJobNotificationSummary;
		job: gtJob;
		registerNotifications.
	^ [ gtJob run ] asAsyncPromise
]

{ #category : '*Tactical-GT' }
GtGitAddRepositoryStencil >> loadRepositories: candidateDirectories ofClass: repositoryClass asJob: job [
	"For each candidate directory, instantiate an Iceberg repository (using
	`repositoryClass` — IceLibgitRepository or IceGitCliRepository — based on
	which one is configured in the image via IceRepository>>#repositoryClass),
	register it (skipping ones already registered at the same location), and
	announce IceRepositoryCreated so the UI updates. Answer a one-line summary of
	the work done."

	| concreteClass registered skipped errors count total iceRepo |
	concreteClass := repositoryClass == IceRepository
		ifTrue: [ IceRepository repositoryClass ]
		ifFalse: [ repositoryClass ].
	registered := OrderedCollection new.
	skipped := OrderedCollection new.
	errors := OrderedCollection new.
	total := candidateDirectories size.
	count := 0.
	candidateDirectories do: [ :directory | 
		count := count + 1.
		job
			label: 'Loading ' , directory basename , ' (' , count asString , '/' , total asString , ')';
			currentValue: count.
		((concreteClass registry anySatisfy: [ :existing | existing location ifNotNil: [ :l | l resolve = directory resolve ] ])
			or: [ registered anySatisfy: [ :r | r location resolve = directory resolve ] ])
			ifTrue: [ skipped add: directory ]
			ifFalse: [ 
				[ 
					iceRepo := concreteClass new.
					iceRepo location: directory.
					iceRepo register.
					registered add: iceRepo ]
					on: Error , IceDuplicatedRepository
					do: [ :ex | errors add: directory -> ex ] ] ].
	^ 'Registered ' , registered size asString , ', skipped ' , skipped size asString 
		, (errors isEmpty ifFalse: [ ', failed ' , errors size asString ] ifTrue: [ '' ])
		, ' (of ' , total asString , ')'
]

{ #category : '*Tactical-GT' }
GtGitAddRepositoryStencil >> openLoadAllLocalPage [

	container removeChildren.
	container addChild: self loadAllLocalPage as: #'git-load-all-local-page'
]

{ #category : '*Tactical-GT' }
GtGitAddRepositoryStencil >> tidyUpStaleRegistryEntries [
	"Drop registry entries whose underlying repository directory is no
	longer available. We don't try to delete the on-disk directory here
	because that requires libgit2 handles to be free of external processes;
	we just unregister from Iceberg so the UI no longer lists a stale
	repository. Already-valid entries are left untouched.

	Answer an OrderedCollection of the repositories we removed so the
	caller can show a summary."

	| stales |
	stales := OrderedCollection new.
	IceRepository registry
		select: [ :r | r isMissing ]
		thenDo: [ :r | 
			[ 
				r forget.
				stales add: r name ]
				on: Error do: [ :ex | 
					stales add: r name , ' (failed: ' , ex printString , ')' ] ].
	^ stales
]
