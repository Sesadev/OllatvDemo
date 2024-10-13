
import 'dart:ui';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
 import 'package:ollatv/app/ui/custom_appbar_screen.dart';
 import 'package:ollatv/config/agora.config.dart' as config;
 import 'package:ollatv/app/ui/video_screen/log_sink.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// MultiChannel Example
class JoinChannelVideo extends StatefulWidget {
  /// Construct the [JoinChannelVideo]
  const JoinChannelVideo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> {
  late final RtcEngine _engine;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      openCamera = true,
      muteCamera = false,
      muteAllRemoteVideo = false;
  Set<int> remoteUid = {};
  late TextEditingController _controller;
  bool _isUseFlutterTexture = false;
  bool _isUseAndroidSurfaceView = false;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  bool _isEngineInitialized = false; // Flag to track engine initialization status
  late final RtcEngineEventHandler _rtcEngineEventHandler;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: config.channelId);
    _handlePermissions(); // Request permissions when the screen is loaded
  }

  // Request camera and microphone permissions
  Future<void> _handlePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted) {
      // Permissions granted, initialize Agora engine
      _initEngine();
    } else {
      print("Permissions not granted");
    }
  }

  // Initialize the Agora engine
  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: config.appId));

    _rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        logSink.log('[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        setState(() {
          remoteUid.add(rUid);
        });
      },
      onUserOffline: (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        logSink.log('[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
      onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid,
          RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
        logSink.log(
            '[onRemoteVideoStateChanged] connection: ${connection.toJson()} remoteUid: $remoteUid state: $state reason: $reason elapsed: $elapsed');
      },
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);

    await _engine.enableVideo();
    await _engine.startPreview();

    setState(() {
      _isEngineInitialized = true; // Mark engine as initialized
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    _engine.unregisterEventHandler(_rtcEngineEventHandler);
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: config.token,
      channelId: _controller.text,
      uid: config.uid,
      options: ChannelMediaOptions(
        channelProfile: _channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  // Future<void> _leaveChannel() async {
  //   await _engine.leaveChannel();
  //   setState(() {
  //     openCamera = true;
  //     muteCamera = false;
  //     muteAllRemoteVideo = false;
  //   });
  // }
  // Leave the Agora Channel and stop preview
  Future<void> _leaveChannel() async {
    // Stop the camera preview before leaving the channel
    await _engine.stopPreview(); // Stop the camera preview

    // Leave the Agora channel
    await _engine.leaveChannel();

    // Reset the state after leaving the channel
    setState(() {
      isJoined = false;
      remoteUid.clear(); // Clear any remote UIDs
    });
  }
  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }

  _openCamera() async {
    await _engine.enableLocalVideo(!openCamera);
    // if (openCamera) {
    //   // Turn off the camera (show black screen for remote users)
    //   await _engine.muteLocalVideoStream(true); // Mute the local video stream
    // } else {
    //   // Turn on the camera (resume video)
    //   await _engine.muteLocalVideoStream(false); // Unmute the local video stream
    // }

    setState(() {
      openCamera = !openCamera;
    });
  }

  _muteLocalVideoStream() async {
    await _engine.enableLocalAudio(!muteCamera);
    setState(() {
      muteCamera = !muteCamera;
    });
  }

  _muteAllRemoteVideoStreams() async {
    await _engine.muteAllRemoteVideoStreams(!muteAllRemoteVideo);
    setState(() {
      muteAllRemoteVideo = !muteAllRemoteVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Display loading indicator until the engine is initialized
    if (!_isEngineInitialized) {
      return Scaffold(
        //appBar: AppBar(title: Text("Video Call")),
        appBar: CustomAppBar(title: "Video Call",  showBackButton: true, // Back button will be shown
        ),
        body: Center(child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    // return ExampleActionsWidget(
    //   displayContentBuilder: (context, isLayoutHorizontal) {
    //     return Stack(
    //       children: [
    //         StatsMonitoringWidget(
    //           rtcEngine: _engine,
    //           uid: 0,
    //           child: AgoraVideoView(
    //             controller: VideoViewController(
    //               rtcEngine: _engine,
    //               canvas: const VideoCanvas(uid: 0),
    //               useFlutterTexture: _isUseFlutterTexture,
    //               useAndroidSurfaceView: _isUseAndroidSurfaceView,
    //             ),
    //             onAgoraVideoViewCreated: (viewId) {
    //               _engine.startPreview();
    //             },
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.topLeft,
    //           child: SingleChildScrollView(
    //             scrollDirection: Axis.horizontal,
    //             child: Row(
    //               children: List.of(remoteUid.map(
    //                     (e) => SizedBox(
    //                   width: 200,
    //                   height: 200,
    //                   child: StatsMonitoringWidget(
    //                     rtcEngine: _engine,
    //                     uid: e,
    //                     channelId: _controller.text,
    //                     child: AgoraVideoView(
    //                       controller: VideoViewController.remote(
    //                         rtcEngine: _engine,
    //                         canvas: VideoCanvas(uid: e),
    //                         connection:
    //                         RtcConnection(channelId: _controller.text),
    //                         useFlutterTexture: _isUseFlutterTexture,
    //                         useAndroidSurfaceView: _isUseAndroidSurfaceView,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               )),
    //             ),
    //           ),
    //         )
    //       ],
    //     );
    //   },
    //   actionsBuilder: (context, isLayoutHorizontal) {
    //     final channelProfileType = [
    //       ChannelProfileType.channelProfileLiveBroadcasting,
    //       ChannelProfileType.channelProfileCommunication,
    //     ];
    //     final items = channelProfileType
    //         .map((e) => DropdownMenuItem(
    //       child: Text(
    //         e.toString().split('.')[1],
    //       ),
    //       value: e,
    //     ))
    //         .toList();
    //
    //     return Column(
    //
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         // Join or Leave Channel Button
    //         Row(
    //           children: [
    //             Expanded(
    //               flex: 1,
    //               child: ElevatedButton(
    //                 onPressed: isJoined ? _leaveChannel : _joinChannel,
    //                 child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(height: 10),
    //         // Switch Camera Button
    //         if (!kIsWeb &&
    //             (defaultTargetPlatform == TargetPlatform.android ||
    //                 defaultTargetPlatform == TargetPlatform.iOS)) ...[
    //           ElevatedButton(
    //             onPressed: _switchCamera,
    //             child: Text('Switch Camera'),
    //           ),
    //         ],
    //       ],
    //     );
    //   },
    // );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Video Call"),
      //   actions: [
      //     // Switch Camera Icon Button in the AppBar
      //     IconButton(
      //       icon: Icon(Icons.switch_camera),
      //       onPressed: _switchCamera,
      //     ),
      //   ],
      // ),
      appBar: CustomAppBar(
        title: 'Video Call',
        showBackButton: true, // Back button will be shown

        onBackPressed: () async {
          if (isJoined) {
            _showLeaveConfirmationDialog(); // Call confirmation dialog when user clicks "Leave"
          } else {
            Navigator.of(context).pop(); // Simply go back if not joined
          }
        },
        actions: [
          IconButton(
            icon: Icon(Icons.switch_camera,color: Colors.white,),
              onPressed: _switchCamera ,
          ),
        ], // Optional actions, like a switch camera icon
      ),
      body: Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
              useFlutterTexture: _isUseFlutterTexture,
              useAndroidSurfaceView: _isUseAndroidSurfaceView,
            ),
          ),
          if (remoteUid.isNotEmpty)
            Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: remoteUid.map((e) {
                    return SizedBox(
                      width: 120,
                      height: 120,
                      child: AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: e),
                          connection: RtcConnection(channelId: _controller.text),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          // Control buttons for Mute, Camera On/Off
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         // Mute/Unmute Local Video Button
          //         IconButton(
          //           icon: Icon(
          //             muteCamera ? Icons.mic_off : Icons.mic,
          //               color: muteCamera ? Colors.red : Colors.green,
          //           ),
          //           onPressed: _muteLocalVideoStream,
          //         ),
          //         Text('Video ${muteCamera ? 'Muted' : 'Unmuted'}'),
          //
          //         SizedBox(height: 10),
          //
          //         // Camera On/Off Button
          //         IconButton(
          //           icon: Icon(
          //             openCamera ? Icons.videocam : Icons.videocam_off,
          //             color: openCamera ? Colors.green : Colors.red,
          //           ),
          //           onPressed: _openCamera,
          //         ),
          //         Text('Camera ${openCamera ? 'On' : 'Off'}'),
          //       ],
          //     ),
          //   ),
          // ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mute/Unmute Audio Button with Circle Blur
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            muteCamera ? Icons.mic_off : Icons.mic,
                            color: muteCamera ? Colors.red : Colors.green,
                          ),
                          onPressed: _muteLocalVideoStream,
                        ),
                      ),
                    ),
                  ),
                 // const Text('Audio'),

                  SizedBox(height: 10),

                  // Camera On/Off Button with Circle Blur
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            openCamera ? Icons.videocam : Icons.videocam_off,
                            color: openCamera ? Colors.green : Colors.red,
                          ),
                          onPressed: _openCamera,
                        ),
                      ),
                    ),
                  ),
                 // const Text('Camera'),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        // onPressed: isJoined ? _leaveChannel : _joinChannel,
        onPressed: () {
          if (isJoined) {
            _showLeaveConfirmationDialog(); // Call confirmation dialog when user clicks "Leave"
          } else {
            _joinChannel(); // Join channel directly
          }
        },
        label: Text(isJoined ? 'Leave Channel' : 'Join Channel'),
        icon: Icon(isJoined ? Icons.exit_to_app : Icons.add),
      ),
    );
  }

  Future<void> _showLeaveConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must explicitly confirm
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Video Call'),
          content: const Text('Are you sure you want to leave the video call?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Leave'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _leaveChannel();  // Proceed to leave the channel
                Navigator.pop(context);  // Navigate back after leaving
              },
            ),
          ],
        );
      },
    );
  }
}





