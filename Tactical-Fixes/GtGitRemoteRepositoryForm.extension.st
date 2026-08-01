Extension { #name : 'GtGitRemoteRepositoryForm' }

{ #category : '*Tactical-Fixes' }
GtGitRemoteRepositoryForm >> projectLocation [

	<ttFix>
	
	| remote owner project |
	remote := IceGitRemote url: self url.
	owner := remote owner.
	project := remote projectName.
	^ IceLibgitRepository repositoriesLocation / owner / project
]
