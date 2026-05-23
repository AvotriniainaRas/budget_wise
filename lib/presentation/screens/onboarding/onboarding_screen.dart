import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/theme/theme.dart';
import '../../navigation/app_router.dart';

/// Modèle d'une page d'onboarding.
class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final IconData icon;
  final Color    color;
  final String   title;
  final String   subtitle;
  final String   description;
}

/// Liste des pages d'onboarding.
const List<_OnboardingPage> _pages = [
  _OnboardingPage(
    icon:        Icons.account_balance_wallet_rounded,
    color:       AppColors.primary,
    title:       'Bienvenue sur\nBudgetWise',
    subtitle:    'Votre assistant financier personnel',
    description: 'Suivez vos revenus et dépenses, '
        'visualisez vos finances et atteignez '
        'vos objectifs d\'épargne facilement.',
  ),
  _OnboardingPage(
    icon:        Icons.receipt_long_rounded,
    color:       AppColors.secondary,
    title:       'Gérez vos\ntransactions',
    subtitle:    'Revenus et dépenses en un clin d\'œil',
    description: 'Ajoutez vos transactions en quelques '
        'secondes. Classez-les par catégorie, '
        'filtrez et recherchez facilement.',
  ),
  _OnboardingPage(
    icon:        Icons.bar_chart_rounded,
    color:       Color(0xFF7C4DFF),
    title:       'Analysez vos\nstatistiques',
    subtitle:    'Des graphiques clairs et parlants',
    description: 'Visualisez l\'évolution de votre solde, '
        'la répartition de vos dépenses par '
        'catégorie et vos tendances mensuelles.',
  ),
  _OnboardingPage(
    icon:        Icons.savings_rounded,
    color:       AppColors.income,
    title:       'Atteignez vos\nobjectifs',
    subtitle:    'Épargnez avec méthode',
    description: 'Définissez des objectifs d\'épargne, '
        'suivez votre progression et célébrez '
        'chaque étape franchie.',
  ),
  // Nouvelle page : Signature développeur
  _OnboardingPage(
    icon:        Icons.code_rounded,
    color:       AppColors.primary,
    title:       'Développé par',
    subtitle:    'Avotriniaina Rasamimanana',
    description: 'Développeur Web & Mobile\n'
        'Passionné par la création d\'applications '
        'utiles et bien conçues.',
  ),
];

/// Écran d'onboarding — affiché uniquement au premier lancement.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _fadeController;
  late Animation<double>   _fadeAnim;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve:  Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve:    Curves.easeInOutCubic,
      );
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    await PreferencesService.instance.setOnboardingDone();
    if (mounted) context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [

              // ── Bouton passer ──────────────────────────
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: TextButton(
                    onPressed: _finish,
                    child: const Text(
                      'Passer',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // ── PageView ───────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller:    _pageController,
                  itemCount:     _pages.length,
                  onPageChanged: (index) {
                    _fadeController.reset();
                    setState(() => _currentPage = index);
                    _fadeController.forward();
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPageWidget(page: _pages[index]);
                  },
                ),
              ),

              // ── Indicateurs de page ────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _PageIndicator(
                    isActive: index == _currentPage,
                    color:    page.color,
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingL),

              // ── Boutons ────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingL,
                  0,
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                ),
                child: Column(
                  children: [
                    // Bouton principal
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width:    double.infinity,
                      height:   52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: page.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                          ),
                        ),
                        onPressed: _nextPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLast ? 'Commencer' : 'Suivant',
                              style: const TextStyle(
                                fontSize:   16,
                                fontWeight: FontWeight.w600,
                                color:      Colors.white,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            Icon(
                              isLast
                                  ? Icons.rocket_launch_rounded
                                  : Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size:  20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Page individuelle ─────────────────────────────────────

class _OnboardingPageWidget extends StatelessWidget {
  const _OnboardingPageWidget({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXL,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // ── Illustration ───────────────────────────────
          TweenAnimationBuilder<double>(
            tween:    Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve:    Curves.elasticOut,
            builder:  (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width:       160,
              height:      160,
              decoration:  BoxDecoration(
                color:        page.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusXL * 2),
                border: Border.all(
                  color: page.color.withValues(alpha: 0.25),
                  width: 2,
                ),
              ),
              child: Icon(
                page.icon,
                size:  80,
                color: page.color,
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingXL),

          // ── Titre ──────────────────────────────────────
          Text(
            page.title,
            style: AppTextStyles.headlineLarge.copyWith(
              color:  AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingS),

          // ── Sous-titre ─────────────────────────────────
          Text(
            page.subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color:      page.color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingM),

          // ── Description ────────────────────────────────
          Text(
            page.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color:  AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Indicateur de page ────────────────────────────────────

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.isActive,
    required this.color,
  });

  final bool  isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin:   const EdgeInsets.symmetric(horizontal: 4),
      width:    isActive ? 24 : 8,
      height:   8,
      decoration: BoxDecoration(
        color:        isActive
            ? color
            : AppColors.divider,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}