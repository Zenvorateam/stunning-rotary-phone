import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color black = Color(0xFF101114);
const Color charcoal = Color(0xFF292B30);
const Color grey = Color(0xFF777B84);
const Color pale = Color(0xFFF5F5F6);
const Color border = Color(0xFFE6E6E8);
const Color white = Colors.white;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  final store = StoreController();
  await store.load();
  runApp(ZenvoraApp(store: store));
}

class ZenvoraApp extends StatelessWidget {
  final StoreController store;
  const ZenvoraApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) => StoreScope(
        store: store,
        child: MaterialApp(
          title: 'Zenvora Mart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: white,
            colorScheme: const ColorScheme.light(
              primary: black,
              onPrimary: white,
              secondary: charcoal,
              onSecondary: white,
              surface: white,
              onSurface: black,
              error: black,
              onError: white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: white,
              foregroundColor: black,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: false,
              titleTextStyle: TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.w900),
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: white,
              indicatorColor: pale,
              labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(color: s.contains(WidgetState.selected) ? black : grey)),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: pale,
              hintStyle: const TextStyle(color: grey, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: black, width: 1.3)),
            ),
            filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
              backgroundColor: black, foregroundColor: white, disabledBackgroundColor: border,
              disabledForegroundColor: grey, minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            )),
            outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
              foregroundColor: black, side: const BorderSide(color: black), minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            )),
            dividerColor: border,
          ),
          home: const SplashScreen(),
        ),
      );
}

class Product {
  final int id;
  final String name, brand, category, description, image, sku;
  final int price, mrp, stock;
  final double rating;
  final IconData icon;
  const Product({required this.id, required this.name, required this.brand, required this.category,
    required this.description, required this.price, required this.mrp, required this.icon,
    this.image = '', this.sku = '', this.stock = 20, this.rating = 4.6});
  int get discount => mrp > price ? ((mrp - price) * 100 / mrp).round() : 0;
}

const List<Product> catalog = [
  Product(id: 101, name: 'Classic Cotton T-Shirt', brand: 'NORTH', category: 'Fashion', description: 'A soft, breathable everyday cotton T-shirt with a clean silhouette and comfortable regular fit.', price: 599, mrp: 899, icon: Icons.checkroom_outlined, sku: 'ZN-NR-101'),
  Product(id: 102, name: 'Minimal Everyday Hoodie', brand: 'NORTH', category: 'Fashion', description: 'A versatile layer with a soft inner finish, clean detailing and an easy everyday fit.', price: 1299, mrp: 1799, icon: Icons.dry_cleaning_outlined, sku: 'ZN-NR-102'),
  Product(id: 103, name: 'Urban Crossbody Bag', brand: 'FORME', category: 'Accessories', description: 'A practical crossbody bag with organised storage and a timeless minimal design.', price: 1199, mrp: 1699, icon: Icons.shopping_bag_outlined, sku: 'ZN-FM-103'),
  Product(id: 104, name: 'Classic Analog Watch', brand: 'FORME', category: 'Accessories', description: 'A refined everyday timepiece with a simple dial and versatile styling.', price: 1499, mrp: 2199, icon: Icons.watch_outlined, sku: 'ZN-FM-104'),
  Product(id: 105, name: 'Slim Everyday Wallet', brand: 'FORME', category: 'Accessories', description: 'A compact wallet designed to keep your everyday essentials organised.', price: 749, mrp: 1099, icon: Icons.account_balance_wallet_outlined, sku: 'ZN-FM-105'),
  Product(id: 106, name: 'Ceramic Table Vase', brand: 'CASA', category: 'Home', description: 'A clean ceramic accent piece that adds a quiet, modern touch to your space.', price: 899, mrp: 1299, icon: Icons.local_florist_outlined, sku: 'ZN-CS-106'),
  Product(id: 107, name: 'Soft Glow Desk Lamp', brand: 'CASA', category: 'Home', description: 'A modern desk lamp for a comfortable reading and working environment.', price: 1299, mrp: 1899, icon: Icons.lightbulb_outline, sku: 'ZN-CS-107'),
  Product(id: 108, name: 'Minimal Cushion Set', brand: 'CASA', category: 'Home', description: 'A soft, neutral cushion set made to complement contemporary interiors.', price: 699, mrp: 999, icon: Icons.weekend_outlined, sku: 'ZN-CS-108'),
  Product(id: 109, name: 'Daily Care Essentials', brand: 'PURE', category: 'Essentials', description: 'Thoughtfully selected everyday personal care essentials for your daily routine.', price: 399, mrp: 599, icon: Icons.spa_outlined, sku: 'ZN-PR-109'),
  Product(id: 110, name: 'Travel Grooming Kit', brand: 'PURE', category: 'Essentials', description: 'A compact grooming kit that keeps your routine simple at home or on the move.', price: 649, mrp: 899, icon: Icons.inventory_2_outlined, sku: 'ZN-PR-110'),
  Product(id: 111, name: 'Insulated Steel Bottle', brand: 'PURE', category: 'Essentials', description: 'A reusable bottle with a clean finish for daily hydration.', price: 549, mrp: 799, icon: Icons.water_drop_outlined, sku: 'ZN-PR-111'),
  Product(id: 112, name: 'Everyday Canvas Tote', brand: 'NORTH', category: 'Fashion', description: 'A lightweight carry-all tote for everyday errands and casual outings.', price: 499, mrp: 749, icon: Icons.shopping_bag_outlined, sku: 'ZN-NR-112'),
];

