import 'package:flutter/material.dart';

void main() => runApp(const PawsApp());

// ═══════════════════════════════════════════════════════════════════════════
// THEME  (move this block to lib/theme.dart when you split the files)
// Every color and font on the screens comes from here, never Colors.xxx.
// ═══════════════════════════════════════════════════════════════════════════

const _primary = Color(0xFF2F5D50);
const _primarySoft = Color(0xFFE3EEE9);
const _accent = Color(0xFFF2A65A);
const _background = Color(0xFFF5F6F1);
const _ink = Color(0xFF1E2A26);
const _muted = Color(0xFF5F6B66);
const _line = Color(0xFFDCE1DD);
const _error = Color(0xFFB3261E);

ThemeData buildPawsTheme() {
  final colors = ColorScheme.fromSeed(seedColor: _primary).copyWith(
    primary: _primary,
    onPrimary: Colors.white,
    primaryContainer: _primarySoft,
    onPrimaryContainer: _primary,
    secondary: _accent, // accent
    onSecondary: _ink,
    surface: Colors.white,
    onSurface: _ink,
    onSurfaceVariant: _muted, // muted text
    outline: _line, // borders and dividers
    error: _error,
  );

  const fredoka = 'Fredoka';
  const nunito = 'NunitoSans';

  final textTheme = TextTheme(
    headlineMedium: const TextStyle(
        fontFamily: fredoka, fontSize: 30, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(
        fontFamily: fredoka, fontSize: 21, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle(
        fontFamily: fredoka, fontSize: 16, fontWeight: FontWeight.w600),
    labelLarge: const TextStyle(
        fontFamily: fredoka, fontSize: 17, fontWeight: FontWeight.w600),
    bodyLarge: const TextStyle(
        fontFamily: nunito, fontSize: 15, fontWeight: FontWeight.w400),
    labelMedium: const TextStyle(
        fontFamily: nunito, fontSize: 13, fontWeight: FontWeight.w700),
    bodySmall: const TextStyle(
        fontFamily: nunito, fontSize: 12.5, fontWeight: FontWeight.w400),
    bodyMedium: const TextStyle(
        fontFamily: nunito, fontSize: 13, fontWeight: FontWeight.w400),
  ).apply(bodyColor: _ink, displayColor: _ink);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: _background,
    textTheme: textTheme,
    fontFamily: nunito,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: _primarySoft,
      labelTextStyle: WidgetStatePropertyAll(
        textTheme.labelMedium!.copyWith(fontSize: 12),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? _primary : _muted,
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// APP + ROUTES
// ═══════════════════════════════════════════════════════════════════════════

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const petDetail = '/pet';
}

class PawsApp extends StatelessWidget {
  const PawsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paws & Homes',
      debugShowCheckedModeBanner: false,
      theme: buildPawsTheme(),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.petDetail: (_) => const PetDetailScreen(),
      },
    );
  }
}

class MyApp extends PawsApp {
  const MyApp({super.key}) : super();
}

// ═══════════════════════════════════════════════════════════════════════════
// SHARED WIDGET: PawsField
// 52 high, radius 12, 1.5 line border, 2 primary when focused, 2 error red
// on error. Prefix icon 20 follows the same colour. Error message sits under
// the box: 12.5 Bold + alert icon 14.
// ═══════════════════════════════════════════════════════════════════════════

class PawsField extends StatefulWidget {
  const PawsField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.label,
    this.validator,
    this.autoValidate = false,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.onChanged,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? label;
  final String? Function(String?)? validator;
  final bool autoValidate;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  State<PawsField> createState() => _PawsFieldState();
}

