import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:petapp/features/appointments/presentation/widgets/appointment_dialogs.dart';

/// Screen for scanning vet's QR code to complete appointment
class QrScannerScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const QrScannerScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQrScanned(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? qrCode = barcodes.first.rawValue;
    if (qrCode == null || qrCode.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    print('🔍 QR Code scanned: $qrCode');

    // Complete appointment using the scanned QR code
    context.read<AppointmentsCubit>().completeAppointmentByQr(
          appointmentId: widget.appointment.id,
          qrCode: qrCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          AppLocalizations.of(context).scanQrCode,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () {
              _controller.toggleTorch();
              setState(() {});
            },
          ),
        ],
      ),
      body: BlocListener<AppointmentsCubit, AppointmentsState>(
        listener: (context, state) {
          if (state is AppointmentActionSuccess &&
              state.action == 'complete-qr') {
            // Show success message
            AppointmentDialogs.showSuccessSnackBar(
              context,
              AppLocalizations.of(context).appointmentCompletedSuccessfully,
            );

            // Navigate back and refresh appointments
            Navigator.of(context).pop(true);
          } else if (state is AppointmentsError) {
            // Show error message
            AppointmentDialogs.showErrorSnackBar(context, state.message);

            // Reset processing state to allow retry
            setState(() {
              _isProcessing = false;
            });
          }
        },
        child: Stack(
          children: [
            // Camera view
            MobileScanner(
              controller: _controller,
              onDetect: _onQrScanned,
            ),

            // Overlay with scanning area
            _buildScanOverlay(context),

            // Instructions
            _buildInstructions(context),

            // Loading indicator
            if (_isProcessing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOverlay(BuildContext context) {
    return CustomPaint(
      painter: ScannerOverlayPainter(),
      child: Container(),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              color: AppColors.orange,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).scanVetQrCodeToComplete,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).pointCameraAtQrCode,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    // Draw dark overlay except scan area
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
          const Radius.circular(20),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      path,
      Paint()..color = Colors.black.withOpacity(0.7),
    );

    // Draw scan area border
    final Paint borderPaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
        const Radius.circular(20),
      ),
      borderPaint,
    );

    // Draw corner markers
    final double cornerLength = 30;
    final double cornerWidth = 4;
    final Paint cornerPaint = Paint()
      ..color = AppColors.orange
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize - cornerLength, top),
      Offset(left + scanAreaSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize, top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + scanAreaSize - cornerLength),
      Offset(left, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left + cornerLength, top + scanAreaSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
      Offset(left + scanAreaSize, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
      Offset(left + scanAreaSize, top + scanAreaSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
