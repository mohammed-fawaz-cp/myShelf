import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme_provider.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authControllerProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
      if (!mounted) return;
      if (success) {
        // Handled by main.dart routing / state observer, or we navigate directly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome to myShelf.',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        final error = ref.read(authControllerProvider).errorMessage;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error,
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final authState = ref.watch(authControllerProvider);

    // Decorative silk texture grid logic (subtle gradient/background)
    final boxDecoration = isDark
        ? const BoxDecoration(
            color: Color(0xFF0D141D),
            image: DecorationImage(
              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBoff52yhMrq36fLn2Wb5o38QoXrrJa7XjrGgKINUFvphk5vGgSxjZE-xz4JnqZU-k0chfec0g7Y4oflZm6dtmd6r0TOx_HPxLyxtILNysUmkTb7Nb95Gl6ksuz5dsA0acnKrJQSRhC8VuuzRRyQvUfJB65IUazSYyGakROvz2Kaf8AF928m2ShKpw6685SGC2LEekjlQ5e-YuyyiOQXpy2mnTH-gyWisVblG-CPMDMLE-pJobDElsPUX-YdPDG1ZL3qjPmfzVUjOZG'),
              fit: BoxFit.cover,
              opacity: 0.05,
            ),
          )
        : const BoxDecoration(
            color: Color(0xFFFCF9F8),
            image: DecorationImage(
              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBoff52yhMrq36fLn2Wb5o38QoXrrJa7XjrGgKINUFvphk5vGgSxjZE-xz4JnqZU-k0chfec0g7Y4oflZm6dtmd6r0TOx_HPxLyxtILNysUmkTb7Nb95Gl6ksuz5dsA0acnKrJQSRhC8VuuzRRyQvUfJB65IUazSYyGakROvz2Kaf8AF928m2ShKpw6685SGC2LEekjlQ5e-YuyyiOQXpy2mnTH-gyWisVblG-CPMDMLE-pJobDElsPUX-YdPDG1ZL3qjPmfzVUjOZG'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          );

    final btnGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFFF2CA50), Color(0xFFD4AF37)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF1C1B1B), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: boxDecoration,
        child: Stack(
          children: [
            // Top App Bar/Branding
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'myShelf',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Main Contents (Center aligned)
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Editorial Header
                        Text(
                          'Welcome Back',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 42.0,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Please enter your credentials to access your private collection.',
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32.0),

                        // Form Container (Glassmorphism styled)
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? theme.colorScheme.surface.withOpacity(0.3)
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withOpacity(isDark ? 0.1 : 0.3),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                                blurRadius: 20.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Email Input
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    labelStyle: GoogleFonts.inter(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    floatingLabelStyle: GoogleFonts.inter(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.outlineVariant,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.secondary,
                                        width: 1.5,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your email.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24.0),

                                // Password Input
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: GoogleFonts.inter(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    floatingLabelStyle: GoogleFonts.inter(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.outlineVariant,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.secondary,
                                        width: 1.5,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password.';
                                    }
                                    return null;
                                  },
                                ),

                                // Forgot Password Link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28.0),

                                // Action Button
                                Container(
                                  height: 52.0,
                                  decoration: BoxDecoration(
                                    gradient: btnGradient,
                                    borderRadius: BorderRadius.circular(26.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.secondary.withOpacity(0.15),
                                        blurRadius: 10.0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: authState.isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26.0),
                                      ),
                                    ),
                                    child: authState.isLoading
                                        ? SizedBox(
                                            width: 24.0,
                                            height: 24.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: isDark ? Colors.black : Colors.white,
                                            ),
                                          )
                                        : Text(
                                            'SIGN IN',
                                            style: GoogleFonts.inter(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.5,
                                              color: isDark ? Colors.black : Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'OR CONTINUE WITH',
                                style: GoogleFonts.inter(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.0,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),

                        // Social Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  side: BorderSide(
                                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.apple,
                                  color: theme.colorScheme.primary,
                                  size: 20.0,
                                ),
                                label: Text(
                                  'Apple',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  side: BorderSide(
                                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.g_mobiledata,
                                  color: theme.colorScheme.primary,
                                  size: 24.0,
                                ),
                                label: Text(
                                  'Google',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),

                        // Footer Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to the experience?',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: theme.colorScheme.secondary.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Create Account',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