class _PawsFieldState extends State<PawsField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return FormField<String>(
      initialValue: widget.controller.text,
      validator: widget.validator,
      autovalidateMode: widget.autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      builder: (state) {
        final hasError = state.hasError;
        final focused = _focus.hasFocus;

        Color borderColor = scheme.outline;
        double borderWidth = 1.5;
        Color iconColor = scheme.onSurfaceVariant;
        if (hasError) {
          borderColor = scheme.error;
          borderWidth = 2;
          iconColor = scheme.error;
        } else if (focused) {
          borderColor = scheme.primary;
          borderWidth = 2;
          iconColor = scheme.primary;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Text(widget.label!, style: text.labelMedium),
              const SizedBox(height: 6),
            ],
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, size: 20, color: iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focus,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      style: text.bodyLarge,
                      cursorColor: scheme.primary,
                      onChanged: (v) {
                        state.didChange(v);
                        widget.onChanged?.call(v);
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: widget.hint,
                        hintStyle: text.bodyLarge!
                            .copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  if (widget.suffix != null) widget.suffix!,
                ],
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.error_outline, size: 14, color: scheme.error),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      state.errorText!,
                      style: text.bodySmall!.copyWith(
                        color: scheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCREEN 01 / 02: LOGIN
// ═══════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  bool _submitted = false; // start showing errors after the first tap

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || !_emailRegex.hasMatch(v.trim())) {
      return 'Enter a valid email, like name@example.com';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // Let the fields rebuild with autovalidate on, then validate the form.
    await Future<void>.delayed(Duration.zero);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final email = _emailCtrl.text.trim();
    final raw = email.split('@').first;
    final name = raw.isEmpty ? 'Friend' : raw[0].toUpperCase() + raw.substring(1);

    Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: name);
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 96 from the top of the screen ≈ 40 below the status bar
                const SizedBox(height: 40),

                // Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(Icons.pets, size: 38, color: scheme.onPrimary),
                ),
                const SizedBox(height: 28),

                // Title + subtitle
                Text('Welcome back', style: text.headlineMedium),
                const SizedBox(height: 6),
                Text(
                  'Log in to meet pets waiting for a home.',
                  style: text.bodyLarge!.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),

                // Fields
                PawsField(
                  label: 'Email',
                  hint: 'name@example.com',
                  icon: Icons.mail_outline,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  autoValidate: _submitted,
                ),
                const SizedBox(height: 18),
                PawsField(
                  label: 'Password',
                  hint: 'At least 8 characters',
                  icon: Icons.lock_outline,
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  autoValidate: _submitted,
                  suffix: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                // Forgot password
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _comingSoon,
                    child: Text(
                      'Forgot password?',
                      style: text.labelMedium!.copyWith(color: scheme.primary),
                    ),
                  ),
                ),

                // Primary button
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _loading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      disabledBackgroundColor: scheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      textStyle: text.labelLarge,
                    ),
                    child: _loading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: scheme.onPrimary,
                            ),
                          )
                        : const Text('Log in'),
                  ),
                ),

                // Divider
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(child: Divider(color: scheme.outline, height: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text('or',
                          style: text.bodySmall!
                              .copyWith(color: scheme.onSurfaceVariant)),
                    ),
                    Expanded(child: Divider(color: scheme.outline, height: 1)),
                  ],
                ),
                const SizedBox(height: 22),

                // Outlined button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: _comingSoon,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.primary,
                      side: BorderSide(color: scheme.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      textStyle: text.labelLarge,
                    ),
                    child: const Text('Create an account'),
                  ),
                ),

                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'By continuing you agree to the Terms and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: text.bodySmall!
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA
// ═══════════════════════════════════════════════════════════════════════════

class PetCategory {
  const PetCategory(this.name, this.icon);
  final String name;
  final IconData? icon;
}

// "All" has no icon. Swap the icons for your own assets if you like.
const categories = <PetCategory>[
  PetCategory('All', null),
  PetCategory('Dogs', Icons.pets),
  PetCategory('Cats', Icons.emoji_nature),
  PetCategory('Rabbits', Icons.cruelty_free),
  PetCategory('Birds', Icons.flutter_dash),
];

class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.isFemale,
    required this.breed,
    required this.age,
    required this.category,
    this.isNew = false,
  });
  final int id;
  final String name;
  final bool isFemale;
  final String breed;
  final String age;
  final String category;
  final bool isNew;
}

const allPets = <Pet>[
  Pet(id: 1, name: 'Coco', isFemale: true, breed: 'Persian', age: '1 yr', category: 'Cats', isNew: true),
  Pet(id: 2, name: 'Bruno', isFemale: false, breed: 'Labrador', age: '2 yrs', category: 'Dogs'),
  Pet(id: 3, name: 'Mochi', isFemale: true, breed: 'Holland Lop', age: '8 mo', category: 'Rabbits', isNew: true),
  Pet(id: 4, name: 'Simba', isFemale: false, breed: 'Indian Shorthair', age: '3 yrs', category: 'Cats'),
  Pet(id: 5, name: 'Luna', isFemale: true, breed: 'Indie', age: '1 yr', category: 'Dogs'),
  Pet(id: 6, name: 'Kiwi', isFemale: false, breed: 'Budgerigar', age: '6 mo', category: 'Birds', isNew: true),
  Pet(id: 7, name: 'Oreo', isFemale: false, breed: 'Beagle', age: '4 yrs', category: 'Dogs'),
  Pet(id: 8, name: 'Pearl', isFemale: true, breed: 'Dwarf Rabbit', age: '2 yrs', category: 'Rabbits'),
];