class StoreController extends ChangeNotifier {
  late SharedPreferences prefs;
  final Map<int, int> cart = {};
  final Set<int> favourites = {};
  final List<Map<String, dynamic>> orders = [];
  String customerName = '';
  String customerEmail = '';
  String phone = '';
  String address = '';
  String pincode = '';
  String city = '';
  String selectedCategory = 'All';
  String selectedBrand = 'All';
  String query = '';
  String sort = 'Featured';

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    final rawCart = prefs.getString('z_cart');
    if (rawCart != null) {
      try { (jsonDecode(rawCart) as Map).forEach((k, v) => cart[int.parse('$k')] = (v as num).toInt()); } catch (_) {}
    }
    final rawFav = prefs.getString('z_favourites');
    if (rawFav != null) {
      try { favourites.addAll((jsonDecode(rawFav) as List).map((e) => (e as num).toInt())); } catch (_) {}
    }
    final rawOrders = prefs.getString('z_orders');
    if (rawOrders != null) {
      try { orders.addAll((jsonDecode(rawOrders) as List).cast<Map<String, dynamic>>()); } catch (_) {}
    }
    customerName = prefs.getString('z_name') ?? '';
    customerEmail = prefs.getString('z_email') ?? '';
    phone = prefs.getString('z_phone') ?? '';
    address = prefs.getString('z_address') ?? '';
    pincode = prefs.getString('z_pin') ?? '';
    city = prefs.getString('z_city') ?? '';
  }
  Future<void> _save() async {
    await prefs.setString('z_cart', jsonEncode(cart.map((k, v) => MapEntry('$k', v))));
    await prefs.setString('z_favourites', jsonEncode(favourites.toList()));
    await prefs.setString('z_orders', jsonEncode(orders));
    await prefs.setString('z_name', customerName); await prefs.setString('z_email', customerEmail);
    await prefs.setString('z_phone', phone); await prefs.setString('z_address', address);
    await prefs.setString('z_pin', pincode); await prefs.setString('z_city', city);
  }
  int get itemCount => cart.values.fold(0, (a, b) => a + b);
  int get subtotal => cart.entries.fold(0, (a, e) => a + (productById(e.key).price * e.value));
  int get shipping => subtotal == 0 || subtotal >= 999 ? 0 : 49;
  int get total => subtotal + shipping;
  Product productById(int id) => catalog.firstWhere((p) => p.id == id, orElse: () => catalog.first);
  List<Product> get filtered {
    var list = catalog.where((p) => (selectedCategory == 'All' || p.category == selectedCategory) &&
      (selectedBrand == 'All' || p.brand == selectedBrand) &&
      ('${p.name} ${p.brand} ${p.category}'.toLowerCase().contains(query.toLowerCase()))).toList();
    if (sort == 'Price: Low to High') list.sort((a,b) => a.price.compareTo(b.price));
    if (sort == 'Price: High to Low') list.sort((a,b) => b.price.compareTo(a.price));
    if (sort == 'Top Rated') list.sort((a,b) => b.rating.compareTo(a.rating));
    return list;
  }
  Future<void> add(int id) async { cart[id] = (cart[id] ?? 0) + 1; await _save(); notifyListeners(); }
  Future<void> remove(int id) async { cart.remove(id); await _save(); notifyListeners(); }
  Future<void> quantity(int id, int q) async { if (q <= 0) { cart.remove(id); } else { cart[id] = q; } await _save(); notifyListeners(); }
  Future<void> toggleFavourite(int id) async { favourites.contains(id) ? favourites.remove(id) : favourites.add(id); await _save(); notifyListeners(); }
  Future<void> saveProfile({required String name, required String email, required String mobile, required String addr, required String pin, required String town}) async {
    customerName = name; customerEmail = email; phone = mobile; address = addr; pincode = pin; city = town; await _save(); notifyListeners();
  }
  Future<void> placeOrder({required String payment}) async {
    final now = DateTime.now();
    orders.insert(0, {'id': 'ZV${now.millisecondsSinceEpoch.toString().substring(6)}', 'date': now.toIso8601String(), 'items': cart.entries.map((e) => {'id': e.key, 'qty': e.value}).toList(), 'total': total, 'payment': payment, 'status': 'Order placed', 'name': customerName, 'phone': phone, 'address': '$address, $city - $pincode'});
    cart.clear(); await _save(); notifyListeners();
  }
}

