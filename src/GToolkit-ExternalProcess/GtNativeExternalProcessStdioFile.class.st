Class {
	#name : #GtNativeExternalProcessStdioFile,
	#superclass : #GtNativeExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'instance creation' }
GtNativeExternalProcessStdioFile class >> fromFileReference: aFileReferenceOrPathString create: shouldCreate append: shouldAppend truncate: shouldTruncate during: aBlock [
	^ self fromNativeHandle: (self
		primFromFileReference: aFileReferenceOrPathString
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
GtNativeExternalProcessStdioFile class >> primFromFileReference: aFileReferenceOrPathString	 create: shouldCreate append: shouldAppend truncate: shouldTruncate [
	^ GtBoxerString
		fromString: aFileReferenceOrPathString asFileReference absolutePath fullName
		during: [ :aBoxerString |
			self
				primCreate: aBoxerString
				create: shouldCreate
				append: shouldAppend
				truncate: shouldTruncate ]
]
