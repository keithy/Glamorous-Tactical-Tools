Extension { #name : 'String' }

{ #category : '*Tactical-Tools-Fixes' }
String >> gtCloneGithubRepository [
	| remote |
	remote := IceGitRemote url: self.
	^ GtGitRepository fromIcebergRepository: (IceRepository repositoryClass creatorClass new
		   remote: remote;
		   location: IceLibgitRepository repositoriesLocation / remote owner / remote projectName;
		   createRepository)
]