class StoreScope extends InheritedNotifier<StoreController> {
  const StoreScope({super.key, required StoreController store, required Widget child}) : super(notifier: store, child: child);
  static StoreController of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}

class SplashScreen extends StatefulWidget { const SplashScreen({super.key}); @override State<SplashScreen> createState() => _SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen> {
  @override void initState() { super.initState(); Timer(const Duration(milliseconds: 1600), () { if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell())); }); }
  @override Widget build(BuildContext context) => const Scaffold(backgroundColor: white, body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    _LogoMark(size: 78), SizedBox(height: 18), Text('ZENVORA MART', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: 2.4)), SizedBox(height: 7), Text('Shop better. Live better.', style: TextStyle(color: grey, fontSize: 12, letterSpacing: .4))
  ])));
}

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> {
  int index = 0;
  @override Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final pages = [const HomeScreen(), const CategoriesScreen(), const WishlistScreen(), const CartScreen(), const AccountScreen()];
    return Scaffold(body: SafeArea(child: IndexedStack(index: index, children: pages)), bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: [
      const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
      const NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Categories'),
      const NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Saved'),
      NavigationDestination(icon: Badge(isLabelVisible: store.itemCount > 0, label: Text('${store.itemCount}'), child: const Icon(Icons.shopping_bag_outlined)), selectedIcon: const Icon(Icons.shopping_bag), label: 'Bag'),
      const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
    ]));
  }
}

class HomeScreen extends StatelessWidget { const HomeScreen({super.key});
  @override Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    final products = s.filtered;
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(18, 14, 18, 12), child: Row(children: [const _LogoMark(size: 42), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Zenvora Mart', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: -.7)), Text('Good finds. Better living.', style: TextStyle(color: grey, fontSize: 11))])), IconButton(tooltip: 'Search', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())), icon: const Icon(Icons.search_rounded)), IconButton(tooltip: 'Bag', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())), icon: Badge(isLabelVisible: s.itemCount > 0, label: Text('${s.itemCount}'), child: const Icon(Icons.shopping_bag_outlined)))]))),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: _HeroBanner(onTap: () { s.selectedCategory = 'All'; s.selectedBrand = 'All'; }))),
      SliverToBoxAdapter(child: _SectionHeading(title: 'Shop by category', action: 'View all', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen())))),
      SliverToBoxAdapter(child: SizedBox(height: 104, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 14), children: const [
        _CategoryTile(name: 'Fashion', icon: Icons.checkroom_outlined), _CategoryTile(name: 'Accessories', icon: Icons.watch_outlined), _CategoryTile(name: 'Home', icon: Icons.chair_outlined), _CategoryTile(name: 'Essentials', icon: Icons.spa_outlined),
      ]))),
      SliverToBoxAdapter(child: _SectionHeading(title: 'Current brands', action: 'Clear', onTap: () { s.selectedBrand = 'All'; s.notifyListeners(); })),
      SliverToBoxAdapter(child: SizedBox(height: 90, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 14), children: const [
        _BrandTile(name: 'NORTH', asset: 'assets/brands/north.png'), _BrandTile(name: 'FORME', asset: 'assets/brands/forme.png'), _BrandTile(name: 'CASA', asset: 'assets/brands/casa.png'), _BrandTile(name: 'PURE', asset: 'assets/brands/pure.png'),
      ]))),
      SliverToBoxAdapter(child: _SectionHeading(title: s.selectedBrand == 'All' ? 'Popular products' : '${s.selectedBrand} collection', action: 'Sort', onTap: () => _showSort(context))),
      if (s.selectedBrand != 'All' || s.selectedCategory != 'All') SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(18, 0, 18, 8), child: Align(alignment: Alignment.centerLeft, child: ActionChip(label: const Text('Clear filters'), onPressed: () { s.selectedBrand = 'All'; s.selectedCategory = 'All'; s.notifyListeners(); })))),
      if (products.isEmpty) const SliverToBoxAdapter(child: _EmptyState(title: 'No products found', subtitle: 'Try another category or search term.'))
      else SliverPadding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 24), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((c, i) => ProductCard(product: products[i]), childCount: products.length), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 11, mainAxisSpacing: 12, childAspectRatio: .61))),
    ]);
  }
}

