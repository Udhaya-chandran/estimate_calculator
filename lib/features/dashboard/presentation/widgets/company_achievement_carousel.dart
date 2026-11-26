import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class CompanyAchievement {
  final String tag;
  final IconData icon;
  final String title;
  final String subtitle;
  final String stat1Label;
  final String stat1Value;
  final String stat2Label;
  final String stat2Value;
  final List<Color> gradient;
  final String ctaText;
  final bool isPrimaryAction;

  const CompanyAchievement({
    required this.tag,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.stat1Label,
    required this.stat1Value,
    required this.stat2Label,
    required this.stat2Value,
    required this.gradient,
    required this.ctaText,
    this.isPrimaryAction = true,
  });
}

class CompanyAchievementCarousel extends StatefulWidget {
  final VoidCallback onStartEstimate;
  final VoidCallback onBrowseCategories;

  const CompanyAchievementCarousel({
    super.key,
    required this.onStartEstimate,
    required this.onBrowseCategories,
  });

  @override
  State<CompanyAchievementCarousel> createState() => _CompanyAchievementCarouselState();
}

class _CompanyAchievementCarouselState extends State<CompanyAchievementCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  static const List<CompanyAchievement> _achievements = [
    CompanyAchievement(
      tag: '25+ YEARS OF EXCELLENCE',
      icon: Icons.emoji_events_rounded,
      title: 'Building Material Hyper Market',
      subtitle: 'Over 50,000+ construction projects supplied with certified structural steel & building materials.',
      stat1Value: '50,000+',
      stat1Label: 'Projects Built',
      stat2Value: 'ISO 9001',
      stat2Label: 'Certified Quality',
      gradient: [Color(0xFF8B0000), Color(0xFFD90000), Color(0xFFB30000)],
      ctaText: 'Start New Estimate',
      isPrimaryAction: true,
    ),
    CompanyAchievement(
      tag: 'MEGA HUB INFRASTRUCTURE',
      icon: Icons.storefront_rounded,
      title: '100,000 Sq.Ft Hypermarket',
      subtitle: 'Over 5,000+ in-stock products across steel, plumbing, sanitaryware & hardware under one roof.',
      stat1Value: '100K Sq.Ft',
      stat1Label: 'Warehouse Hub',
      stat2Value: '5,000+',
      stat2Label: 'Products In-Stock',
      gradient: [Color(0xFF650000), Color(0xFF900000), Color(0xFFC40000)],
      ctaText: 'Browse Catalog',
      isPrimaryAction: false,
    ),
    CompanyAchievement(
      tag: 'AUTHORIZED MEGA DISTRIBUTOR',
      icon: Icons.verified_rounded,
      title: '40+ Leading Global Brands',
      subtitle: 'Direct factory partnerships with Tata Tiscon, Grohe, Kohler, Astral, and UltraTech.',
      stat1Value: '40+',
      stat1Label: 'Global Brands',
      stat2Value: '100%',
      stat2Label: 'Original Quality',
      gradient: [Color(0xFF7A0000), Color(0xFFA50000), Color(0xFFD90000)],
      ctaText: 'Start New Estimate',
      isPrimaryAction: true,
    ),
    CompanyAchievement(
      tag: 'FAST LOGISTICS FLEET',
      icon: Icons.local_shipping_rounded,
      title: 'Rapid On-Site Delivery',
      subtitle: 'Dedicated hypermarket crane & transport fleet delivering heavy materials directly to your site.',
      stat1Value: 'Same Day',
      stat1Label: 'Dispatch Option',
      stat2Value: '15,000+',
      stat2Label: 'Happy Builders',
      gradient: [Color(0xFF900000), Color(0xFFBA0000), Color(0xFF650000)],
      ctaText: 'Start New Estimate',
      isPrimaryAction: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _achievements.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _achievements.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _achievements[index];
              return _buildCarouselCard(item);
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_achievements.length, (index) {
            final isSelected = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 5,
              width: isSelected ? 22 : 6,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : context.colors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(CompanyAchievement item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: item.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: item.gradient.first.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative watermark circles
          Positioned(
            right: -25,
            top: -25,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Main Card Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Tag Badge & Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              color: const Color(0xFFFFE082),
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                item.tag,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'SAUDI STEELS',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                // Middle Title and Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 11.5,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),

                // Bottom Stats Row & CTA Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Stat 1 & Stat 2 Chips
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: _buildStatChip(item.stat1Value, item.stat1Label)),
                          const SizedBox(width: 6),
                          Flexible(child: _buildStatChip(item.stat2Value, item.stat2Label)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Quick Action Button
                    InkWell(
                      onTap: item.isPrimaryAction ? widget.onStartEstimate : widget.onBrowseCategories,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.ctaText,
                              style: const TextStyle(
                                color: AppColors.primaryRed,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 11,
                              color: AppColors.primaryRed,
                            ),
                          ],
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

  Widget _buildStatChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

