// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:isa/features/blog/category/blog_category.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../provider/blog_provider.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogProvider(),
      child: const BlogHomePage(),
    );
  }
}

class BlogHomePage extends StatefulWidget {
  const BlogHomePage({super.key});

  @override
  State<BlogHomePage> createState() => _BlogHomePageState();
}

class _BlogHomePageState extends State<BlogHomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BlogProvider>();

    return Scaffold(
      appBar: _isSearching
          ? _buildSearchAppBar(context, provider)
          : _buildNormalAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Suggestions
            if (_isSearching && _searchController.text.isEmpty)
              _buildSearchSuggestions(provider),

            // Blogs List - FULL SCREEN (no horizontal padding)
            if (_isSearching && _searchController.text.isNotEmpty ||
                !_isSearching)
              provider.blogs.isEmpty
                  ? _buildEmptyState(provider)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isSearching && provider.searchQuery.isEmpty)
                          if (_isSearching || provider.searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Text(
                                provider.searchQuery.isNotEmpty
                                    ? 'Search Results for "${provider.searchQuery}"'
                                    : 'Search Blogs',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        // Blogs - NO HORIZONTAL PADDING
                        Column(
                          children: provider.blogs.map((blog) {
                            return _buildBlogCard(blog, context);
                          }).toList(),
                        ),
                      ],
                    ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Normal AppBar - সব icon সহ
  AppBar _buildNormalAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      leading: const Icon(Icons.article_outlined),
      title: const Text(
        'Islamic Blog',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      centerTitle: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C3B2E), Color(0xFF1B5E20), Color(0xFF2E7D32)],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
              Future.delayed(const Duration(milliseconds: 100), () {
                _searchFocusNode.requestFocus();
              });
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _showCreateBlogDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
      ],
    );
  }

  // Search AppBar
  AppBar _buildSearchAppBar(BuildContext context, BlogProvider provider) {
    return AppBar(
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
            provider.searchBlogs('');
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Search blogs, categories...',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          provider.searchBlogs(value);
        },
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C3B2E), Color(0xFF1B5E20), Color(0xFF2E7D32)],
          ),
        ),
      ),
      actions: [
        if (_searchController.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              provider.searchBlogs('');
            },
          ),
      ],
    );
  }

  // Search Suggestions Widget
  Widget _buildSearchSuggestions(BlogProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // Popular Categories Suggestions
          const Text(
            'Popular Categories:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: BlogCategory.values.map((category) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = category.displayName;
                  provider.searchBlogs(category.displayName);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C3B2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF0C3B2E).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        size: 14,
                        color: Color(0xFF0C3B2E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category.displayName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0C3B2E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Popular Tags from blogs
          const Text(
            'Popular Tags:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getPopularTags(provider).map((tag) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = tag;
                  provider.searchBlogs(tag);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tag, size: 12, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '#$tag',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Recent Search Suggestions (if any)
          if (provider.searchQuery.isNotEmpty) ...[
            const Text(
              'Recent Search:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _searchController.text = provider.searchQuery;
                provider.searchBlogs(provider.searchQuery);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      provider.searchQuery,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Search Tips
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Search Tips',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Search by blog title, author name, or content\n• Click on categories to filter\n• Use tags for specific topics\n• Press Enter to search',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get popular tags from blogs
  List<String> _getPopularTags(BlogProvider provider) {
    final allTags = <String>[];

    // Collect all tags from all blogs
    for (final blog in provider.blogs) {
      final tags = blog['tags'] as List<dynamic>?;
      if (tags != null) {
        for (final tag in tags) {
          if (tag is String) {
            allTags.add(tag);
          }
        }
      }
    }

    // Remove duplicates and limit to top 10
    final uniqueTags = allTags.toSet().toList();
    return uniqueTags.length > 10 ? uniqueTags.sublist(0, 10) : uniqueTags;
  }

  // Empty State
  Widget _buildEmptyState(BlogProvider provider) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              provider.searchQuery.isNotEmpty
                  ? 'No results found for "${provider.searchQuery}"'
                  : 'No blogs found',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (provider.searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextButton(
                  onPressed: () {
                    provider.searchBlogs('');
                    _searchController.clear();
                  },
                  child: const Text('Clear Search'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Blog Card Widget - FULL SCREEN WIDTH
  Widget _buildBlogCard(Map<String, dynamic> blog, BuildContext context) {
    final title = blog['title'] as String? ?? 'No Title';
    final content = blog['content'] as String? ?? '';
    final category = blog['category'] as String? ?? 'General';
    final author = blog['author'] as String? ?? 'Unknown';
    final authorImage = blog['authorImage'] as String?;
    final likes = blog['likes'] as int? ?? 0;
    final comments = blog['comments'] as int? ?? 0;
    final isFeatured = blog['isFeatured'] as bool? ?? false;
    final publishDate = blog['publishDate'] as String? ?? '';
    final blogImage = blog['image'] as String?;
    final language = blog['language'] as String? ?? 'en';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blog Main Image - FULL WIDTH
          if (blogImage != null)
            Image.asset(
              blogImage,
              height: 200,
              width: double.infinity, // Full width
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity, // Full width
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Author Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Author info on LEFT
                    Row(
                      children: [
                        // Author Avatar
                        if (authorImage != null)
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(authorImage),
                            onBackgroundImageError: (exception, stackTrace) {},
                          )
                        else
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[200],
                            child: const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              author,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatDate(publishDate),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Category on RIGHT
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C3B2E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryDisplayName(category),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C3B2E),
                        ),
                      ),
                    ),
                  ],
                ),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Content with See More/Less
                _ContentPreview(content: content),
                // Action Buttons and Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Action Buttons
                    Row(
                      children: [
                        // Like Button
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.grey[600],
                                size: 22,
                              ),
                              onPressed: () {
                                Provider.of<BlogProvider>(
                                  context,
                                  listen: false,
                                ).likeBlog(blog['id'] as String);
                              },
                            ),
                            Text(
                              '$likes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        // Comment Button
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.comment_outlined,
                                color: Colors.grey[600],
                                size: 22,
                              ),
                              onPressed: () {
                                Provider.of<BlogProvider>(
                                  context,
                                  listen: false,
                                ).addComment(blog['id'] as String);
                              },
                            ),
                            Text(
                              '$comments',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        // Share Button
                        IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                          onPressed: () {
                            final title =
                                blog['title'] as String? ?? 'Blog Post';
                            final content = blog['content'] as String? ?? '';
                            final author =
                                blog['author'] as String? ?? 'Unknown';

                            String shareText =
                                '$title\n\n$content\n\nBy: $author\n\nShared from Islamic Blog App';

                            Share.share(shareText, subject: title);
                          },
                        ),
                      ],
                    ),

                    // Language Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getLanguageColor(language).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        language.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getLanguageColor(language),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format date
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  // Helper function to get category display name
  String _getCategoryDisplayName(String categoryValue) {
    try {
      final category = BlogCategory.values.firstWhere(
        (c) => c.value == categoryValue,
        orElse: () => BlogCategory.values.first,
      );
      return category.displayName;
    } catch (e) {
      return categoryValue;
    }
  }

  // Helper function to get language color
  Color _getLanguageColor(String language) {
    switch (language) {
      case 'bn':
        return Colors.green;
      case 'ar':
        return Colors.red;
      case 'en':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showCreateBlogDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write a New Blog'),
        content: const Text('This feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Content Preview Widget with See More/Less
class _ContentPreview extends StatefulWidget {
  final String content;

  const _ContentPreview({required this.content});

  @override
  __ContentPreviewState createState() => __ContentPreviewState();
}

class __ContentPreviewState extends State<_ContentPreview> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isLongContent = widget.content.length > 150;
    final previewText = isLongContent
        ? '${widget.content.substring(0, 150)}...'
        : widget.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _expanded ? widget.content : previewText,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
            height: 1.6,
          ),
        ),
        if (isLongContent)
          GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _expanded ? 'Show less' : 'Read more',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0C3B2E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