IconData _iconForCategory(String category) {
  return categories
          .firstWhere((c) => c.name == category, orElse: () => categories[1])
          .icon ??
      Icons.pets;
}

// ═══════════════════════════════════════════════════════════════════════════
// SCREEN 03: HOME
// ═══════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  String _category = 'All';
  String _query = '';
  final Set<int> _favourites = {};

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Pet> get _visiblePets => allPets.where((p) {
        final matchesCategory = _category == 'All' || p.category == _category;
        final matchesQuery =
            _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase());
        return matchesCategory && matchesQuery;
      }).toList();

  void _toggleFavourite(int id) {
    setState(() {
      if (!_favourites.remove(id)) _favourites.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final name = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'Friend';
    final pets = _visiblePets;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting row
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      name.substring(0, 1).toUpperCase(),
                      style: text.titleMedium!.copyWith(color: scheme.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyMedium!
                              .copyWith(color: scheme.onSurfaceVariant),
                        ),
                        Text('Find your new friend', style: text.titleLarge),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Stack(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.outline, width: 1),
                        ),
                        child: Icon(Icons.notifications_none,
                            size: 22, color: scheme.onSurface),
                      ),
                      Positioned(
                        top: 10,
                        right: 11,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: scheme.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: scheme.surface, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Search
              PawsField(
                controller: _searchCtrl,
                hint: 'Search pets by name',
                icon: Icons.search,
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
              const SizedBox(height: 18),

              // Banner
              _Banner(onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(content: Text('Coming soon')));
              }),
              const SizedBox(height: 18),

              // Category chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final c = categories[i];
                    return _CategoryChip(
                      category: c,
                      selected: _category == c.name,
                      onTap: () => setState(() => _category = c.name),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              Text('Pets near you', style: text.titleLarge!.copyWith(fontSize: 19)),
              const SizedBox(height: 12),

              // Pet grid
              if (pets.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No pets found.',
                      style: text.bodyLarge!
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 226,
                  ),
                  itemBuilder: (_, i) {
                    final pet = pets[i];
                    return _PetCard(
                      pet: pet,
                      favourite: _favourites.contains(pet.id),
                      onFavourite: () => _toggleFavourite(pet.id),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.petDetail,
                        arguments: pet,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (_) {}, // only Home needs to work for now
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favourites'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ── Banner ──────────────────────────────────────────────────────────────────

class _Banner extends StatelessWidget {
  const _Banner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        color: scheme.primary,
        padding: const EdgeInsets.all(18),
        child: Stack(
          children: [
            // Large paw at 14% white
            const Positioned(
              right: -18,
              bottom: -22,
              child: Icon(Icons.pets, size: 120, color: Color(0x24FFFFFF)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adopt, don\'t shop',
                    style: text.titleLarge!
                        .copyWith(fontSize: 20, color: scheme.onPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '120 pets are ready to meet you this week.',
                    style: text.bodyMedium!.copyWith(color: scheme.onPrimary),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: scheme.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Meet them',
                        style: text.labelMedium!
                            .copyWith(color: scheme.onSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category chip ───────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final PetCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: EdgeInsets.only(
          left: category.icon == null ? 18 : 6,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : scheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: selected ? null : Border.all(color: scheme.outline, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.icon != null) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, size: 16, color: scheme.primary),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              category.name,
              style: text.labelMedium!.copyWith(
                color: selected ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pet card ────────────────────────────────────────────────────────────────

class _PetCard extends StatelessWidget {
  const _PetCard({
    required this.pet,
    required this.favourite,
    required this.onFavourite,
    required this.onTap,
  });

  final Pet pet;
  final bool favourite;
  final VoidCallback onFavourite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outline, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo area (placeholder icon until you add real images)
            SizedBox(
              height: 128,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: scheme.primaryContainer,
                      child: Icon(
                        _iconForCategory(pet.category),
                        size: 44,
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  if (pet.isNew)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: scheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'New',
                          style: text.labelMedium!.copyWith(
                              fontSize: 11, color: scheme.onSecondary),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavourite,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          favourite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: favourite
                              ? scheme.error
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          pet.isFemale ? 'F' : 'M',
                          style: text.labelMedium!
                              .copyWith(fontSize: 11, color: scheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet.breed} · ${pet.age}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall!
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PET DETAIL (placeholder: replace with the screen from the Paws & Homes brief)
// ═══════════════════════════════════════════════════════════════════════════

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context)!.settings.arguments as Pet;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name, style: theme.textTheme.titleLarge),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          '${pet.name}: ${pet.breed}, ${pet.age}',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}