class _HeroBanner extends StatefulWidget { final VoidCallback onTap; const _HeroBanner({required this.onTap}); @override State<_HeroBanner> createState() => _HeroBannerState(); }
class _HeroBannerState extends State<_HeroBanner> { final PageController controller = PageController(); int page = 0; final List<List<String>> slides = const [['THE EVERYDAY EDIT', 'Less noise.\nBetter choices.', 'Discover pieces made for everyday living.'], ['A BETTER WAY TO SHOP', 'Simple finds.\nSmart prices.', 'Explore useful essentials for every part of life.'], ['YOUR STYLE, YOUR SPACE', 'Make it\nyour own.', 'Thoughtful picks from brands you will love.']];
  @override void dispose() { controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Column(children: [Container(height: 190, decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(24)), clipBehavior: Clip.antiAlias, child: PageView.builder(controller: controller, itemCount: slides.length, onPageChanged: (v) => setState(() => page = v), itemBuilder: (c, i) => Padding(padding: const EdgeInsets.all(23), child: Stack(children: [Positioned(right: -14, bottom: -24, child: Icon([Icons.shopping_bag_outlined, Icons.auto_awesome_outlined, Icons.home_outlined][i], size: 150, color: Colors.white.withOpacity(.08))), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(slides[i][0], style: const TextStyle(color: Color(0xFFB9BBC1), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)), const Spacer(), Text(slides[i][1], style: const TextStyle(color: white, fontSize: 28, height: 1.02, fontWeight: FontWeight.w900, letterSpacing: -.8)), const SizedBox(height: 8), Text(slides[i][2], style: const TextStyle(color: Color(0xFFB9BBC1), fontSize: 11)), const SizedBox(height: 12), GestureDetector(onTap: widget.onTap, child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Explore collection', style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w800)), SizedBox(width: 8), Icon(Icons.arrow_forward_rounded, color: white, size: 16)]))])])))), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(slides.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 180), margin: const EdgeInsets.symmetric(horizontal: 3), width: i == page ? 22 : 6, height: 6, decoration: BoxDecoration(color: i == page ? black : const Color(0xFFD1D2D5), borderRadius: BorderRadius.circular(9)))))]);
}

class _SectionHeading extends StatelessWidget { final String title, action; final VoidCallback onTap; const _SectionHeading({required this.title, required this.action, required this.onTap}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(19, 23, 18, 12), child: Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -.4))), TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: grey, fontSize: 12, fontWeight: FontWeight.w700)))])); }

class _CategoryTile extends StatelessWidget { final String name; final IconData icon; const _CategoryTile({required this.name, required this.icon}); @override Widget build(BuildContext context) => GestureDetector(onTap: () { final s = StoreScope.of(context); s.selectedCategory = name; s.selectedBrand = 'All'; s.notifyListeners(); Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen())); }, child: SizedBox(width: 84, child: Column(children: [Container(width: 58, height: 58, decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(19), border: Border.all(color: border)), child: Icon(icon, size: 25, color: black)), const SizedBox(height: 7), Text(name, maxLines: 1, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800))]))); }

class _BrandTile extends StatelessWidget { final String name, asset; const _BrandTile({required this.name, required this.asset}); @override Widget build(BuildContext context) { final s = StoreScope.of(context); final active = s.selectedBrand == name; return GestureDetector(onTap: () { s.selectedBrand = name; s.selectedCategory = 'All'; s.notifyListeners(); }, child: Container(width: 105, margin: const EdgeInsets.symmetric(horizontal: 5), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15), border: Border.all(color: active ? black : border, width: active ? 1.5 : 1)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Expanded(child: Image.asset(asset, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2))))), const SizedBox(height: 4), Text(name, style: const TextStyle(fontSize: 9, color: grey, fontWeight: FontWeight.w800, letterSpacing: 1))]))); } }

