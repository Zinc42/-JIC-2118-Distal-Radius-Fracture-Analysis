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

This guide will allow you to run the app and assumes that you want to run it on your iOS device.

### 1. Get the prerequisites

First, you need to have a macOS device to build iOS apps. You should also get an [Apple Developer Account](https://developer.apple.com/account/) for us to use later in the guide. You only need a free account, so there is no need to spend money for a paid one. 

To use the macOS device for building apps, you should have:

- **Terminal**, the standard command line terminal for macOS
  Every mac device should have this pre-installed.
- **Xcode**, an IDE for Apple app development
  To install, you can use one of the links below:
  - [Map App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12) - Recommended Way
  - [Apple Developer Website](https://developer.apple.com/download/all/?q=Xcode)
  
  After installation, you should open the app, and sign in to your developer account if prompted. Otherwise continue through the rest of the guide.

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

### 2. Clone this repo

For this part, you can either clone the repo through the **Terminal**, or download a zip of the files that you must extract on your own.

To clone the repo, you must have a github account, so create one if you haven't already. Afterwards, go in the **Terminal** and find a folder where you want to put the files into. In this folder, you can type in:
  ```bash
  $ git clone https://github.com/Zinc42/-JIC-2118-Distal-Radius-Fracture-Analysis.git
  ```
to get the files. It might show an error if you are not logged in, but it will usually give you instructions to fix the issue. Once it's cloned, you should enter the folder for the next step.

To download the zip file, go to the top of the github page for this repo. Click the green button that opens a dropdown and click the download zip option. Put the files in whatever folder you want, and extract the files into the same folder. For the next step, you must open the **Terminal** and go to this folder to continue.

### 3. Build the app

In this step, you should have the **Terminal** open in the folder that contains all the files in this repository. You should then run the command:
  ```bash
  $ flutter build ios
  ```
to build all the necessary files for it. There will probably be an error that states:
  ```bash
  Error (Xcode): Signing for (Name) requires a development team. Select a development team in the Signing & Capabilities editor.
  ```
To fix this, you should go in your file explorer to the ios folder inside the project. There will be a file called Runner.xcworkspace that has a white icon. You should click on this file to open the app in Xcode. 

Note: If you haven't opened Xcode since you installed it, there may be prompts to sign in and setup parts of the app.

Once Xcode is open, you should also connect the iOS device you will use to install the app. In the top of the window, you should see:

If you connected your device and it can run the app, it should appear in the middle with its name. If not, first replug your device, or you should click on the area of the screenshot where it says **Any iOS Device** to change which device you use. As a last resort, you can use the mac to build as an iPad app.

Once that's done, you should click the run button to the left. Since we haven't fixed the issue yet, there should be a notification that the build failed. It should open a window to the left that shows the errors, but if not, there should be a red x icon in the top right that you can click to take you there.

Once you see the list of errors, you should click on it, and it should automatically take you to the necessary place. If the error looks like:

Then you should look at the **Team**
