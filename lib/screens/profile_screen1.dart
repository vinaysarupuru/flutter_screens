// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/router/route_paths.dart';
// import '../../domain/entities/user.dart';
// import '../bloc/auth_bloc.dart';
// import 'change_email_screen.dart';
// import 'change_password_screen.dart';
// import 'delete_account_screen.dart';
// import 'edit_profile_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is AuthenticatedState) {
//           final user = state.user;
//           return _buildProfileScreen(user);
//         } else if (state is AuthLoading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else {
//           return Scaffold(
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('You need to login first'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => context.go(RoutePaths.login),
//                     child: const Text('Go to Login'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget _buildProfileScreen(User user) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditProfileScreen(user: user),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Profile Header with Avatar
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//               ),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.grey.shade200,
//                     backgroundImage:
//                         user.photoUrl != null
//                             ? NetworkImage(user.photoUrl!)
//                             : null,
//                     child:
//                         user.photoUrl == null
//                             ? Text(
//                               _getInitials(user.name),
//                               style: const TextStyle(
//                                 fontSize: 36,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                             : null,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     user.name,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     user.email,
//                     style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                   ),
//                 ],
//               ),
//             ),
//             // Account Settings
//             const Padding(
//               padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Account Settings',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             _buildSettingsItem(
//               icon: Icons.person_outline,
//               title: 'Edit Profile',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EditProfileScreen(user: user),
//                   ),
//                 );
//               },
//             ),
//             _buildSettingsItem(
//               icon: Icons.email_outlined,
//               title: 'Change Email',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ChangeEmailScreen(),
//                   ),
//                 );
//               },
//             ),
//             _buildSettingsItem(
//               icon: Icons.lock_outline,
//               title: 'Change Password',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ChangePasswordScreen(),
//                   ),
//                 );
//               },
//             ),
//             const Divider(),
//             // App Settings
//             const Padding(
//               padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'App Settings',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             _buildSettingsItem(
//               icon: Icons.notifications_outlined,
//               title: 'Notifications',
//               onTap: () {
//                 // Navigate to notifications settings
//               },
//             ),
//             _buildSettingsItem(
//               icon: Icons.brightness_6_outlined,
//               title: 'Theme',
//               onTap: () {
//                 // Show theme selection dialog
//               },
//             ),
//             _buildSettingsItem(
//               icon: Icons.language_outlined,
//               title: 'Language',
//               onTap: () {
//                 // Show language selection dialog
//               },
//             ),
//             const Divider(),
//             // Support & About
//             const Padding(
//               padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Support & About',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             _buildSettingsItem(
//               icon: Icons.help_outline,
//               title: 'Help & Support',
//               onTap: () {
//                 // Navigate to help page
//               },
//             ),
//             _buildSettingsItem(
//               icon: Icons.privacy_tip_outlined,
//               title: 'Privacy Policy',
//               onTap: () {
//                 // Navigate to privacy policy
//               },
//             ),
//             _buildSettingsItem(
//               icon: Icons.description_outlined,
//               title: 'Terms of Service',
//               onTap: () {
//                 // Navigate to terms of service
//               },
//             ),
//             _buildSettingsItem(
//               icon: Icons.info_outline,
//               title: 'About',
//               onTap: () {
//                 // Show about app dialog
//               },
//             ),
//             const Divider(),
//             // Logout & Account Management
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   context.read<AuthBloc>().add(LogoutEvent());
//                 },
//                 icon: const Icon(Icons.logout),
//                 label: const Text('Logout'),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.indigo,
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
//               child: TextButton.icon(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const DeleteAccountScreen(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.delete_outline, color: Colors.red),
//                 label: const Text(
//                   'Delete Account',
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 style: TextButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }

//   String _getInitials(String name) {
//     List<String> nameParts = name.split(' ');
//     String initials = '';

//     if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
//       initials += nameParts[0][0].toUpperCase();
//     }

//     if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
//       initials += nameParts[1][0].toUpperCase();
//     }

//     return initials;
//   }
// }
