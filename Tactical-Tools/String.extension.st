Extension { #name : 'String' }

{ #category : '*Tactical-Tools' }
String >> fileReferenceFrom: aHub [
	
	"double dispatch"
	^ aHub fileReferenceFromString: self
	
]

{ #category : '*Tactical-Tools' }
String >> gtCloneGithubRepository [

	<ttFix>
	
	| remote |
	remote := IceGitRemote url: self.
	^ GtGitRepository fromIcebergRepository: (IceRepository repositoryClass creatorClass new
		   remote: remote;
		   location: IceLibgitRepository repositoriesLocation / remote owner / remote projectName;
		   createRepository)
]

{ #category : '*Tactical-Tools' }
String >> templateResolveUsing: aVault [

	^ self
]
