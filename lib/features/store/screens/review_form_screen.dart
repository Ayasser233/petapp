import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/controllers/review_controller.dart';
import 'package:petapp/features/store/widgets/star_rating_widget.dart';

class ReviewFormScreen extends StatefulWidget {
  const ReviewFormScreen({super.key});

  @override
  State<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  late final ReviewController _ctrl;
  late final String _productId;
  late final String _orderId;

  int _rating = 5;
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, String>;
    _productId = args['productId']!;
    _orderId = args['orderId']!;
    _ctrl = Get.find<ReviewController>();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(l10n.writeAReview,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          Text(l10n.yourRating,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          StarRatingWidget(
            rating: _rating,
            onChanged: (v) => setState(() => _rating = v),
            size: 38,
          ),
          const SizedBox(height: 24),
          Text(l10n.reviewTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            maxLength: 255,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: l10n.reviewTitleHint,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: isDark ? AppColors.lightblack : Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.reviewBodyOptional,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _bodyCtrl,
            maxLines: 5,
            maxLength: 5000,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: l10n.shareExperienceHint,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: isDark ? AppColors.lightblack : Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
              counterText: '',
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
        child: Obx(() => ElevatedButton(
              onPressed: (_ctrl.isSubmitting.value || _titleCtrl.text.trim().isEmpty)
                  ? null
                  : () => _ctrl.submitReview(
                        productId: _productId,
                        orderId: _orderId,
                        rating: _rating,
                        title: _titleCtrl.text.trim(),
                        body: _bodyCtrl.text.trim().isEmpty ? null : _bodyCtrl.text.trim(),
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: _ctrl.isSubmitting.value
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(l10n.submitReview, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )),
      ),
    );
  }
}