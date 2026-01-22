import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:petapp/features/appointments/presentation/widgets/appointment_dialogs.dart';

class SubmitReviewScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const SubmitReviewScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0) {
      AppointmentDialogs.showErrorSnackBar(
        context,
        AppLocalizations.of(context).pleaseSelectRating,
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      AppointmentDialogs.showErrorSnackBar(
        context,
        AppLocalizations.of(context).pleaseEnterReviewComment,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    context.read<AppointmentsCubit>().submitReview(
          appointmentId: widget.appointment.id,
          rating: _rating,
          comment: _commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        if (state is AppointmentActionSuccess && state.action == 'review') {
          AppointmentDialogs.showSuccessSnackBar(
            context,
            AppLocalizations.of(context).reviewSubmittedSuccessfully,
          );
          Navigator.of(context).pop(true);
        } else if (state is AppointmentsError) {
          setState(() {
            _isSubmitting = false;
          });
          AppointmentDialogs.showErrorSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).leaveAReview),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vet Information Card
              _buildVetInfoCard(),
              const SizedBox(height: 24),

              // Rating Section
              _buildRatingSection(),
              const SizedBox(height: 24),

              // Comment Section
              _buildCommentSection(),
              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVetInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.orange.withValues(alpha: 0.2),
              child: const Icon(
                Icons.local_hospital,
                color: AppColors.orange,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.appointment.vet?.branchName ??
                        AppLocalizations.of(context).veterinaryClinic,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.appointment.reasonForVisit ??
                        AppLocalizations.of(context).appointment,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).howWasYourExperience,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : () {
                        setState(() {
                          _rating = starValue;
                        });
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    starValue <= _rating ? Icons.star : Icons.star_border,
                    color: AppColors.orange,
                    size: 48,
                  ),
                ),
              );
            }),
          ),
        ),
        if (_rating > 0)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _getRatingText(_rating),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
      ],
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return AppLocalizations.of(context).ratingPoor;
      case 2:
        return AppLocalizations.of(context).ratingFair;
      case 3:
        return AppLocalizations.of(context).ratingGood;
      case 4:
        return AppLocalizations.of(context).ratingVeryGood;
      case 5:
        return AppLocalizations.of(context).ratingExcellent;
      default:
        return '';
    }
  }

  Widget _buildCommentSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).shareYourExperience,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _commentController,
          enabled: !_isSubmitting,
          maxLines: 6,
          maxLength: 500,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).tellUsAboutExperience,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.orange, width: 2),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
            counterStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).submitReview,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
