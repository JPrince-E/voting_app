import 'package:VoteMe/ui/shared/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; // For Realtime Database

import 'package:VoteMe/ui/shared/custom_appbar.dart';
import 'package:VoteMe/ui/shared/spacer.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;

import 'package:VoteMe/utils/app_constants/app_colors.dart';

class FaceVerificationScreen extends StatefulWidget {
  const FaceVerificationScreen({super.key});

  @override
  FaceVerificationScreenState createState() => FaceVerificationScreenState();
}

class FaceVerificationScreenState extends State<FaceVerificationScreen> {
  File? _image;
  String? _referenceImageUrl;
  bool _isVerifying = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchReferenceImageUrl();
  }

  Future<void> _fetchReferenceImageUrl() async {
    await Firebase.initializeApp();

    final databaseRef = FirebaseDatabase.instance.reference().child('users').child(encodeUsername('${GlobalVariables.myUsername}'));
    final snapshot = await databaseRef.once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _referenceImageUrl = data['imageUrl'] as String?;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<File> _resizeImage() async {
    if (_image == null) throw Exception('No image selected.');

    final image = img.decodeImage(_image!.readAsBytesSync());
    if (image == null) throw Exception('Failed to decode image.');

    final resizedImage = img.copyResize(image, width: 800);
    final resizedFile = File('${_image!.path}_resized.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage));

    return resizedFile;
  }

  Future<void> _verifyFace() async {
    if (_image == null || _referenceImageUrl == null) return;

    setState(() {
      _isVerifying = true;
      _statusMessage = '';
    });

    final resizedFile = await _resizeImage();

    // Show the VerifyingScreen while the face verification is taking place
    final isVerified = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyingScreen(
          verifyFace: () async {
            return await _sendFaceVerificationRequest(resizedFile, _referenceImageUrl!);
          },
        ),
      ),
    );

    setState(() {
      _isVerifying = false;
    });

    if (isVerified) {
      context.push('/candidates');
    } else {
      setState(() {
        _statusMessage = 'Face verification failed. Please try again.';
      });
    }
  }

  Future<bool> _sendFaceVerificationRequest(File resizedImage, String referenceImageUrl) async {
    final apiKey = 'E5KnCGhUSlJ_k7wPSVHCxwe2hNNG-WJ1';
    final apiSecret = 'mGWjdOtp6DcWWrbEYLcTayFS72KtDd2r';
    final url = Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['api_key'] = apiKey
        ..fields['api_secret'] = apiSecret
        ..files.add(await http.MultipartFile.fromPath('image_file1', resizedImage.path))
        ..fields['image_url2'] = referenceImageUrl;

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('Response data: $responseData');

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData);
        final confidence = jsonData['confidence'];
        final threshold = jsonData['thresholds']['1e-3'];

        return confidence > threshold;
      } else {
        setState(() {
          _statusMessage = 'Error verifying face. Please try again. Status Code: ${response.statusCode}';
        });
        return false;
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error verifying face. Please try again. Exception: $e';
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: const CustomAppbar(
          title: 'FACE VERIFICATION',
          showBackButton: true,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _image == null
                    ? const Text(
                  'No image selected.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                )
                    : Image.file(_image!),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capture Image'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: AppColors.kPrimaryColor,
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _verifyFace,
                  icon: const Icon(Icons.verified_user),
                  label: const Text('Verify Face'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: AppColors.kPrimaryColor,
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 18,
                    color: _statusMessage.contains('failed') ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String encodeUsername(String username) {
    return username.replaceAll('/', '_');
  }
}

class VerifyingScreen extends StatelessWidget {
  final Future<bool> Function() verifyFace;

  const VerifyingScreen({super.key, required this.verifyFace});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      final isVerified = await verifyFace();
      Navigator.pop(context, isVerified);
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: const CustomAppbar(
          title: 'Verifying Face',
          showBackButton: true,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: AppColors.blueGray,
              backgroundImage: const AssetImage("assets/images/facial-recognition.png"),
              radius: 80,
            ),
            CustomSpacer(20),
            Text(
              'Verifying your face, please wait...',
              style: TextStyle(fontSize: 18, color: AppColors.kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: const CustomAppbar(
          title: 'Voting Screen',
          showBackButton: true,
        ),
      ),
      body: const Center(
        child: Text(
          'Voting Screen Placeholder',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
