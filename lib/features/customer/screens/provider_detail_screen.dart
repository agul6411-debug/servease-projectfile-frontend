import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/customer/customer_model.dart';
import 'package:frontfile_servease/features/customer/services/customerserviceali.dart';
import 'package:frontfile_servease/features/customer/screens/book_service_screen.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderDetailScreen extends StatefulWidget {
  final int providerId;
  const ProviderDetailScreen({super.key, required this.providerId});

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  ProviderDetail? _provider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await CustomerApiService.fetchProviderDetail(
      widget.providerId,
    );
    setState(() {
      _provider = data;
      _isLoading = false;
    });
  }

  Color get _avatarBg => const Color(0xFFEBF6EE);
  Color get _avatarText => AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF8),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _provider == null
          ? const Center(child: Text('Provider not found'))
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    _buildSliverHeader(),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildStatsRow(),
                          const SizedBox(height: 16),
                          if (_provider!.servicesOffered.isNotEmpty)
                            _buildServicesSection(),
                          const SizedBox(height: 16),
                          if (_provider!.bio.isNotEmpty) _buildAboutSection(),
                          const SizedBox(height: 16),
                          _buildReviewsSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildBookButton(),
              ],
            ),
    );
  }

  SliverAppBar _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      backgroundColor: const Color(0xFF0F5A34),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F5A34),
                Color(0xFF1B8B4B),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Circular avatar with premium shadow
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _provider!.initials,
                    style: GoogleFonts.outfit(
                      color: _avatarText,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Name + verified
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _provider!.name,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (_provider!.isVerified) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  _provider!.service,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBF2EC), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _statItem(
              value: _provider!.rating.toStringAsFixed(1),
              label: 'Rating',
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFF59E0B),
            ),
            _verticalDivider(),
            _statItem(value: '${_provider!.jobsDone}+', label: 'Jobs Done'),
            _verticalDivider(),
            _statItem(value: 'Rs ${_provider!.rate.toInt()}/hr', label: 'Hourly Rate'),
            _verticalDivider(),
            _statItem(
              value: _provider!.location.isNotEmpty
                  ? _provider!.location.split(',').first.trim()
                  : 'N/A',
              label: 'Location',
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem({
    required String value,
    required String label,
    IconData? icon,
    Color? iconColor,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16, color: iconColor),
                  const SizedBox(width: 2),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              )
            else
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider() => Container(
    width: 1.2,
    margin: const EdgeInsets.symmetric(vertical: 14),
    color: const Color(0xFFEBF2EC),
  );

  Widget _buildServicesSection() {
    return _card(
      title: 'Services Offered',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _provider!.servicesOffered
            .map(
              (s) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  s,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildAboutSection() {
    return _card(
      title: 'About Specialist',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary.withOpacity(0.2),
            size: 24,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _provider!.bio,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.mutedForeground,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return _card(
      title: 'Customer Reviews',
      child: _provider!.reviews.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      color: AppColors.mutedForeground.withOpacity(0.4),
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No reviews yet',
                      style: GoogleFonts.inter(
                        color: AppColors.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: _provider!.reviews
                  .map((r) => _ReviewTile(review: r))
                  .toList(),
            ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBF2EC), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFEBF2EC), width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            final token = GetStorage().read('auth_token') ?? '';
            if (token.isEmpty) {
              Get.toNamed(AppRoutes.loginScreen);
              Get.snackbar(
                'Authentication Required',
                'Please login or register to book this service partner.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.foreground.withOpacity(0.9),
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookServiceScreen(provider: _provider!),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            shadowColor: AppColors.primary.withOpacity(0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Book Appointment Now',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBF2EC), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        review.initials,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: i < review.rating.round()
                                ? const Color(0xFFF59E0B)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (review.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 10),
                      const SizedBox(width: 3),
                      Text(
                        'Verified Buy',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
