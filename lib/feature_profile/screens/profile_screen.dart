import 'package:ayni_flutter_app/shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ayni_flutter_app/feature_profile/models/profile.dart';
import 'package:ayni_flutter_app/feature_profile/services/profile_service.dart';





class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();
  Profile? userProfile;
  bool isLoading = true;
  int currentIndex = 3; // Índice para la pantalla de perfil en la barra de navegación

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      Profile profile = await userService.getUserProfile();
      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching user profile: $e");
    }
  }

  void onNavBarTap(int index) {
    setState(() {
      currentIndex = index;
    });
    // Aquí puedes agregar la lógica para navegar a otras pantallas según el índice
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProfile != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userProfile!.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userProfile!.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Account Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Username'),
                                subtitle: Text(userProfile!.username),
                              ),
                              ListTile(
                                leading: const Icon(Icons.email),
                                title: const Text('Email'),
                                subtitle: Text(userProfile!.email),
                              ),
                              ListTile(
                                leading: const Icon(Icons.verified_user),
                                
                                
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text('Failed to load profile')),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onNavBarTap,
      ),
    );
  }
}