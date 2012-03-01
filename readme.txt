JS Corder
	Control the webcam and streaming video from javascript

	author Alex Hoyau
	date 2012
	license GPL

Description

Connects to a streaming server, play a video or stream live or record the webcam or append to the end of an existing video.

See the sample page in bin/jscorder.html to see a very simple example

How To Use

Use the jscorder.swf in a web page, configure it with the parameters of the object tag, and manage it from javascript with the functions
- play 
- pause
- stop
- seek
- record
- live
- append

You are notified of the events related to the streaming and connection via a call to your custom javascript function onJSRecorderEvent.

To do
- center the video?
- change screen size in function of video size / camera resoltion?
- be able to change the file name from JS?