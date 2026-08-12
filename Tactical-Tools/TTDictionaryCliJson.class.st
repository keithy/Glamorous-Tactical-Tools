Class {
	#name : 'TTDictionaryCliJson',
	#superclass : 'TTDictionaryBackedByCli',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryCliJson class >> newMiseEnPlace: projectDirectory [

	| cli |

	cli := '~/.local/bin/mise env --json-extended'.
	
	^ (self new)
			setSource: projectDirectory;
			setEpb: self makeEPBbash: projectDirectory script: cli 
		  yourself

]
