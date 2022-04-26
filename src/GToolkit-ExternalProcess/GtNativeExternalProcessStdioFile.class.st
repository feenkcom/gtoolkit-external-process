Class {
	#name : #GtNativeExternalProcessStdioFile,
	#superclass : #GtNativeExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'instance creation' }
GtNativeExternalProcessStdioFile class >> fromFileReference: anAbsoluteFileReference create: shouldCreate append: shouldAppend truncate: shouldTruncate during: aBlock [
	^ self fromNativeHandle: (self
		primFromFileReference: anAbsoluteFileReference
		create: shouldCreate
		append: shouldAppend
		truncate: shouldTruncate)
			during: aBlock
]

{ #category : #'private - ffi' }
GtNativeExternalProcessStdioFile class >> primCreate: aFileNameBoxerString create: shouldCreate append: shouldAppend truncate: shouldTruncate [
	^ self ffiCall: #(void* process_stdio_file(
		GtBoxerString aFileNameBoxerString,
		bool shouldCreate,
		bool shouldAppend,
		bool shouldTruncate))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessStdioFile class >> primFromFileReference: anAbsoluteFileReference create: shouldCreate append: shouldAppend truncate: shouldTruncate [
	self
		assert: [ anAbsoluteFileReference isKindOf: FileReference ]
		description: [ 'Must be a resolved file reference' ].

	anAbsoluteFileReference isAbsolute
		"When using a working directory, the file location must not be ambiguous."
		ifFalse: [ self error: ('File reference must be resolved as absolute, but was {1}' format: { anAbsoluteFileReference }) ].
	
	^ GtBoxerString
		fromString: anAbsoluteFileReference fullName
		during: [ :aBoxerString |
			self
				primCreate: aBoxerString
				create: shouldCreate
				append: shouldAppend
				truncate: shouldTruncate ]
]
