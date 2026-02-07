// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:isa/core/providers/feature_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../provider/quran_provider.dart';
import '../widget/quran_ayah_tile.dart';

class QuranReadScreen extends StatefulWidget {
  const QuranReadScreen({super.key});

  @override
  State<QuranReadScreen> createState() => _QuranReadScreenState();
}

class _QuranReadScreenState extends State<QuranReadScreen> {
  double _fontSizeScale = 1.0;
  final ScrollController _scrollController = ScrollController();
  bool _isAutoscrolling = false;

  void _decreaseFontSize() =>
      setState(() => _fontSizeScale > 0.7 ? _fontSizeScale -= 0.1 : null);
  void _increaseFontSize() =>
      setState(() => _fontSizeScale < 2.5 ? _fontSizeScale += 0.1 : null);

  void _toggleAutoscroll() async {
    setState(() => _isAutoscrolling = !_isAutoscrolling);
    while (_isAutoscrolling) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!_isAutoscrolling || !_scrollController.hasClients) break;
      _scrollController.jumpTo(_scrollController.offset + 1.0);
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        setState(() => _isAutoscrolling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF4F9F4),
      endDrawer: _buildFeatureSideBanner(context),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF141414)],
            ),
          ),
        ),
        title: Consumer<QuranProvider>(
          builder: (context, provider, _) => Text(
            provider.currentSurah['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          _appBarBtn("A-", _decreaseFontSize),
          _appBarBtn("A+", _increaseFontSize),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, _) {
          final surah = provider.currentSurah;
          final ayahs = surah['ayahs'] as List;

          return Column(
            children: [
              _buildCompactDetailCard(provider),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: ayahs.length,
                  itemBuilder: (context, index) {
                    final ayah = ayahs[index];

                    // Logic: Ekhane 'null' hobe na, provider theke value asbe
                    final bool isBookmarked = provider.isAyahBookmarked(
                      surah['name'],
                      ayah['ayahNo'],
                    );

                    // Amra 'Stack' remove kore AyahTile er bhetorei star rakhte pari
                    // Athaba apnar tile er format onujayi eivabe call korun:
                    return AyahTile(
                      ayahNo: ayah['ayahNo'],
                      arabic: ayah['arabic'],
                      translation: ayah['translation'],
                      fontSizeScale: _fontSizeScale,
                      isBookmarked: isBookmarked, // Error fixed here
                      onBookmarkTap: () {
                        provider.toggleBookmark(surah['name'], ayah['ayahNo']);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(scaffoldKey),
    );
  }

  // --- COMPACT DETAIL CARD ---
  Widget _buildCompactDetailCard(QuranProvider provider) {
    final surah = provider.currentSurah;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    surah['nameMeaning'].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Text(
                surah['nameArabic'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Colors.white24, height: 1),
          ),
          Row(
            children: [
              _compactDropdown(
                "SURAH",
                provider.currentIndex,
                List.generate(provider.surahs.length, (i) => i),
                (i) => provider.surahs[i]['name'],
                (val) => provider.changeSurah(val!),
              ),
              const SizedBox(width: 8),
              _badge("JUZ ${surah['juz']}"),
              const SizedBox(width: 8),
              _compactDropdown(
                "AYAH",
                0,
                List.generate(surah['ayahs'].length, (i) => i),
                (i) => "Ayah ${surah['ayahs'][i]['ayahNo']}",
                (val) {
                  _scrollController.animateTo(
                    val! * 160.0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- FEATURE SIDE BANNER ---
  Widget _buildFeatureSideBanner(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "App Features",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Quick Access Menu",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<FeaturesProvider>(
              builder: (context, fProvider, _) {
                if (fProvider.features.isEmpty) {
                  fProvider.loadFeatures();
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: fProvider.features.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final feature = fProvider.features[index];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        feature.icon,
                        color: feature.color,
                        size: 20,
                      ),
                      title: Text(
                        feature.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTTOM BAR ---
  Widget _buildBottomBar(GlobalKey<ScaffoldState> key) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomBtn(Icons.play_circle_fill, 'Play', () {}),
          _bottomBtn(Icons.bookmark_outline, 'Bookmarks', _showBookmarksPanel),
          _bottomBtn(
            _isAutoscrolling ? Icons.pause_circle : Icons.arrow_downward,
            'Scroll',
            _toggleAutoscroll,
          ),
          _bottomBtn(Icons.translate, 'Translation', () {}),
          _bottomBtn(Icons.share, 'Share', () {
            final provider = Provider.of<QuranProvider>(context, listen: false);
            Share.share('Reading Surah ${provider.currentSurah['name']}');
          }),
          _bottomBtn(
            Icons.more_horiz,
            'More',
            () => key.currentState?.openEndDrawer(),
          ),
        ],
      ),
    );
  }

  Widget _bottomBtn(IconData icon, String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: Colors.green[800]),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    ),
  );

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _compactDropdown(
    String label,
    int val,
    List<int> items,
    String Function(int) getName,
    ValueChanged<int?>? onChange,
  ) => Expanded(
    child: Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: val,
          isExpanded: true,
          dropdownColor: const Color(0xFF1B5E20),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 16,
          ),
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    getName(i),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              )
              .toList(),
          onChanged: onChange,
        ),
      ),
    ),
  );

  Widget _appBarBtn(String text, VoidCallback onTap) => TextButton(
    onPressed: onTap,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );

  void _showBookmarksPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Consumer<QuranProvider>(
          builder: (context, provider, _) {
            final bookmarks = provider.allBookmarkedAyahs;

            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6, // Half screen
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Saved Bookmarks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: bookmarks.isEmpty
                        ? const Center(child: Text("No bookmarks found"))
                        : ListView.builder(
                            itemCount: bookmarks.length,
                            itemBuilder: (context, index) {
                              final item = bookmarks[index];
                              final ayah = item['ayah'];
                              final surahName = item['surahName'];

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  "$surahName - Ayah ${ayah['ayahNo']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  ayah['translation'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // ===== REVERSE BUTTON =====
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.undo_rounded,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context); // Panel bondho hobe

                                    // Logic to scroll to that Ayah
                                    provider.goToAyah(
                                      surahName,
                                      ayah['ayahNo'],
                                    );

                                    // Ekhon thik shei Ayat e scroll korar jonno
                                    // Amra index-er opore vitti kore scroll korbo
                                    int ayahIdx = ayah['ayahNo'] - 1;
                                    _scrollController.animateTo(
                                      ayahIdx *
                                          200.0, // Protiti Ayat-er anumanik height
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
