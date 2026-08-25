Class {
	#name : 'TTTimeZoneDB',
	#superclass : 'TTWorldClockClient',
	#category : 'Tactical-Tools-Request-Result',
	#package : 'Tactical-Tools',
	#tag : 'Request-Result'
}

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> fileOpenApiSpec [
  "TimeZoneDB - OpenApi Spec"
	^ #url://'file:///{localDirectory}/iceberg/keithy/Glamorous-Tactical-Tools/fixtures/TimeZoneDB.openapi.json'
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> urlDownloadDbCsv [

	"Timezone database (csv)"
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
TTTimeZoneDB >> apiListTimeZones [

	^ (self vLatest / 'list-time-zone') useGet
						
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> minDelay [
	^ 1
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> urlHostApi [

   ^ 'https://api.timezonedb.com/v2.1/'
]
