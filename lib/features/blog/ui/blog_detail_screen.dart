// // lib/features/blog/screen/blog_detail_screen.dart
// // ignore_for_file: deprecated_member_use, duplicate_ignore

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/blog_provider.dart';

// class BlogDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> blog;

//   const BlogDetailScreen({super.key, required this.blog});

//   // ইমেজ হ্যান্ডেল করার জন্য হেল্পার মেথড
//   Widget _buildImage(String imagePath) {
//     if (imagePath.startsWith('http')) {
//       return Image.network(
//         imagePath,
//         height: 250,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => const SizedBox(
//           height: 250,
//           child: Icon(Icons.broken_image, size: 50),
//         ),
//       );
//     } else {
//       return Image.asset(
//         imagePath,
//         height: 250,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => const SizedBox(
//           height: 250,
//           child: Icon(Icons.image_not_supported, size: 50),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<BlogProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ব্লগ বিস্তারিত'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () => _shareBlog(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Blog Image (পরিবর্তিত)
//             if (blog['image'] != null) _buildImage(blog['image']!),

//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     blog['title'] ?? 'No Title',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // Author & Date
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.grey[200],
//                         backgroundImage:
//                             (blog['authorImage'] != null &&
//                                 blog['authorImage'].startsWith('http'))
//                             ? NetworkImage(blog['authorImage'])
//                             : null,
//                         child:
//                             (blog['authorImage'] == null ||
//                                 !blog['authorImage'].startsWith('http'))
//                             ? const Icon(Icons.person)
//                             : null,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               blog['author'] ?? 'Unknown Author',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               formatDate(blog['publishDate']),
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Video Placeholder
//                   if (blog['video'] != null) ...[
//                     Container(
//                       height: 200,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.black,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.play_circle_filled,
//                           size: 50,
//                           color: Colors.white.withOpacity(0.8),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],

//                   // Content (Supports any language)
//                   Text(
//                     blog['content'] ?? '',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       height:
//                           1.6, // লাইনের মাঝে গ্যাপ বাড়িয়ে পড়ার সুবিধা করা হয়েছে
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Tags
//                   Wrap(
//                     spacing: 8,
//                     children:
//                         (blog['tags'] as List<dynamic>?)
//                             ?.map(
//                               (tag) => Chip(
//                                 label: Text(tag.toString()),
//                                 // ignore: deprecated_member_use
//                                 backgroundColor: Colors.green.withOpacity(0.1),
//                               ),
//                             )
//                             .toList() ??
//                         [],
//                   ),

//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.favorite, color: Colors.red),
//                             onPressed: () => provider.likeBlog(blog['id']),
//                           ),
//                           Text('${blog['likes']}'),
//                           const SizedBox(width: 20),
//                           IconButton(
//                             icon: const Icon(Icons.comment),
//                             onPressed: () => _showComments(context),
//                           ),
//                           Text('${blog['comments']}'),
//                         ],
//                       ),
//                       Text('${blog['views']}'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _shareBlog(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('শেয়ার অপশনটি শীঘ্রই আসছে...')),
//     );
//   }

//   void _showComments(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           height: 400,
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const Text(
//                 'কমেন্টস',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const Divider(),
//               const Expanded(child: Center(child: Text('কোন কমেন্ট নেই'))),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'কমেন্ট লিখুন...',
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.send),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String formatDate(String? dateString) {
//   if (dateString == null) return 'তারিখ নেই';
//   try {
//     final date = DateTime.parse(dateString);
//     return '${date.day}/${date.month}/${date.year}';
//   } catch (e) {
//     return dateString;
//   }
// }
