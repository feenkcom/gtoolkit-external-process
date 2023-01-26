Trait {
	#name : #TGtExternalProcessLibrary,
	#category : #'GToolkit-ExternalProcess-Library'
}

{ #category : #accessing }
TGtExternalProcessLibrary classSide >> ffiLibrary [
	^ GtExternalProcessLibrary uniqueInstance
]
