// // lib/features/blog/widgets/blog_card.dart
// import 'package:flutter/material.dart';
// import 'package:isa/features/blog/ui/blog_detail_screen.dart';

// class BlogCard extends StatelessWidget {
//   final Map<String, dynamic> blog;

//   const BlogCard({super.key, required this.blog});

//   // ইমেজ লোড করার জন্য একটি হেল্পার মেথড
//   Widget _buildImage(String imagePath) {
//     if (imagePath.startsWith('http')) {
//       // যদি অনলাইন লিঙ্ক হয়
//       return Image.network(
//         imagePath,
//         height: 150,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => 
//           const Center(child: Icon(Icons.broken_image, size: 50)),
//       );
//     } else {
//       // যদি লোকাল অ্যাসেট হয়
//       return Image.asset(
//         imagePath,
//         height: 150,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => 
//           const Center(child: Icon(Icons.image_not_supported, size: 50)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: blog)),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Blog Image (পরিবর্তিত অংশ)
//               if (blog['image'] != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: _buildImage(blog['image']!),
//                 ),

//               const SizedBox(height: 12),

//               // Title
//               Text(
//                 blog['title'] ?? 'No Title',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),

//               const SizedBox(height: 8),

//               // Author & Date
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 12,
//                     backgroundImage: (blog['authorImage'] != null && blog['authorImage'].startsWith('http'))
//                         ? NetworkImage(blog['authorImage'])
//                         : const AssetImage('assets/images/Quran.png') as ImageProvider,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       '${blog['author']} • ${blog['publishDate']}',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // Stats
//               Row(
//                 children: [
//                   _buildStat(Icons.favorite, '${blog['likes']}'),
//                   const SizedBox(width: 16),
//                   _buildStat(Icons.comment, '${blog['comments']}'),
//                   const SizedBox(width: 16),
//                   _buildStat(Icons.visibility, '${blog['views']}'),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStat(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: Colors.grey),
//         const SizedBox(width: 4),
//         Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }
// }