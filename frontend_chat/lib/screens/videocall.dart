import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallScreen extends StatefulWidget {
  final String roomId;

  VideoCallScreen({required this.roomId});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RTCPeerConnection _peerConnection;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _connectSocket();
    _createPeerConnection();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _connectSocket() {
    globalSocket!.on('connect', (_) {
      globalSocket!.emit('join-call', widget.roomId);
    });

    globalSocket!.on('signal', (data) async {
      var description =
          RTCSessionDescription(data['signal']['sdp'], data['signal']['type']);
      await _peerConnection.setRemoteDescription(description);
      if (description.type == 'offer') {
        await _createAnswer();
      }
    });

    globalSocket!.on('user-joined', (userId) {
      _createOffer();
    });
  }

  Future<void> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection.onIceCandidate = (candidate) {
      globalSocket!.emit('signal-call', {
        'to': widget.roomId,
        'from': globalSocket!.id,
        'signal': candidate.toMap(),
      });
    };

    _peerConnection.onTrack = (event) {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    _localRenderer.srcObject = _localStream;

    _localStream!.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream!);
    });
  }

  Future<void> _createOffer() async {
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    globalSocket!.emit('signal-call', {
      'to': widget.roomId,
      'from': globalSocket!.id,
      'signal': offer.toMap(),
    });
  }

  Future<void> _createAnswer() async {
    final answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);

    globalSocket!.emit('signal-call', {
      'to': widget.roomId,
      'from': globalSocket!.id,
      'signal': answer.toMap(),
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(_localRenderer),
          ),
          Expanded(
            child: RTCVideoView(_remoteRenderer),
          ),
        ],
      ),
    );
  }
}
