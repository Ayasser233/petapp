import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/vets/models/review_model.dart';
import 'package:petapp/features/vets/services/vet_service.dart';

class AllReviewsScreen extends StatefulWidget {
  final String vetId;
  final String vetName;

  const AllReviewsScreen({
    super.key,
    required this.vetId,
    this.vetName = '',
  });

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  final VetService _vetService = VetService();
  final ScrollController _scrollController = ScrollController();

  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalReviews = 0;
  static const int _pageSize = 10;

  double get _overallRating {
    if (_reviews.isEmpty) return 0.0;
    final sum = _reviews.fold<double>(0.0, (s, r) => s + r.rating);
    return sum / _reviews.length;
  }

  @override
  void initState() {
    super.initState();
    _loadPage(1);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadPage(int page) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final response = await _vetService.getVetReviews(
        widget.vetId,
        page: page,
        limit: _pageSize,
      );
      setState(() {
        if (page == 1) {
          _reviews = response.reviews;
        } else {
          _reviews = [..._reviews, ...response.reviews];
        }
        _currentPage = response.page;
        _totalPages = response.totalPages;
        _totalReviews = response.total;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;
    setState(() => _isLoadingMore = true);
    try {
      final nextPage = _currentPage + 1;
      final response = await _vetService.getVetReviews(
        widget.vetId,
        page: nextPage,
        limit: _pageSize,
      );
      setState(() {
        _reviews = [..._reviews, ...response.reviews];
        _currentPage = response.page;
        _totalPages = response.totalPages;
        _totalReviews = response.total;
        _isLoadingMore = false;
      });
    } catch (_) {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _refresh() => _loadPage(1);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : Colors.black87);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final dividerColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vetName.isNotEmpty
              ? "${widget.vetName} – Reviews"
              : "Owner's Reviews",
        ),
        centerTitle: true,
      ),
      body: _isLoading && _reviews.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            )
          : RefreshIndicator(
              color: AppColors.orange,
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // ── Rating Summary ──────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        children: [
                          Text(
                            'Overall Rating from $_totalReviews Visitors',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: subTextColor),
                          ),
                          const SizedBox(height: 12),
                          _buildRatingCard(context, isDark, theme),
                          const SizedBox(height: 16),
                          Divider(color: dividerColor),
                        ],
                      ),
                    ),
                  ),

                  // ── Reviews List ────────────────────────────────
                  if (_reviews.isEmpty && !_isLoading)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.rate_review_outlined,
                                size: 48, color: subTextColor),
                            const SizedBox(height: 12),
                            Text(
                              'No reviews yet',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: subTextColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < _reviews.length) {
                            return Column(
                              children: [
                                _ReviewItem(
                                  review: _reviews[index],
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                if (index < _reviews.length - 1)
                                  Divider(height: 1, color: dividerColor),
                              ],
                            );
                          }
                          return null;
                        },
                        childCount: _reviews.length,
                      ),
                    ),

                  // ── Load More indicator ─────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (_isLoadingMore)
                            const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.orange),
                            )
                          else if (_currentPage < _totalPages)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.orange,
                                  side: const BorderSide(
                                      color: AppColors.orange, width: 1.5),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _loadMore,
                                child: const Text(
                                  'Load More',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRatingCard(BuildContext context, bool isDark, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Column(
        children: [
          Text(
            _overallRating.toStringAsFixed(1),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
            ),
          ),
          const SizedBox(height: 6),
          _StarRating(rating: _overallRating, size: 24, isDark: isDark),
          const SizedBox(height: 8),
          Text(
            'Overall Rating',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual Review Item ─────────────────────────────────────────────────────
class _ReviewItem extends StatelessWidget {
  final ReviewModel review;
  final Color textColor;
  final Color subTextColor;

  const _ReviewItem({
    super.key,
    required this.review,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars + label
          Row(
            children: [
              _StarRating(
                  rating: review.rating,
                  size: 18,
                  isDark: THelperFunctions.isDarkMode(context)),
              const SizedBox(width: 8),
              Text(
                'Overall Rating',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subTextColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (review.comment.isNotEmpty)
            Text(
              '"${review.comment}"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    height: 1.5,
                  ),
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                review.userName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('d MMMM yyyy').format(review.createdAt),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: subTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Star Rating ────────────────────────────────────────────────────────────────
class _StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool isDark;

  const _StarRating(
      {required this.rating, this.size = 18, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final halfFilled = !filled && (i < rating);
        return Icon(
          halfFilled
              ? Icons.star_half
              : (filled ? Icons.star : Icons.star_border),
          color: (filled || halfFilled)
              ? AppColors.orange
              : (isDark ? Colors.grey[600] : Colors.grey[400]),
          size: size,
        );
      }),
    );
  }
}
