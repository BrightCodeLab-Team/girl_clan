// import 'package:flutter/material.dart';
// import 'package:girl_clan/core/constants/colors.dart';
// import 'package:girl_clan/core/constants/text_style.dart';
// import 'package:girl_clan/ui/chat/chat_deeetail_screen.dart';
// import 'package:girl_clan/ui/chat/chat_view_model.dart';
// import 'package:provider/provider.dart';

// class CreateGroupScreen extends StatefulWidget {
//   const CreateGroupScreen({super.key});

//   @override
//   State<CreateGroupScreen> createState() => _CreateGroupScreenState();
// }

// class _CreateGroupScreenState extends State<CreateGroupScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final List<String> _selectedMembers = [];

//   void _navigateToUserSearch() async {
//     // Implement user selection logic
//     // For now, we'll just add a dummy member
//     setState(() {
//       _selectedMembers.add('dummy_user_id');
//     });
//   }

//   Future<void> _createGroup() async {
//     if (_nameController.text.isEmpty || _selectedMembers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please provide group name and members')),
//       );
//       return;
//     }

//     try {
//       final viewModel = Provider.of<ChatViewModel>(context, listen: false);
//       final groupId = await viewModel.createGroup(
//         name: _nameController.text,
//         memberIds: _selectedMembers,
//       );

//       Navigator.pop(context);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatDetailScreen(groupId: groupId),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to create group: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create New Group'),
//         actions: [
//           IconButton(icon: const Icon(Icons.check), onPressed: _createGroup),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Group Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _navigateToUserSearch,
//               child: const Text('Add Members'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (_selectedMembers.isNotEmpty) ...[
//               Text('Selected Members:', style: style14B),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _selectedMembers.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(
//                         'User ${_selectedMembers[index].substring(0, 6)}',
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(
//                           Icons.remove_circle,
//                           color: Colors.red,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _selectedMembers.removeAt(index);
//                           });
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
