Class {
	#name : 'GtGitAddRepositoryStencilExamples',
	#superclass : 'Object',
	#category : 'Tactical-WIP-wip',
	#package : 'Tactical-WIP',
	#tag : 'wip'
}

{ #category : 'examples' }
GtGitAddRepositoryStencilExamples >> assertCollection: aCollection hasSameElements: aSet [
	| set |
	set := aCollection as: Set.
	self
		assert: set = aSet
		description: 'Expected ', aSet printString , ' but got ' , set printString
]

{ #category : 'examples' }
GtGitAddRepositoryStencilExamples >> buildNullJob: aTitle [
	| job |
	job := GtJob new.
	job title: aTitle.
	job block: [ :j | j title: aTitle ].
	^ job
]

{ #category : 'examples' }
GtGitAddRepositoryStencilExamples >> collectGitRepositoriesUnderExample [
	<gtExample>
	<return: #OrderedCollection>
	| stencil base found registeredNames |
	base := self loadAllRepositoriesFromDirectoryFixture.
	stencil := GtGitAddRepositoryStencil new.
	found := stencil
		collectGitRepositoriesUnder: base
		asJob: (self buildNullJob: 'collect-test').
	registeredNames := found collect: [ :f | f basename ] as: Set.
	self
		assert: (registeredNames = #('alphaRepo' 'betaRepo' 'gammaRepo') asSet)
		description: 'Expected the three repos; got ' , registeredNames printString.
	^ found
]

{ #category : 'examples' }
GtGitAddRepositoryStencilExamples >> initBareRepoAt: aDirectory [
	"Initialize a git repository at `aDirectory` so that `IceRepositoryCreator isGitRoot:` recognizes it during the walk. We use `LGitRepository on: aDirectory` directly and explicitly call `init` so a `.git/config` is produced on disk; we then close the handle so it does not leak."

	| libgitRepo |
	aDirectory ensureCreateDirectory.
	(aDirectory / '.git') exists ifTrue: [ (aDirectory / '.git') deleteAll ].
	libgitRepo := (LGitRepository on: aDirectory) init.
	libgitRepo free.
	^ aDirectory
]

{ #category : 'examples' }
GtGitAddRepositoryStencilExamples >> loadAllRepositoriesFromDirectoryExample [
	<gtExample>
	<return: #String>
	| stencil base found job summary newlyRegistered fixtureSuffixes |
	base := self loadAllRepositoriesFromDirectoryFixture.
	stencil := GtGitAddRepositoryStencil new.
	job := GtJob block: [ :j | j title: 'register-test' ].
	found := stencil
		collectGitRepositoriesUnder: base
		asJob: job.
	self assert: found size > 0 description: 'Expected fixture to contain at least one git repository'.
	summary := stencil
		loadRepositories: found
		ofClass: IceRepository repositoryClass
		asJob: job.
	self assert: (summary beginsWith: 'Registered ').
	fixtureSuffixes := #('alphaRepo' 'betaRepo' 'gammaRepo').
	newlyRegistered := IceRepository registry
		select: [ :r | 
			r location notNil
				and: [ fixtureSuffixes anySatisfy: [ :suffix | r location asString endsWith: suffix ] ] ].
	self
		assert: newlyRegistered isNotEmpty
		description: 'Expected at least one newly registered repo from the fixture; got summary: ' , summary.
	^ summary
]

{ #category : 'examples' }
GtGitAddRepositoryStencilExamples >> loadAllRepositoriesFromDirectoryFixture [
	<gtExample>
	<noTest>
	<return: #FileReference>
	| base alphaDir betaDir notARepoDir gammaDir |
	(FileLocator temp / 'gt4git-bulk-load-example') exists
		ifTrue: [ (FileLocator temp / 'gt4git-bulk-load-example') deleteAll ].
	base := FileLocator temp / 'gt4git-bulk-load-example'.
	base ensureCreateDirectory.

	alphaDir := base / 'alphaRepo'.
	alphaDir ensureCreateDirectory.
	self initBareRepoAt: alphaDir.

	betaDir := base / 'betaRepo'.
	betaDir ensureCreateDirectory.
	self initBareRepoAt: betaDir.

	notARepoDir := base / 'notARepo'.
	notARepoDir ensureCreateDirectory.

	gammaDir := base / 'gammaRepo'.
	gammaDir ensureCreateDirectory.
	self initBareRepoAt: gammaDir.

	^ base
]

{ #category : 'examples' }
GtGitAddRepositoryStencilExamples >> tidyUpStaleRegistryEntriesExample [
	<gtExample>
	<return: #OrderedCollection>
	| stencil removedNames |
	stencil := GtGitAddRepositoryStencil new.
	self tidyUpStaleRegistryEntriesFixture.
	self
		assert: (IceRepository registry anySatisfy: [ :r | r isMissing ])
		description: 'Expected the fixture to register at least one stale repository'.
	removedNames := stencil tidyUpStaleRegistryEntries.
	self
		assert: removedNames isNotEmpty
		description: 'Expected `tidyUpStaleRegistryEntries` to return at least one removed name'.
	self
		assert: (IceRepository registry anySatisfy: [ :r | r isMissing ]) not
		description: 'After tidy-up there should be no missing repositories left'.
	^ removedNames
]
