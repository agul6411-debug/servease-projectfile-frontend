import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontfile_servease/services/providerapiservices/providerapiservice.dart';
import 'package:frontfile_servease/models/providermodel/providermodelapi.dart';
import 'package:frontfile_servease/screens/provider/pay_commission_screen.dart';
import 'package:frontfile_servease/screens/provider/providernavbar.dart';
import 'package:frontfile_servease/screens/provider/my_jobs_screen.dart';
import 'package:frontfile_servease/screens/provider/provider_home_screen.dart';
import 'package:frontfile_servease/screens/provider/provider_profile_screen.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

class EarningsScreen extends StatefulWidget {
  final int providerId;
  const EarningsScreen({super.key, required this.providerId});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  EarningsSummary? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final data = await ProviderApiService.fetchEarnings(widget.providerId);
    setState(() {
      _data = data;
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
          'Earnings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : RefreshIndicator(
              color: AppColors.primaryGreen,
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(),
                    const SizedBox(height: 14),
                    _buildChart(),
                    const SizedBox(height: 14),
                    _buildCommissionModel(),
                    const SizedBox(height: 14),
                    _buildTransactionHistory(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPayButton(),
          ProviderBottomNavBar(
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProviderHomeScreen(providerId: widget.providerId),
                  ),
                );
                return;
              }
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyJobsScreen(providerId: widget.providerId),
                  ),
                );
                return;
              }
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProviderProfileScreen(providerId: widget.providerId),
                  ),
                );
                return;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final total = _data?.totalEarned ?? 0;
    final commission = _data?.commissionDue ?? 0;
    return Row(
      children: [
        Expanded(
          child: _statCard(
            'RS ${_fmt(total)}',
            'Total Earned',
            Colors.white,
            AppColors.textDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'RS ${_fmt(commission)}',
            'Commission Due',
            Colors.white,
            AppColors.accentYellow,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String value, String label, Color bg, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final monthly = _data?.monthly ?? [];
    if (monthly.isEmpty) return const SizedBox();

    final maxY = monthly
        .map((m) => m.amount)
        .fold(0.0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Earnings (RS)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY * 1.3,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, _) {
                        final i = val.toInt();
                        if (i < monthly.length) {
                          final amt = monthly[i].amount;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              amt >= 1000
                                  ? '${(amt / 1000).toStringAsFixed(1)}k'
                                  : amt.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.textMuted,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, _) {
                        final i = val.toInt();
                        if (i < monthly.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              monthly[i].month,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: monthly.asMap().entries.map((e) {
                  final amt = e.value.amount;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: amt,
                        color: AppColors.primaryGreen,
                        width: 28,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionModel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightYellow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.yellowBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Commission Model',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _commissionRow(
            '1',
            'First 2 jobs: Free — full payment',
            const Color(0xFF1565C0),
          ),
          const SizedBox(height: 8),
          _commissionRow(
            '%',
            'Job 3 onwards: 10% commission to ServEase',
            AppColors.accentYellow,
          ),
          const SizedBox(height: 8),
          _commissionRow(
            '→',
            'Pay commission to unlock next customer',
            AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _commissionRow(String badge, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    final transactions = _data?.transactions ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction History',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          )
        else
          ...transactions.map((t) => _TransactionCard(transaction: t)).toList(),
      ],
    );
  }

  Widget _buildPayButton() {
    final amount = _data?.commissionDue ?? 0.0;
    if (amount <= 0) return const SizedBox(height: 0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PayCommissionScreen(
              providerId: widget.providerId,
              commissionAmount: amount,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentYellow,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Pay Pending Commission (RS ${_fmt(amount)})',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  String _fmt(dynamic val) {
    final d = val is num ? val.toDouble() : 0.0;
    if (d >= 1000) {
      return d
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return d.toStringAsFixed(0);
  }
}

class _TransactionCard extends StatelessWidget {
  final EarningTransaction transaction;
  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isFree = transaction.isFree;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isFree
                      ? '${transaction.subtitle} · Free'
                      : transaction.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'RS ${transaction.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
