import 'package:flutter/material.dart';

void main() => runApp(const NexoraApp());

const brand = Color(0xFF7657F6);

class NexoraApp extends StatefulWidget {
  const NexoraApp({super.key});
  @override
  State<NexoraApp> createState() => _NexoraAppState();
}

class _NexoraAppState extends State<NexoraApp> {
  bool dark = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXORA',
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: brand),
        scaffoldBackgroundColor: const Color(0xFFF7F5FF),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: brand, brightness: Brightness.dark),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: NexoraHome(
          dark: dark,
          onThemeChanged: (v) => setState(() => dark = v),
        ),
      ),
    );
  }
}

class NexoraHome extends StatefulWidget {
  const NexoraHome({super.key, required this.dark, required this.onThemeChanged});
  final bool dark;
  final ValueChanged<bool> onThemeChanged;
  @override
  State<NexoraHome> createState() => _NexoraHomeState();
}

class _NexoraHomeState extends State<NexoraHome> {
  int index = 0;
  final liked = <int>{};
  final followed = <String>{};
  final pages = const ['المقاطع', 'موقعي', 'التحدي', 'الأصدقاء', 'حسابي'];

  void toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final views = [
      _videos(),
      _location(),
      _challenge(),
      _friends(),
      _profile(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(colors: [Color(0xFFA18AFF), brand]),
            ),
            child: const Center(child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
          ),
          const SizedBox(width: 10),
          const Text('NEXORA', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        ]),
        actions: [
          IconButton(
            tooltip: 'تغيير المظهر',
            onPressed: () => widget.onThemeChanged(!widget.dark),
            icon: Icon(widget.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
        ],
      ),
      body: SafeArea(child: IndexedStack(index: index, children: views)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.smart_display_outlined), selectedIcon: Icon(Icons.smart_display), label: 'مقاطع'),
          NavigationDestination(icon: Icon(Icons.location_on_outlined), selectedIcon: Icon(Icons.location_on), label: 'موقعي'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: 'التحدي'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'الأصدقاء'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }

