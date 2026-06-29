import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/customer/customer_model.dart';
import 'package:frontfile_servease/features/customer/services/customerserviceali.dart';
import 'package:frontfile_servease/features/customer/screens/book_service_screen.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';

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

  Color get _avatarBg => const Color(0xFFF5EDE3);
  Color get _avatarText => const Color(0xFF8B6914);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
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
                          const SizedBox(height: 12),
                          if (_provider!.servicesOffered.isNotEmpty)
                            _buildServicesSection(),
                          const SizedBox(height: 12),
                          if (_provider!.bio.isNotEmpty) _buildAboutSection(),
                          const SizedBox(height: 12),
                          _buildReviewsSection(),
                          const SizedBox(height: 90),
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
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primaryGreen,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.primaryGreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Circular avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    _provider!.initials,
                    style: TextStyle(
                      color: _avatarText,
                      fontSize: 28,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_provider!.isVerified) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Text(
                        '✓ Verified',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _provider!.service,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
            _statItem(value: '${_provider!.jobsDone}+', label: 'Jobs'),
            _verticalDivider(),
            _statItem(value: 'RS ${_provider!.rate}/hr', label: 'Rate'),
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 15, color: iconColor),
                  const SizedBox(width: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              )
            else
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider() => Container(
    width: 1,
    margin: const EdgeInsets.symmetric(vertical: 12),
    color: Colors.grey.shade200,
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
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w500,
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
      title: 'About',
      child: Text(
        _provider!.bio,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textMuted,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return _card(
      title: 'Reviews',
      child: _provider!.reviews.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No reviews yet',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
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
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookServiceScreen(provider: _provider!),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Book Now',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F0),
        borderRadius: BorderRadius.circular(10),
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
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        review.initials,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
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
                const Text(
                  '✓ Verified buyer',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
