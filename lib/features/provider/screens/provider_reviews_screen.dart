import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/features/provider/services/provider_profile_service.dart';
import 'package:frontfile_servease/core/services/app_config.dart';

class ProviderReviewsScreen extends StatefulWidget {
  final int providerId;
  const ProviderReviewsScreen({super.key, required this.providerId});

  @override
  State<ProviderReviewsScreen> createState() => _ProviderReviewsScreenState();
}

class _ProviderReviewsScreenState extends State<ProviderReviewsScreen> {
  List<dynamic>? _reviews;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    final data = await ProviderProfileService.getReviews(widget.providerId);
    setState(() {
      _reviews = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'My Reviews',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : (_reviews == null || _reviews!.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reviews from customers will appear here.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: _loadReviews,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _reviews!.length,
                    itemBuilder: (context, index) {
                      final r = _reviews![index];
                      final rating = (r['rating'] as num?)?.toDouble() ?? 0.0;
                      final note = r['note'] ?? '';
                      final date = r['date'] ?? '';
                      final custName = r['customer_name'] ?? 'Customer';
                      final custImage = r['customer_image'] ?? '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                                  backgroundImage: (custImage.isNotEmpty)
                                      ? NetworkImage(custImage.startsWith('http')
                                          ? custImage
                                          : "${AppConfig.baseUrl}$custImage")
                                      : null,
                                  child: custImage.isEmpty
                                      ? Text(
                                          custName.isNotEmpty ? custName[0].toUpperCase() : 'C',
                                          style: const TextStyle(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        custName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        date,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      Icons.star,
                                      size: 14,
                                      color: i < rating
                                          ? Colors.amber
                                          : Colors.grey.shade300,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            if (note.toString().trim().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                note,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textDark,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
