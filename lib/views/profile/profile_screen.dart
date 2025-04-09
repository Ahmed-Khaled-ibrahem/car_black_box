import 'dart:io';
import 'package:car_black_box/services/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../controller/appCubit/app_cubit.dart';
import '../../services/firebase_auth.dart';
import 'user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileBox = Hive.box<UserProfile>('profileBox');
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final profile = _profileBox.get('profile');
    if (profile != null) {
      _nameController.text = profile.name ;
      if(profile.name == ''){
        _nameController.text = getIt<FirebaseAuthRepo>().currentUser?.displayName ?? '';
      }
       _numberController.text = profile.number;
      _emailController.text = profile.email ;
      if(profile.email == ''){
        _emailController.text = getIt<FirebaseAuthRepo>().currentUser?.email ?? '';
      }
      setState(() {
        _imagePath = profile.imagePath;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final savedImage = File('${appDir.path}/${pickedFile.name}');
      await File(pickedFile.path).copy(savedImage.path);

      setState(() {
        _imagePath = savedImage.path;
      });
    }
  }

  void _saveProfile() {
    final newProfile = UserProfile(
      name: _nameController.text,
      number: _numberController.text,
      email: _emailController.text,
      imagePath: _imagePath ?? '',
    );
    _profileBox.put('profile', newProfile);
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile Saved!')));
    getIt<AppCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  EasyLoading.show(status: 'Signing out...');
                  getIt<FirebaseAuthRepo>().signOut();
                  await Future.delayed(const Duration(seconds: 2));
                  EasyLoading.dismiss();
                  Navigator.pop(context);
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                ),
                child: const Text('Logout')),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 120,
                      backgroundImage: _imagePath != null && _imagePath!.isNotEmpty
                          ? FileImage(File(_imagePath!))
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                      child: _imagePath == null
                          ? const Icon(Icons.camera_alt,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: 'Name', border: OutlineInputBorder())),
                  const SizedBox(height: 20),
                  TextField(
                      controller: _numberController,
                      decoration: const InputDecoration(
                          labelText: 'Number', border: OutlineInputBorder())),
                  const SizedBox(height: 20),
                  TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        enabled: false,
                          labelText: 'Email', border: OutlineInputBorder())),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _saveProfile, child: const Text('Save Profile')),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
