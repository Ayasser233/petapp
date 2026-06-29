import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/controllers/order_controller.dart';

class PaymentProofScreen extends StatefulWidget {
  const PaymentProofScreen({super.key});

  @override
  State<PaymentProofScreen> createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
  late final OrderController _ctrl;
  late final String _orderId;
  final List<File> _images = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _orderId = Get.arguments as String;
    _ctrl = Get.find<OrderController>();
  }

  Future<void> _pickImages() async {
    final l10n = AppLocalizations.of(Get.context!);
    final picks = await _picker.pickMultiImage(imageQuality: 80);
    if (picks.isEmpty) return;
    final total = _images.length + picks.length;
    if (total > 5) {
      Get.snackbar(l10n.paymentProof, l10n.maxFiveImages,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    setState(() => _images.addAll(picks.map((x) => File(x.path))));
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
        title: Text(l10n.paymentProof,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.uploadPaymentScreenshots,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(l10n.oneToFiveImages, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            const SizedBox(height: 20),
            // Image grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: _images.length + (_images.length < 5 ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == _images.length) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                        ),
                        child: const Center(
                          child: Icon(Icons.add_photo_alternate_outlined, color: AppColors.orange, size: 32),
                        ),
                      ),
                    );
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_images[i], fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4, right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _images.removeAt(i)),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
        child: Obx(() => ElevatedButton(
              onPressed: (_images.isEmpty || _ctrl.isActing.value)
                  ? null
                  : () => _ctrl.uploadPaymentProof(_orderId, _images),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: _ctrl.isActing.value
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(l10n.submitProof, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )),
      ),
    );
  }
}
