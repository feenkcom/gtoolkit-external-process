Class {
	#name : #GtExternalProcessFileStdio,
	#superclass : #GtExternalProcessStdio,
	#instVars : [
		'fileReference',
		'append',
		'truncate',
		'create'
	],
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #accessing }
GtExternalProcessFileStdio >> append [

	^ append
]

{ #category : #accessing }
GtExternalProcessFileStdio >> append: anObject [

	append := anObject
]

{ #category : #converting }
GtExternalProcessFileStdio >> asNativeStdioIn: aWorkingDirectory during: aBlock [
	| aResolvedFileReference |
	
	aResolvedFileReference := self fileReference isAbsolute
		ifTrue: [ self fileReference ]
		ifFalse: [ (aWorkingDirectory resolveReference: self fileReference) asAbsolute  ].

	^ GtNativeExternalProcessStdioFile
		fromFileReference: aResolvedFileReference
		create: create
		append: append
		truncate: truncate
		during: aBlock
]

{ #category : #accessing }
GtExternalProcessFileStdio >> create [

	^ create
]

{ #category : #accessing }
GtExternalProcessFileStdio >> create: anObject [

	create := anObject
]

{ #category : #accessing }
GtExternalProcessFileStdio >> fileReference [
	^ fileReference
]

{ #category : #accessing }
GtExternalProcessFileStdio >> fileReference: anObject [
	fileReference := anObject asFileReference
]

{ #category : #initialization }
GtExternalProcessFileStdio >> initialize [
	super initialize.
	
	create := true.
	truncate := true.
	append := true
]

{ #category : #accessing }
GtExternalProcessFileStdio >> truncate [

	^ truncate
]

{ #category : #accessing }
GtExternalProcessFileStdio >> truncate: anObject [

	truncate := anObject
]