class ProductCard extends StatelessWidget { final Product product; const ProductCard({super.key, required this.product}); @override Widget build(BuildContext context) { final s = StoreScope.of(context); final fav = s.favourites.contains(product.id); return Container(decoration: BoxDecoration(color: white, border: Border.all(color: border), borderRadius: BorderRadius.circular(19)), clipBehavior: Clip.antiAlias, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Stack(children: [Positioned.fill(child: Material(color: pale, child: InkWell(onTap: () => _openProduct(context, product), child: Center(child: Icon(product.icon, size: 62, color: const Color(0xFF62656C)))))), if (product.discount > 0) Positioned(left: 9, top: 9, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(20)), child: Text('${product.discount}% OFF', style: const TextStyle(color: white, fontSize: 9, fontWeight: FontWeight.w900)))), Positioned(right: 7, top: 7, child: Material(color: white, shape: const CircleBorder(), child: IconButton(constraints: const BoxConstraints.tightFor(width: 34, height: 34), padding: EdgeInsets.zero, onPressed: () => s.toggleFavourite(product.id), icon: Icon(fav ? Icons.favorite : Icons.favorite_border, size: 17, color: black))))])), Padding(padding: const EdgeInsets.fromLTRB(10, 9, 10, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.brand, style: const TextStyle(color: grey, fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, height: 1.15, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Row(children: [Text('₹${product.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)), const SizedBox(width: 5), Flexible(child: Text('₹${product.mrp}', overflow: TextOverflow.ellipsis, style: const TextStyle(color: grey, fontSize: 10, decoration: TextDecoration.lineThrough)))]), const SizedBox(height: 8), SizedBox(width: double.infinity, height: 34, child: OutlinedButton(onPressed: () => _openProduct(context, product), style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, side: const BorderSide(color: black), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))), child: const Text('Details', style: TextStyle(fontSize: 11))))]))])); } }

void _openProduct(BuildContext context, Product p) => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p)));

class ProductDetailsScreen extends StatelessWidget { final Product product; const ProductDetailsScreen({super.key, required this.product}); @override Widget build(BuildContext context) { final s = StoreScope.of(context); return Scaffold(appBar: AppBar(title: const Text('Product details'), actions: [IconButton(onPressed: () => s.toggleFavourite(product.id), icon: Icon(s.favourites.contains(product.id) ? Icons.favorite : Icons.favorite_border))]), body: Column(children: [Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 20), children: [Container(height: 290, decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(24)), child: Icon(product.icon, size: 112, color: charcoal)), const SizedBox(height: 22), Text(product.brand, style: const TextStyle(color: grey, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.w900)), const SizedBox(height: 7), Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.1)), const SizedBox(height: 13), Row(children: [Text('₹${product.price}', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), const SizedBox(width: 10), Text('₹${product.mrp}', style: const TextStyle(color: grey, decoration: TextDecoration.lineThrough)), const SizedBox(width: 10), if (product.discount > 0) Text('${product.discount}% OFF', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900))]), const SizedBox(height: 12), const Row(children: [Icon(Icons.star_rounded, size: 17), SizedBox(width: 4), Text('4.6', style: TextStyle(fontWeight: FontWeight.w800)), SizedBox(width: 7), Text('Customer rating', style: TextStyle(color: grey, fontSize: 12))]), const SizedBox(height: 22), const Divider(), const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(product.description, style: const TextStyle(color: grey, height: 1.6)), const SizedBox(height: 22), const Text('Product information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)), const SizedBox(height: 10), _InfoRow(label: 'Brand', value: product.brand), _InfoRow(label: 'Category', value: product.category), _InfoRow(label: 'SKU', value: product.sku), _InfoRow(label: 'Availability', value: product.stock > 0 ? 'In stock' : 'Out of stock') ])), Padding(padding: const EdgeInsets.fromLTRB(18, 10, 18, 18), child: SafeArea(top: false, child: Row(children: [Expanded(child: OutlinedButton(onPressed: () => s.toggleFavourite(product.id), child: const Icon(Icons.favorite_border))), const SizedBox(width: 10), Expanded(flex: 3, child: FilledButton(onPressed: product.stock > 0 ? () async { await s.add(product.id); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to bag'))); } : null, child: const Text('Add to bag')))])))])); } }

class _InfoRow extends StatelessWidget { final String label, value; const _InfoRow({required this.label, required this.value}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: grey, fontSize: 13))), Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800))])); }

class CategoriesScreen extends StatelessWidget { const CategoriesScreen({super.key}); static const entries = [('Fashion', Icons.checkroom_outlined), ('Accessories', Icons.watch_outlined), ('Home', Icons.chair_outlined), ('Essentials', Icons.spa_outlined)]; @override Widget build(BuildContext context) { final s = StoreScope.of(context); return Scaffold(appBar: AppBar(title: const Text('Shop by category')), body: GridView.builder(padding: const EdgeInsets.all(16), itemCount: entries.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2), itemBuilder: (c, i) { final e = entries[i]; return InkWell(borderRadius: BorderRadius.circular(20), onTap: () { s.selectedCategory = e.$1; s.selectedBrand = 'All'; s.notifyListeners(); Navigator.pop(context); }, child: Container(decoration: BoxDecoration(color: white, border: Border.all(color: border), borderRadius: BorderRadius.circular(20)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(e.$2, size: 36), const SizedBox(height: 12), Text(e.$1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900))]))); })); } }

class SearchScreen extends StatefulWidget { const SearchScreen({super.key}); @override State<SearchScreen> createState() => _SearchScreenState(); }
class _SearchScreenState extends State<SearchScreen> { final controller = TextEditingController(); @override void dispose() { controller.dispose(); super.dispose(); } @override Widget build(BuildContext context) { final s = StoreScope.of(context); final list = catalog.where((p) => '${p.name} ${p.brand} ${p.category}'.toLowerCase().contains(controller.text.toLowerCase())).toList(); return Scaffold(appBar: AppBar(title: const Text('Search products')), body: Column(children: [Padding(padding: const EdgeInsets.all(16), child: TextField(controller: controller, autofocus: true, onChanged: (v) => setState(() {}), decoration: InputDecoration(hintText: 'Search products, brands, categories', prefixIcon: const Icon(Icons.search), suffixIcon: IconButton(onPressed: () { controller.clear(); setState(() {}); }, icon: const Icon(Icons.close))))), Expanded(child: list.isEmpty ? const _EmptyState(title: 'No matches', subtitle: 'Try a different search.') : ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: list.length, separatorBuilder: (_, __) => const Divider(height: 1), itemBuilder: (c, i) => ListTile(leading: _ProductThumb(product: list[i]), title: Text(list[i].name, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('${list[i].brand} · ₹${list[i].price}'), trailing: const Icon(Icons.chevron_right), onTap: () => _openProduct(context, list[i]))))])); } }

