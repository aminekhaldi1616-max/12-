import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const V12App());

const gold = Color(0xFFD6AD55);
const bg = Color(0xFF090A0D);
const panel = Color(0xFF17191F);

class V12App extends StatelessWidget {
  const V12App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'V12 Premium', debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: gold, brightness: Brightness.dark),
      useMaterial3: true),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final names = const ['الرئيسية', 'الرياضة', 'الأفلام', 'المسلسلات', 'القنوات'];
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(backgroundColor: bg, title: const Text('V12',
        style: TextStyle(color: gold, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2))),
      body: index == 0 ? const Dashboard() : SectionPage(title: names[index]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF111319), indicatorColor: gold.withOpacity(.18),
        selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), label: 'الرياضة'),
          NavigationDestination(icon: Icon(Icons.movie_outlined), label: 'الأفلام'),
          NavigationDestination(icon: Icon(Icons.video_library_outlined), label: 'المسلسلات'),
          NavigationDestination(icon: Icon(Icons.live_tv_outlined), label: 'القنوات'),
        ]),
    ));
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22), border: Border.all(color: gold.withOpacity(.5)),
      gradient: const LinearGradient(colors: [Color(0xFF44371F), Color(0xFF191A20), Color(0xFF101116)])),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('عالمك في مكان واحد', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 8),
        Text('V12 PREMIUM', style: TextStyle(color: gold, fontSize: 30, fontWeight: FontWeight.w900)),
        SizedBox(height: 8),
        Text('الرياضة • الأفلام • المسلسلات • القنوات'),
      ])),
    const SizedBox(height: 24),
    const Text('استكشف الأقسام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    const Wrap(spacing: 10, runSpacing: 10, children: [
      Tile(icon: Icons.sports_soccer, label: 'الرياضة'),
      Tile(icon: Icons.movie, label: 'الأفلام'),
      Tile(icon: Icons.video_library, label: 'المسلسلات'),
      Tile(icon: Icons.live_tv, label: 'القنوات المباشرة'),
    ]),
    const SizedBox(height: 24),
    const Text('المباريات القادمة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const Info(icon: Icons.sports, title: 'ربط النتائج الرياضية',
      detail: 'سيتم ربط هذا القسم بمصدر رياضي مرخص. لا توجد نتائج مباشرة حالياً.'),
    const SizedBox(height: 20),
    FilledButton.icon(
      style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPage())),
      icon: const Icon(Icons.play_circle_fill), label: const Text('فتح مشغل الفيديو')),
  ]);
}

class Tile extends StatelessWidget {
  final IconData icon; final String label;
  const Tile({super.key, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(width: 155, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: gold.withOpacity(.25))),
    child: Column(children: [Icon(icon, color: gold, size: 30), const SizedBox(height: 8), Text(label)]));
}

class Info extends StatelessWidget {
  final IconData icon; final String title, detail;
  const Info({super.key, required this.icon, required this.title, required this.detail});
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)),
    child: Row(children: [Icon(icon, color: gold, size: 32), const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5), Text(detail, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ]))]));
}

class SectionPage extends StatelessWidget {
  final String title;
  const SectionPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: gold, fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      const Info(icon: Icons.add_circle_outline, title: 'القسم جاهز للتطوير',
        detail: 'سنضيف المحتوى من مصادر رسمية ومرخصة.'),
    ]));
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}
class _PlayerPageState extends State<PlayerPage> {
  final url = TextEditingController();
  VideoPlayerController? player;
  String? error;
  bool loading = false;

  Future<void> play() async {
    final value = url.text.trim();
    if (!(value.startsWith('https://') || value.startsWith('http://'))) {
      setState(() => error = 'أدخل رابط فيديو يبدأ بـ http أو https.'); return;
    }
    setState(() { loading = true; error = null; });
    await player?.dispose();
    final next = VideoPlayerController.networkUrl(Uri.parse(value));
    try {
      await next.initialize(); await next.play();
      if (!mounted) { await next.dispose(); return; }
      setState(() { player = next; loading = false; });
    } catch (_) {
      await next.dispose();
      if (mounted) setState(() { loading = false; error = 'تعذر تشغيل الرابط. تحقق من توافقه وصلاحية استخدامه. '; });
    }
  }

  @override
  void dispose() { url.dispose(); player?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl,
    child: Scaffold(appBar: AppBar(title: const Text('مشغل V12', style: TextStyle(color: gold))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AspectRatio(aspectRatio: 16/9, child: Container(color: Colors.black,
          child: player != null && player!.value.isInitialized
            ? Stack(alignment: Alignment.bottomCenter, children: [
                Center(child: AspectRatio(aspectRatio: player!.value.aspectRatio, child: VideoPlayer(player!))),
                VideoProgressIndicator(player!, allowScrubbing: true,
                  colors: const VideoProgressColors(playedColor: gold)),
                Positioned(right: 4, bottom: 14, child: IconButton(
                  onPressed: () => setState(() => player!.value.isPlaying ? player!.pause() : player!.play()),
                  icon: Icon(player!.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white))),
              ])
            : Center(child: loading ? const CircularProgressIndicator(color: gold)
              : const Icon(Icons.play_circle_outline, color: gold, size: 58)))),
        const SizedBox(height: 18), const Text('رابط الفيديو'),
        TextField(controller: url, keyboardType: TextInputType.url,
          decoration: const InputDecoration(hintText: 'https://example.com/video.mp4')),
        const SizedBox(height: 10),
        FilledButton(onPressed: loading ? null : play,
          style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black),
          child: const Text('تشغيل')),
        if (error != null) Text(error!, style: const TextStyle(color: Colors.orangeAccent)),
        const Text('استخدم روابط الفيديو التي تملكها أو المرخصة لك فقط.',
          style: TextStyle(color: Colors.white54, fontSize: 12)),
      ])));
}
