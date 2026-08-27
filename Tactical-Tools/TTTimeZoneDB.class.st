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
	
^ #url://'https://timezonedb.com/files/TimeZoneDB.csv.zip'

]

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> urlDownloadDbSql [

	<ttSpoke>

 ^ #url://'https://timezonedb.com/files/TimeZoneDB.sql.zip'
 
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB class >> urlHost [

	<ttSpoke>

 ^ #url://'https://api.timezonedb.com'
 
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> apiListTimeZones [

	^ (self vLatest / 'list-time-zone') useGET
						
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> initialize [

	super initialize.
	hostUrl := self class urlHost 
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> listTimeZones [

	^ self apiListTimeZones output
						
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> minDelay [
	^ 1
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> urlHostApi [

   ^ 'https://api.timezonedb.com'
]

{ #category : 'as yet unclassified' }
TTTimeZoneDB >> vLatest [

	^ self // self hostUrl / 'v2.1'
]