class WishlistScreen extends StatelessWidget { const WishlistScreen({super.key}); @override Widget build(BuildContext context) { final s = StoreScope.of(context); final list = catalog.where((p) => s.favourites.contains(p.id)).toList(); return Scaffold(appBar: AppBar(title: const Text('Saved products')), body: list.isEmpty ? const _EmptyState(title: 'Nothing saved yet', subtitle: 'Tap the heart on a product to save it.') : GridView.builder(padding: const EdgeInsets.all(14), itemCount: list.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 11, mainAxisSpacing: 12, childAspectRatio: .61), itemBuilder: (c, i) => ProductCard(product: list[i]))); } }

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    final entries = s.cart.entries.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Your bag (${s.itemCount})')),
      body: entries.isEmpty
          ? const _EmptyState(
              title: 'Your bag is empty',
              subtitle: 'Explore the collection and add something you love.',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product = s.productById(entries[index].key);
                      final quantity = entries[index].value;

                      return Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Row(
                          children: [
                            _ProductThumb(product: product),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.brand,
                                    style: const TextStyle(
                                      color: grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '₹${product.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      _QtyButton(
                                        icon: Icons.remove,
                                        onTap: () => s.quantity(
                                          product.id,
                                          quantity - 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          '$quantity',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      _QtyButton(
                                        icon: Icons.add,
                                        onTap: () => s.quantity(
                                          product.id,
                                          quantity + 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => s.remove(product.id),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  decoration: const BoxDecoration(
                    color: white,
                    border: Border(top: BorderSide(color: border)),
                  ),
                  child: Column(
                    children: [
                      _PriceRow(label: 'Subtotal', value: '₹${s.subtotal}'),
                      _PriceRow(
                        label: 'Delivery',
                        value: s.shipping == 0 ? 'FREE' : '₹${s.shipping}',
                      ),
                      const Divider(height: 20),
                      _PriceRow(
                        label: 'Total',
                        value: '₹${s.total}',
                        bold: true,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          ),
                          child: const Text('Continue to checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class CheckoutScreen extends StatefulWidget { const CheckoutScreen({super.key}); @override State<CheckoutScreen> createState() => _CheckoutScreenState(); }
class _CheckoutScreenState extends State<CheckoutScreen> { final form = GlobalKey<FormState>(); late final TextEditingController name, email, mobile, addr, pin, town; bool initialized = false; String payment = 'Cash on Delivery'; bool busy = false; @override void didChangeDependencies() { super.didChangeDependencies(); if (!initialized) { final s = StoreScope.of(context); name = TextEditingController(text: s.customerName); email = TextEditingController(text: s.customerEmail); mobile = TextEditingController(text: s.phone); addr = TextEditingController(text: s.address); pin = TextEditingController(text: s.pincode); town = TextEditingController(text: s.city); initialized = true; } } @override void dispose() { for (final c in [name,email,mobile,addr,pin,town]) { c.dispose(); } super.dispose(); }
  @override Widget build(BuildContext context) { final s = StoreScope.of(context); return Scaffold(appBar: AppBar(title: const Text('Checkout')), body: Form(key: form, child: ListView(padding: const EdgeInsets.all(18), children: [const Text('Delivery details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 14), _field(name, 'Full name', Icons.person_outline), _field(mobile, 'Mobile number', Icons.phone_outlined, type: TextInputType.phone, validator: (v) => (v ?? '').length < 10 ? 'Enter a valid mobile number' : null), _field(email, 'Email address (optional)', Icons.email_outlined, type: TextInputType.emailAddress, required: false), _field(addr, 'House / street / area', Icons.location_on_outlined), Row(children: [Expanded(child: _field(pin, 'PIN code', Icons.pin_drop_outlined, type: TextInputType.number)), const SizedBox(width: 10), Expanded(child: _field(town, 'City', Icons.location_city_outlined))]), const SizedBox(height: 16), const Text('Payment method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 8), RadioListTile<String>(contentPadding: EdgeInsets.zero, activeColor: black, value: 'Cash on Delivery', groupValue: payment, onChanged: (v) => setState(() => payment = v!), title: const Text('Cash on Delivery'), subtitle: const Text('Pay when your order arrives')), RadioListTile<String>(contentPadding: EdgeInsets.zero, activeColor: black, value: 'Online payment', groupValue: payment, onChanged: (v) => setState(() => payment = v!), title: const Text('Online payment'), subtitle: const Text('Payment gateway connection required')), const SizedBox(height: 12), Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(15)), child: Column(children: [_PriceRow(label: 'Items total', value: '₹${s.subtotal}'), _PriceRow(label: 'Delivery', value: s.shipping == 0 ? 'FREE' : '₹${s.shipping}'), const Divider(), _PriceRow(label: 'Payable amount', value: '₹${s.total}', bold: true)])), const SizedBox(height: 18), FilledButton(onPressed: busy ? null : () async { if (!form.currentState!.validate()) return; if (payment == 'Online payment') { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Online payment is not connected yet. Choose Cash on Delivery for this demo.'))); return; } setState(() => busy = true); await s.saveProfile(name: name.text.trim(), email: email.text.trim(), mobile: mobile.text.trim(), addr: addr.text.trim(), pin: pin.text.trim(), town: town.text.trim()); await s.placeOrder(payment: payment); if (!mounted) return; setState(() => busy = false); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrderSuccessScreen())); }, child: Text(busy ? 'Placing order...' : 'Place order · ₹${s.total}'))]))); }
  Widget _field(TextEditingController c, String label, IconData icon, {TextInputType? type, bool required = true, String? Function(String?)? validator}) => Padding(padding: const EdgeInsets.only(bottom: 11), child: TextFormField(controller: c, keyboardType: type, validator: validator ?? (v) => required && (v == null || v.trim().isEmpty) ? 'This field is required' : null, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 19))));
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: const BoxDecoration(
                    color: black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: white,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Order placed!',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thank you for shopping with Zenvora Mart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: grey),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    ),
                    child: const Text('Continue shopping'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget { const AccountScreen({super.key}); @override Widget build(BuildContext context) { final s = StoreScope.of(context); return Scaffold(appBar: AppBar(title: const Text('Account')), body: ListView(padding: const EdgeInsets.all(16), children: [Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(21)), child: Row(children: [const CircleAvatar(radius: 27, backgroundColor: white, child: Icon(Icons.person_outline, color: black, size: 29)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s.customerName.isEmpty ? 'Welcome to Zenvora' : s.customerName, style: const TextStyle(color: white, fontSize: 17, fontWeight: FontWeight.w900)), Text(s.customerEmail.isEmpty ? 'Your shopping space' : s.customerEmail, style: const TextStyle(color: Color(0xFFBFC1C7), fontSize: 11))]))])), const SizedBox(height: 16), _AccountTile(icon: Icons.person_outline, title: 'Personal details', subtitle: 'Name, phone and delivery address', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))), _AccountTile(icon: Icons.receipt_long_outlined, title: 'My orders', subtitle: '${s.orders.length} orders', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()))), _AccountTile(icon: Icons.favorite_border, title: 'Saved products', subtitle: '${s.favourites.length} saved items', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()))), _AccountTile(icon: Icons.help_outline, title: 'Help & support', subtitle: 'Contact and frequently asked questions', onTap: () => showAboutDialog(context: context, applicationName: 'Zenvora Mart', applicationVersion: '1.0.0', children: const [Text('For support, contact your Zenvora store administrator.')])) , const SizedBox(height: 20), const Center(child: Text('ZENVORA MART  ·  VERSION 1.0.0', style: TextStyle(color: grey, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w800))) ])); } }

class ProfileScreen extends StatefulWidget { const ProfileScreen({super.key}); @override State<ProfileScreen> createState() => _ProfileScreenState(); }
class _ProfileScreenState extends State<ProfileScreen> { final form = GlobalKey<FormState>(); late TextEditingController n,e,p,a,pin,c; bool initialized = false; @override void didChangeDependencies() { super.didChangeDependencies(); if (!initialized) { final s = StoreScope.of(context); n=TextEditingController(text:s.customerName); e=TextEditingController(text:s.customerEmail); p=TextEditingController(text:s.phone); a=TextEditingController(text:s.address); pin=TextEditingController(text:s.pincode); c=TextEditingController(text:s.city); initialized = true; } } @override void dispose(){for(final x in [n,e,p,a,pin,c]){x.dispose();}super.dispose();} @override Widget build(BuildContext context) { final s=StoreScope.of(context); return Scaffold(appBar:AppBar(title:const Text('Personal details')),body:Form(key:form,child:ListView(padding:const EdgeInsets.all(18),children:[_input(n,'Full name'),_input(e,'Email address'),_input(p,'Mobile number',type:TextInputType.phone),_input(a,'Delivery address'),_input(pin,'PIN code',type:TextInputType.number),_input(c,'City'),const SizedBox(height:8),FilledButton(onPressed:()async{if(!form.currentState!.validate())return;await s.saveProfile(name:n.text,email:e.text,mobile:p.text,addr:a.text,pin:pin.text,town:c.text);if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Details saved')));Navigator.pop(context);}},child:const Text('Save details'))]))); } Widget _input(TextEditingController x,String label,{TextInputType? type})=>Padding(padding:const EdgeInsets.only(bottom:12),child:TextFormField(controller:x,keyboardType:type,decoration:InputDecoration(labelText:label),validator:(v)=>(v??'').trim().isEmpty?'Required':null)); }

class OrdersScreen extends StatelessWidget { const OrdersScreen({super.key}); @override Widget build(BuildContext context) { final s=StoreScope.of(context); return Scaffold(appBar:AppBar(title:const Text('My orders')),body:s.orders.isEmpty?const _EmptyState(title:'No orders yet',subtitle:'Your placed orders will appear here.'):ListView.separated(padding:const EdgeInsets.all(16),itemCount:s.orders.length,separatorBuilder:(_,__)=>const SizedBox(height:10),itemBuilder:(c,i){final o=s.orders[i];final date=DateTime.tryParse('${o['date']}');return Container(padding:const EdgeInsets.all(15),decoration:BoxDecoration(border:Border.all(color:border),borderRadius:BorderRadius.circular(17)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Text('Order #${o['id']}',style:const TextStyle(fontWeight:FontWeight.w900))),Text('₹${o['total']}',style:const TextStyle(fontWeight:FontWeight.w900,fontSize:16))]),const SizedBox(height:6),Text(date==null?'': '${date.day}/${date.month}/${date.year}',style:const TextStyle(color:grey,fontSize:11)),const SizedBox(height:9),Text('${(o['items'] as List).length} product line(s) · ${o['payment']}',style:const TextStyle(fontSize:12)),const SizedBox(height:9),Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),decoration:BoxDecoration(color:pale,borderRadius:BorderRadius.circular(30)),child:Text('${o['status']}',style:const TextStyle(fontSize:11,fontWeight:FontWeight.w800))) ]));})); } }

class _AccountTile extends StatelessWidget { final IconData icon; final String title,subtitle; final VoidCallback onTap; const _AccountTile({required this.icon,required this.title,required this.subtitle,required this.onTap}); @override Widget build(BuildContext context)=>ListTile(contentPadding:const EdgeInsets.symmetric(horizontal:4,vertical:4),leading:Container(width:42,height:42,decoration:BoxDecoration(color:pale,borderRadius:BorderRadius.circular(13)),child:Icon(icon,size:20)),title:Text(title,style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text(subtitle,style:const TextStyle(color:grey,fontSize:11)),trailing:const Icon(Icons.chevron_right,color:grey),onTap:onTap); }
class _ProductThumb extends StatelessWidget { final Product product; const _ProductThumb({required this.product}); @override Widget build(BuildContext context)=>Container(width:72,height:78,decoration:BoxDecoration(color:pale,borderRadius:BorderRadius.circular(12)),child:Icon(product.icon,size:33,color:charcoal)); }
class _QtyButton extends StatelessWidget { final IconData icon; final VoidCallback onTap; const _QtyButton({required this.icon,required this.onTap}); @override Widget build(BuildContext context)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(7),child:Container(width:26,height:25,decoration:BoxDecoration(border:Border.all(color:border),borderRadius:BorderRadius.circular(7)),child:Icon(icon,size:15))); }
class _PriceRow extends StatelessWidget { final String label,value; final bool bold; const _PriceRow({required this.label,required this.value,this.bold=false}); @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.symmetric(vertical:4),child:Row(children:[Expanded(child:Text(label,style:TextStyle(color:bold?black:grey,fontSize:bold?14:12,fontWeight:bold?FontWeight.w900:FontWeight.w500))),Text(value,style:TextStyle(color:black,fontSize:bold?17:12,fontWeight:bold?FontWeight.w900:FontWeight.w700))])); }
class _LogoMark extends StatelessWidget { final double size; const _LogoMark({required this.size}); @override Widget build(BuildContext context)=>Container(width:size,height:size,decoration:BoxDecoration(color:black,borderRadius:BorderRadius.circular(size*.27)),alignment:Alignment.center,child:Text('R.',style:TextStyle(color:white,fontSize:size*.45,fontWeight:FontWeight.w900,letterSpacing:-2))); }
class _EmptyState extends StatelessWidget { final String title,subtitle; const _EmptyState({required this.title,required this.subtitle}); @override Widget build(BuildContext context)=>Center(child:Padding(padding:const EdgeInsets.all(30),child:Column(mainAxisSize:MainAxisSize.min,children:[Container(width:68,height:68,decoration:const BoxDecoration(color:pale,shape:BoxShape.circle),child:const Icon(Icons.shopping_bag_outlined,size:30,color:grey)),const SizedBox(height:14),Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w900)),const SizedBox(height:5),Text(subtitle,textAlign:TextAlign.center,style:const TextStyle(color:grey,fontSize:12))]))); }
Future<void> _showSort(BuildContext context) async { final s=StoreScope.of(context); final value=await showModalBottomSheet<String>(context:context,backgroundColor:white,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(22))),builder:(c)=>SafeArea(child:Column(mainAxisSize:MainAxisSize.min,children:[const Padding(padding:EdgeInsets.all(18),child:Text('Sort products',style:TextStyle(fontSize:18,fontWeight:FontWeight.w900))),...['Featured','Price: Low to High','Price: High to Low','Top Rated'].map((x)=>ListTile(title:Text(x),trailing:s.sort==x?const Icon(Icons.check):null,onTap:()=>Navigator.pop(c,x))),const SizedBox(height:10)]))); if(value!=null){s.sort=value;s.notifyListeners();} }
