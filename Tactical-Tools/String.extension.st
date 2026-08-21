Extension { #name : 'String' }

{ #category : '*Tactical-Tools' }
String >> gtCloneGithubRepository [

	<ttFix:'was misparsing organisation as https'>
	
	| remote |
	remote := IceGitRemote url: self.
	^ GtGitRepository fromIcebergRepository: (IceRepository repositoryClass creatorClass new
		   remote: remote;
		   location: IceLibgitRepository repositoriesLocation / remote owner / remote projectName;
		   createRepository)
]
