Class {
	#name : 'TTTimeZoneDB',
	#superclass : 'TTWorldClockClient',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> fileOpenApiSpec [

  "TimeZoneDB - OpenApi Spec (example)"
  
	<ttSpoke>
	
	"AI created this one"
	
	^ (#url://'file:///Users/keith/code/GlamorousToolkit-MacOS-x86_64-v1.1.554/pharo-local/iceberg/keithy/Glamorous-Tactical-Tools/fixtures/TimeZoneDB.openapi.json')  asString


]

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> urlDownloadDbCsv [

	<ttSpoke>
	
^ 'https://timezonedb.com/files/TimeZoneDB.csv.zip'

]

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> urlDownloadDbSql [

	<ttSpoke>

 ^ 'https://timezonedb.com/files/TimeZoneDB.sql.zip'
 
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> urlHostApi [

	<ttSpoke>

 ^ 'https://api.timezonedb.com'
 
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> minDelay [
	^ 1
]
