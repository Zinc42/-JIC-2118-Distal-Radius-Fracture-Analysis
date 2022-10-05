# Application for Critical Examination of Distal Radius Fractures

A mobile application desiged to automatically analyze x-ray images of the distal radius (wrist).

It is able to take measurements for volar tilt, radial tilt, and radial height for both pre-operation and post-operation x-rays.
Users can import images via the camera for analysis. 

Licensed under the MIT License.

## Release Notes

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

