// // lib/features/blog/widgets/featured_blog_card.dart
// import 'package:flutter/material.dart';
// import 'package:isa/features/blog/ui/blog_detail_screen.dart';

// class FeaturedBlogCard extends StatelessWidget {
//   final Map<String, dynamic> blog;

//   const FeaturedBlogCard({super.key, required this.blog});

//   Widget _buildFeaturedImage(String imagePath) {
//     if (imagePath.startsWith('http')) {
//       return Image.network(
//         imagePath,
//         height: 110, // হাইট কিছুটা কমানো হয়েছে ওভারফ্লো এড়াতে
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => const SizedBox(
//           height: 110,
//           child: Center(child: Icon(Icons.broken_image)),
//         ),
//       );
//     } else {
//       return Image.asset(
//         imagePath,
//         height: 110,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => const SizedBox(
//           height: 110,
//           child: Center(child: Icon(Icons.image_not_supported)),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 12),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: blog)),
//             );
//           },
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // কন্টেন্ট অনুযায়ী জায়গা নেবে
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 child: _buildFeaturedImage(blog['image'] ?? ''),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 8,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Featured Badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 6,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Text(
//                         'Featured',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // Title with MaxLines to prevent overflow
//                     Text(
//                       blog['title'] ?? 'No Title',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines:
//                           1, // ১ লাইন করে দিলে সেভ থাকবে, ২ লাইন চাইলে হাইট বাড়াতে হবে
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     // Author Section
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 9,
//                           backgroundColor: Colors.grey[200],
//                           backgroundImage:
//                               (blog['authorImage'] != null &&
//                                   blog['authorImage'].startsWith('http'))
//                               ? NetworkImage(blog['authorImage'])
//                               : null,
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             blog['author'] ?? 'Unknown',
//                             style: const TextStyle(
//                               fontSize: 11,
//                               color: Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
