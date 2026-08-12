Class {
	#name : 'TTDictionaryBackedByCli',
	#superclass : 'TTDictionaryBacked',
	#instVars : [
		'epb',
		'readBlock'
	],
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'accessing' }
TTDictionaryBackedByCli class >> asFile: pathString [

	^ TheHub fileReferenceFrom: pathString

	 
]

{ #category : 'accessing' }
TTDictionaryBackedByCli class >> exampleFindGitUrls [
	
	<gtExample>
	
	^ self newFindGitUrls output
]

{ #category : 'accessing' }
TTDictionaryBackedByCli class >> exampleFindSShKeys [
	
	<gtExample>
	
	^ self newFindSShKeys output
]

{ #category : 'accessing' }
TTDictionaryBackedByCli class >> makeEPBbash: dir script: script [

	^ (GtExternalProcessBuilder new)
				command: 'bash';
				arguments: {'-c'. ('cd ', dir,' && ', script).};
				yourself
]

{ #category : 'accessing' }
TTDictionaryBackedByCli class >> newFindGitUrls [

	| cli code|

	cli := 'find . -type d -name ".git" -execdir git remote get-url origin \;'.
	
	code := self asFile:'{code}'.
	
	^ (self new)
			setSource: code;
			setEpb: (self makeEPBbash: code fullName script: cli);
		  yourself
]

{ #category : 'accessing' }
TTDictionaryBackedByCli class >> newFindSShKeys [

	| cli |

	cli := 'find . -name "*.pub"'.
	
	^ (self new)
			setSource: (self asFile:'{home}/.ssh');
			setEpb: (self makeEPBbash: '~/.ssh' script: cli);
		  yourself
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> epb [
	^ epb
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> epb: anObject [
	epb := anObject
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> gtFileReferencePathFor: aView [
	<gtView>
	^ aView forward
		title: 'Project Directory';
		priority: 1;
		object: [ self source asFileReference ];
		view: #gtContentsFor:
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> initialize [
	
		"skip the first initialization"
		
	^ super initialize
	 
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> initializeTwo: topTier [
	
	"now its our turn"
	self readSource.
	
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> output [

	^ epb output
	 
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> readFromStream: aStreamable [
	
		[ aStreamable atEnd ] whileFalse: [ 
		
			self readBlock value: self value: aStreamable nextLine
		
		]
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> readUsing: abBlock [
	readBlock := abBlock
]

{ #category : 'accessing' }
TTDictionaryBackedByCli >> setEpb: anObject [

	"set convention, setEpb required before initialization"
	epb := anObject
]
