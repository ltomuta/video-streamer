Video Streamer v1.0
===================

The QML Video Streamer example application showcases the QML video streaming
and playback capabilities as well as Qt Mobility bindings to the Multimedia 
package and the QML Video element. The QML Video Streamer application uses the
official Qt Quick Components for navigation and UI.

The application uses a customised QML Video player which has been componentised
so that any developer can use it in his or her own QML application. The video
player component is also used in the QML Media Browser example application
available at: http://github.com/nokia-developer/media-browser


Alternatively, the default platform player can be taken into use in the
application settings.

The application shows Nokia Developer videos that are streamed from the
'nokiadevforum' channel in YouTube using YouTube's mobile APIs.

The QML Video Streamer uses Qt Quick Components in numerous places. For
example, when navigating deeper into the application, the PageStack is used.
The StatusBar and ToolBar (with all the ToolButtons etc.) are used as well.

This example application demonstrates:
- QML video streaming and playing capabilities
- A custom QML video player component
- Using Qt Quick Components in an application that supports multiple
  resolutions and both touch UI and keypad
- Smart startup of the application (content and application UI loaded during
  splash screen (for more information, see the project's wiki pages)
- Handling volume keys of a Symbian phone within the QML code


For more information on the implementation, visit the wiki

<img src="https://raw.github.com/nokia-developer/video-streamer/master/screenshots/Videostreamer_1.png" width="200px"/>
<img src="https://raw.github.com/nokia-developer/video-streamer/master/screenshots/Videostreamer_2.png" width="200px"/>
<img src="https://raw.github.com/nokia-developer/video-streamer/master/screenshots/Videostreamer_3.png" width="200px"/>
<img src="https://raw.github.com/nokia-developer/video-streamer/master/screenshots/Videostreamer_4.png" width="200px"/>
<img src="https://raw.github.com/nokia-developer/video-streamer/master/screenshots/Videostreamer_5.png" width="200px"/>


1. Usage
-------------------------------------------------------------------------------

The customised QML VideoPlayer component can be taken into use in 3rd party
applications simply by adding the VideoPlayer QML sources into the project and
importing it into a QML file. The player itself can be created simply by
instantiating the VideoPlayView and by calling its setVideoData() function.


2. Prerequisites
-------------------------------------------------------------------------------

 - Qt basics
 - Qt Quick basics
 - Qt Quick Components basics


3. Project structure and implementation
-------------------------------------------------------------------------------

3.1 Folders
-----------

 |                   The root folder contains the licence information and
 |                   this file (release notes).
 |
 |- design           Contains UX design files.
 |
 |- screenshots      Contains screenshots taken from the application.
 |
 |- meego            MeeGo platform-specific code files.
 |  |
 |  |- code          Root folder for project, gfx, QML, and Javascript files.
 |  |
 |  |- qtc_packaging Contains the MeeGo 1.2 Harmattan (Debian) packaging files.
 |
 |- symbian          Symbian (Anna/Belle) platform-specific code files.
 |  |
 |  |- code          Root folder for project, gfx, QML, and Javascript files.
 |


3.2 Important files and classes
-------------------------------

| Class                   | Description                                       |
|-------------------------|---------------------------------------------------|
| LoadHelper              | Helper class that is used to load the main QML    |
|                         | file right after showing the splash screen.       |
|-------------------------|---------------------------------------------------|
| PlayerLauncher          | Helper class that can be used to launch the       |
|                         | platform player for streaming.                    |
|-------------------------|---------------------------------------------------|
| VolumeKeys              | Class that implements the MRemConCoreApiTarget-   |
|                         | Observer for reacting to hardware volume buttons. |
|-------------------------|---------------------------------------------------|


3.3 Used APIs/QML elements/Qt Quick Components
----------------------------------------------

The following APIs, QML elements, and Qt Quick Components have been used. 

Qt:
- QDir
- QScopedPointer
- QString
- QTimer

Standard QML elements:
- Connections
- ListView
- Loader
- Text
- TextField
- Timer
- XmlListModel
- XmlRole

- Behavior
- ParallelAnimation
- SequentialAnimation
- State
- Transition

QML elements from Qt Quick Components:
- BusyIndicator
- ListItem
- ProgressBar
- Slider
- ScrollDecorator
- SelectionDialog
- SearchBox (from Qt Quick Components Extras)

QML elements from Qt Mobility:
- DeviceInfo
- Video


4. Compatibility
-------------------------------------------------------------------------------

Compatible with:
 - Symbian devices with Qt 4.7.4 or higher.
 - MeeGo 1.2 Harmattan devices.

Tested on:
 - Nokia E6
 - Nokia E7-00
 - Nokia N9

Developed with:
 - Qt SDK 1.2


4.1 Required capabilities
-------------------------

Without In-App Analytics: None; The application can be self signed on Symbian.
This is the default behaviour for application compilation and sis creation.

With In-App Analytics: ReadDeviceData. The application has to be signed with a
Symbian Signing approved certificate. The In-App Analytics can be taken into
use by enabling the IAA define in the VideoStreamer.pro file.



4.2 Known issues and design limitations
---------------------------------------

- Video streaming might not start on some device & operator combinations. This
might be due to the used video streaming access point. Changing it can help.
In Symbian devices, select
"Menu" - "Settings" - "Application settings" - "Videos" - "Access point in use"
to change the currently used streaming access point.

After video playback there are severe performance bugs.
- https://bugreports.qt.nokia.com/browse/QTMOBILITY-1570 & -1818

The video play view flickers sometimes and may be transparent.
- https://bugreports.qt.nokia.com/browse/QTMOBILITY-1569

Swiping the application to the background on the Nokia N9 while the video is
playing causes the application to crash.
- https://bugreports.qt-project.org/browse/QTMOBILITY-1995

The header item cannot be seen if navigating with the keyboard.
- https://bugreports.qt.nokia.com/browse/QTBUG-20926

Seeking in video is not supported (when using the QML Video Player).
- Seeking is supported in the the 'seekable'-property provided by the QML Video
  element but it was not taken into use in this application because seeking
  did not work seamlessly with streamed content.

Streamed video has a considerably low resolution.
- This is a restriction set by the YouTube mobile API.


5. Building, installing, and running the application
-------------------------------------------------------------------------------

5.1 Preparations
----------------

Check that you have the latest Qt SDK installed in the development environment
and the latest Qt version on the device.

Qt Quick Components 1.1 or higher is required.

5.2 Using the Qt SDK
--------------------

You can install and run the application on the device by using the Qt SDK.
Open the project in the SDK, set up the correct target (depending on the device
platform), and click the Run button. For more details about this approach,
visit the Qt Getting Started section at Nokia Developer
(http://www.developer.nokia.com/Develop/Qt/Getting_started/).

5.3 Symbian device
------------------

Make sure your device is connected to your computer. Locate the .sis
installation file and open it with Nokia Suite. Accept all requests from Nokia
Suite and the device. Note that you can also install the application by copying
the installation file onto your device and opening it with the Symbian File
Manager application.

After the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.

5.4 Nokia N9 and Nokia N950
---------------------------

Copy the application Debian package onto the device. Locate the file with the
device and run it; this will install the application. Note that you can also
use the terminal application and install the application by typing the command
'dpkg -i <package name>.deb' on the command line. To install the application
using the terminal application, make sure you have the right privileges 
to do so (e.g. root access).

Once the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.


6. Licence
-------------------------------------------------------------------------------

See the licence text file delivered with this project. The licence file is also
available online at
https://github.com/nokia-developer/video-streamer/blob/master/Licence.txt


7. Related documentation
-------------------------------------------------------------------------------
Qt Quick Components
- http://doc.qt.nokia.com/qt-components-symbian-1.0/index.html
- http://harmattan-dev.nokia.com/docs/library/html/qt-components/qt-components.html


8. Version history
-------------------------------------------------------------------------------

1.1 Added In-App Analytics / console logging stub implementation for analyzing
    application usage behaviour.
1.0 Published on the Nokia Developer website.
