# Application for Critical Examination of Distal Radius Fractures

A mobile application desiged to automatically analyze x-ray images of the distal radius (wrist).

It is able to take measurements for volar tilt, radial tilt, and radial height for both pre-operation and post-operation x-rays.
Users can import images via the camera for analysis. 

Licensed under the MIT License.

## Table of Contents
* [Release Notes](#release-notes)
  - [Version 0.4.0](#version-040)
  - [Version 0.3.0](#version-030)
  - [Version 0.2.0](#version-020)
  - [Version 0.1.0](#version-010)
* [Installation Guide](#installation-guide)

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
- Points in the measurement edit screen are too small and are sometimes difficult to drag and drop
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

## Installation Guide

This guide will allow you to run the app, and it assumes that you want to run the app on your iOS device.

### 1. Get the prerequisites

First, you need to have a macOS device to build iOS apps. To use the macOS device for building apps, you should have:

- **Terminal**, the standard command line terminal for macOS
  Every mac device should have this pre-installed.
- **Xcode**, an IDE for Apple app development
  To install, you can use one of the links below:
  - [Map App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12) - Recommended Way
  - [Apple Developer Website](https://developer.apple.com/download/all/?q=Xcode)

Once you have these installed, you should also get the following tools:
- **Xcode Command Line Tools**, a set of standard tools used with Xcode

  This is necessary for Xcode to work with our app.
  To install, you should open the **Terminal** and once it's open, type:
  ```bash
  $ xcode-select --install
  ```
  and follow the instructions. You may need to restart your device.
  
- **Flutter**, the main software that allows our app to run

  Assuming you are on macOS, you can use the install guide linked below:
  - [Flutter Install Guide](https://docs.flutter.dev/get-started/install/macos)
  
  This will require you to use the **Terminal** to input commands. You may also be asked to download other tools like **Android Studio**, but these are used for running the app on other platforms like Android and web. Only install if you want to.

- **Git**, a tool we use to get the code found in this repository

  If you followed the instructions to download **Xcode Command Line Tools**, it should already be installed on your device. To check, you can use the **Terminal** to type:
  ```bash
  $ git
  ```
  and receive a long list of commands you can use.


  
