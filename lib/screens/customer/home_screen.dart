// // Customer home screen
// import 'package:flutter/material.dart';
// import 'package:frontfile_servease/services/auth_service.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = MockAuthService.getUser();
//     final role = MockAuthService.getUserRole();
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F5F0),
//       appBar: AppBar(
//         title: Text('${role[0].toUpperCase()}${role.substring(1)} Dashboard'),
//         backgroundColor: const Color(0xFF2ECC71),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await MockAuthService.logout();
//               Get.offNamed('/login');
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.dashboard, size: 64, color: Color(0xFF2ECC71)),
//             const SizedBox(height: 16),
//             Text(
//               'Welcome, ${user?['name'] ?? 'User'}',
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Dashboard — Phase 3 coming soon',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