  Widget _videos() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('اكتشف المقاطع', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Text('لحظات وأفكار من مجتمع نيكسورا', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 14),
      Wrap(spacing: 8, children: ['الكل', 'سبوتلايت', 'ريلز'].map((e) => ActionChip(label: Text(e), onPressed: () => toast('فلتر: $e'))).toList()),
      const SizedBox(height: 12),
      _videoCard(1, 'ليلى', 'يوم جميل يستحق أن نتذكره ✨', Icons.wb_sunny_outlined, const Color(0xFF8D70F7)),
      _videoCard(2, 'آدم', 'تحدي اليوم: جرّب شيئاً جديداً 🏆', Icons.emoji_events_outlined, const Color(0xFFDF7FA9)),
      OutlinedButton.icon(onPressed: () => toast('رفع الفيديو يحتاج إلى ربط الخادم'), icon: const Icon(Icons.add), label: const Text('إضافة مقطع')),
    ],
  );

  Widget _videoCard(int id, String name, String description, IconData art, Color color) {
    final isLiked = liked.contains(id);
    final isFollowed = followed.contains(name);
    return Container(
      height: 360,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, const Color(0xFF251B42)]),
      ),
      child: Stack(children: [
        Positioned(right: 24, top: 30, child: Icon(art, size: 110, color: Colors.white.withValues(alpha: .35))),
        Positioned(left: 20, top: 18, child: Chip(label: const Text('سبوتلايت'))),
        Positioned(right: 18, left: 18, bottom: 18, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 8),
            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 7),
            const Icon(Icons.verified, color: Color(0xFF79B5FF), size: 18),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() { isFollowed ? followed.remove(name) : followed.add(name); }),
              child: Text(isFollowed ? 'أتابعه ✓' : 'متابعة', style: const TextStyle(color: Colors.white)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          Row(children: [
            IconButton(onPressed: () => setState(() { isLiked ? liked.remove(id) : liked.add(id); }), icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.pinkAccent : Colors.white)),
            Text(isLiked ? '1' : '0', style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 15),
            IconButton(onPressed: () => toast('المشاركة ستُفعّل في النسخة المتصلة'), icon: const Icon(Icons.share_outlined, color: Colors.white)),
          ]),
        ])),
      ]),
    );
  }

  Widget _location() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('مشاركة الموقع', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const Text('تحكّم في مشاركة موقعك مع الأشخاص الذين تثق بهم.'),
    const SizedBox(height: 16),
    Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
      const Icon(Icons.location_on, size: 50, color: brand),
      const Text('شارك موقعي الآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      const Text('في النسخة التجريبية، لا يتم إرسال موقعك إلى أي خادم.'),
      const SizedBox(height: 12),
      FilledButton(onPressed: () => toast('يتطلب تحديد الموقع إعداد صلاحيات الجهاز والخادم'), child: const Text('تفعيل مشاركة الموقع')),
      const SizedBox(height: 8),
      OutlinedButton(onPressed: () => toast('تم إيقاف المشاركة التجريبية'), child: const Text('إيقاف المشاركة')),
    ]))),
    const ListTile(leading: Icon(Icons.shield_outlined), title: Text('الخصوصية أولاً'), subtitle: Text('أضف صلاحيات الموقع وتحديد المدة قبل الإطلاق الفعلي.')),
  ]);

  Widget _challenge() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('التحدي اليومي', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 16),
    Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      const Icon(Icons.emoji_events, size: 58, color: brand),
      const SizedBox(height: 12),
      const Text('تحدّي اليوم: لحظة امتنان', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('صوّر شيئاً أسعدك اليوم وشاركه مع أصدقائك.'),
      const SizedBox(height: 18),
      const LinearProgressIndicator(value: .25),
      const SizedBox(height: 8),
      const Text('سلسلة الاستمرارية: يوم واحد 🔥'),
      const SizedBox(height: 14),
      FilledButton(onPressed: () => toast('رفع مقطع التحدي يحتاج إلى ربط الخادم'), child: const Text('أنجزت التحدي')),
    ]))),
    const ListTile(leading: Icon(Icons.workspace_premium_outlined), title: Text('Nexora Plus'), subtitle: Text('ثلاثة تحديات يومياً للمشتركين — محاكاة في هذه النسخة.')),
  ]);

  Widget _friends() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('الأصدقاء والدردشة', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث باسم المستخدم', border: OutlineInputBorder()), onSubmitted: (_) => toast('البحث الحقيقي يحتاج إلى قاعدة بيانات')),
    const SizedBox(height: 12),
    for (final person in [('سارة', 'هل رأيت تحدي اليوم؟'), ('يوسف', 'أرسلت لك مقطعاً جديداً'), ('مريم', 'مرحباً 👋')])
      Card(child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(person.$1),
        subtitle: Text(person.$2),
        trailing: IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () => _showChat(person.$1)),
      )),
    OutlinedButton.icon(onPressed: () => toast('طلبات الصداقة ستُربط بالخادم'), icon: const Icon(Icons.person_add_alt_1), label: const Text('طلبات الصداقة')),
  ]);

  void _showChat(String name) {
    final controller = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('محادثة $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const ListTile(leading: Icon(Icons.chat_bubble_outline), title: Text('هذه محادثة تجريبية'), subtitle: Text('لن تُرسل الرسائل إلى مستخدمين حقيقيين بعد.')),
        TextField(controller: controller, decoration: const InputDecoration(hintText: 'اكتب رسالة...', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        FilledButton(onPressed: () { Navigator.pop(ctx); toast('تمت محاكاة إرسال الرسالة'); }, child: const Text('إرسال')),
      ]),
    ));
  }

  Widget _profile() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('حسابي', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 16),
    Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
      const CircleAvatar(radius: 38, backgroundColor: Color(0xFFE7DEFF), child: Icon(Icons.person, size: 42, color: brand)),
      const SizedBox(height: 10),
      const Text('مستخدم نيكسورا', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const Text('@nexora_user', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
        _Stat(number: '0', label: 'المتابِعون'),
        _Stat(number: '0', label: 'أتابعهم'),
        _Stat(number: '0', label: 'إعجاباتي'),
      ]),
    ]))),
    Card(child: SwitchListTile(value: false, onChanged: (_) => toast('إعداد الحساب العام/الخاص يحتاج إلى حفظ على الخادم'), title: const Text('حساب خاص'), subtitle: const Text('التحكم في طلبات المتابعة'))),
    Card(child: ListTile(leading: const Icon(Icons.verified_outlined, color: brand), title: const Text('طلب توثيق الحساب'), subtitle: const Text('شخص • صانع محتوى • علامة تجارية • مطوّر'), onTap: () => toast('نموذج التوثيق سيُربط بالمراجعة الفعلية لاحقاً'))),
    Card(child: ListTile(leading: const Icon(Icons.workspace_premium, color: brand), title: const Text('Nexora Plus'), subtitle: const Text('2 دولار شهرياً • 10 دولارات لستة أشهر • 21 دولاراً سنوياً'), onTap: _showPlus)),
    const Padding(padding: EdgeInsets.all(10), child: Text('ملاحظة: الدفع والتوثيق في هذا النموذج غير حقيقيين. لا تُدخل معلومات دفع حساسة.', style: TextStyle(color: Colors.grey, fontSize: 12))),
  ]);

  void _showPlus() {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.workspace_premium, color: brand, size: 48),
        const Text('Nexora Plus', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const ListTile(leading: Icon(Icons.check_circle_outline), title: Text('موقع تقريبي، 3 تحديات يومياً، مظهر داكن دائم وشارة فضية')),
        const ListTile(title: Text('شهري — 2 دولار')),
        const ListTile(title: Text('6 أشهر — 10 دولارات')),
        const ListTile(title: Text('سنوي — 21 دولاراً')),
        FilledButton(onPressed: () { Navigator.pop(ctx); toast('الاشتراك محاكاة فقط؛ الدفع الحقيقي غير مفعّل'); }, child: const Text('متابعة إلى التأكيد')),
      ]),
    ));
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.number, required this.label});
  final String number;
  final String label;
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(number, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: brand)),
    Text(label, style: const TextStyle(fontSize: 11)),
  ]);
}
