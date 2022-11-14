# Application for Critical Examination of Distal Radius Fractures

A mobile application desiged to automatically analyze x-ray images of the distal radius (wrist).

It is able to take measurements for volar tilt, radial tilt, and radial height for both pre-operation and post-operation x-rays.
Users can import images via the camera for analysis. 

Licensed under the MIT License.

## Release Notes

### Version 0.4.0

#### New Features

- Added measurement calculations to the results screen
- Added ability to apply changes made in the measurement edit screen
- Added scale input for length when uploading an x-ray image
- Added results export menu
- Added loading screen when exporting results
- Added ability to export result images via text and email
- Added ability to save result images to camera roll

#### Bugfixes

- Fixed angle calculations for radial inclination and volar tilt
- Improved alignment/accuracy of displayed points when editing measurement points.

#### Known Issues

- Terminology used to refer to the types of x-rays are incorrect (Frontal/Side View vs AP/Lateral Projection)
- Displayed acceptable/healthy measurement values are arbitrary fixed values
- Current analysis results are not cleared when exiting the results screen/returning home

### Version 0.3.0

#### New Features

- Added results screen to display x-ray images and measurement values
- Added color-coded measurement value displays on results screen
- Added popup screens to display the identified points and reference lines over each x-ray image
- Implemented an initial measurement edit screen
- Added ability to drag and drop points over x-ray image in the meausurement edit screen

#### Bugfixes

- Fixed some UI sizing issues in the image alignment screen

#### Known Issues

- Measurement values (and their acceptable ranges) are fixed default values
- Changes made in the measurement edit screen are not saved
- Current analysis images/results are not cleared when exiting the results screen/returning home

### Version 0.2.0

#### New Features

- Added analysis menu screen to view and manage images currently uploaded/needed for an analysis
- Added check to prevent analysis from starting with missing images
- Added camera roll functionality
- Added image alignment screen to zoom/pan/rotate images

#### Bugfixes

- Added error message when camera permissions are denied on the device

#### Known Issues

- Some key UI elements are not fixed in place and can end up with incorrect vertical alignment based on sizes of other elements, mainly in the image alignment screen after the image is cropped to a small aspect ratio.

### Version 0.1.0

#### New Features

- Added Application landing page with options for pre-op and post-op analyses
- Added menu to select method of importing an image
- Added camera screen 
- Added camera functionality

#### Bugfixes

- N/A

