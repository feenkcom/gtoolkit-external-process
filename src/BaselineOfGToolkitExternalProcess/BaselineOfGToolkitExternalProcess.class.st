Class {
	#name : #BaselineOfGToolkitExternalProcess,
	#superclass : #BaselineOf,
	#classVars : [
		'PostLoaded'
	],
	#category : #BaselineOfGToolkitExternalProcess
}

{ #category : #baseline }
BaselineOfGToolkitExternalProcess >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:v0.8.51/boxer-bindings' ].
		spec
			baseline: 'GToolkitExamplesEngine' with: [
				spec repository: 'github://feenkcom/gtoolkit-examples:v0.8.71/src' ].

		spec package: 'GToolkit-ExternalProcess' with: [
			spec requires: #('GToolkitBoxer' 'GToolkitExamplesEngine') ].
	]
]
