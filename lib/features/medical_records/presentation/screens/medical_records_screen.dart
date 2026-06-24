import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/medical_records/domain/entities/medical_record_entity.dart';
import 'package:petapp/features/medical_records/presentation/cubit/medical_records_cubit.dart';
import 'package:petapp/features/medical_records/presentation/cubit/medical_records_state.dart';
import 'package:petapp/features/medical_records/presentation/screens/add_medical_record_screen.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/di/service_locator.dart';

class MedicalRecordsScreen extends StatefulWidget {
  final PetModel pet;

  const MedicalRecordsScreen({super.key, required this.pet});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final ScrollController _scrollController = ScrollController();
  late MedicalRecordsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MedicalRecordsCubit>();
    _cubit.loadMedicalRecords(widget.pet.id, refresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
        _cubit.loadMedicalRecords(widget.pet.id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(l10n.medicalRecords, style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: AppColors.orange),
              onPressed: () => _onSharePressed(context, l10n),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.orange),
              onPressed: () async {
                final result = await Get.to(() => AddMedicalRecordScreen(pet: widget.pet));
                if (result == true) {
                  _cubit.loadMedicalRecords(widget.pet.id, refresh: true);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildFilterChips(isDark, l10n),
            Expanded(
              child: BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
                builder: (context, state) {
                  if (state is MedicalRecordsLoading && state.isFirstFetch) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.orange));
                  }

                  if (state is MedicalRecordsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message, style: TextStyle(color: textColor)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _cubit.loadMedicalRecords(widget.pet.id, refresh: true),
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is MedicalRecordsLoaded) {
                    if (state.records.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(l10n.noResultsFound, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      );
                    }

                    return _buildTimeline(state.records, isDark, l10n);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context, bool isDark, AppLocalizations l10n) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: Colors.white,
              surface: isDark ? Colors.grey[900]! : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
            ), dialogTheme: DialogThemeData(backgroundColor: isDark ? Colors.grey[900] : Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _cubit.filterByDateRange(widget.pet.id, picked.start, picked.end);
    }
  }

  void _onSharePressed(BuildContext context, AppLocalizations l10n) async {
    // Show a loading indicator while generating the link
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.orange)),
    );

    try {
      final shareData = await _cubit.generateShareLink(widget.pet.id);
      
      // Close the loading dialog
      if (context.mounted) Navigator.pop(context);

      if (shareData != null && shareData['shareUrl'] != null) {
        final String url = shareData['shareUrl'];
        await SharePlus.instance.share(
          ShareParams(
            text: 'Check out ${widget.pet.name}\'s medical records on Aleefy: $url',
            subject: '${widget.pet.name}\'s Medical Records',
          )

        );
      } else {
        if (context.mounted) {
          Get.snackbar(l10n.error, l10n.tryAgain, backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Close dialog on error
      Get.snackbar(l10n.error, l10n.tryAgain, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Widget _buildFilterChips(bool isDark, AppLocalizations l10n) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
        builder: (context, state) {
          final currentFilter = state is MedicalRecordsLoaded ? state.currentFilter : null;
          final fromDate = state is MedicalRecordsLoaded ? state.fromDate : null;
          final toDate = state is MedicalRecordsLoaded ? state.toDate : null;
          final hasDateFilter = fromDate != null || toDate != null;

          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Date Range Picker Button
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: ActionChip(
                  avatar: Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: hasDateFilter ? Colors.white : AppColors.orange,
                  ),
                  label: Text(
                    hasDateFilter
                        ? '${DateFormat('MM/dd').format(fromDate!)} - ${DateFormat('MM/dd').format(toDate!)}'
                        : l10n.selectDate,
                  ),
                  onPressed: () => _showDateRangePicker(context, isDark, l10n),
                  backgroundColor: hasDateFilter ? AppColors.orange : (isDark ? Colors.grey[900] : Colors.grey[200]),
                  labelStyle: TextStyle(
                    color: hasDateFilter ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              if (hasDateFilter)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: const Icon(Icons.close, size: 16, color: Colors.red),
                    onPressed: () => _cubit.filterByDateRange(widget.pet.id, null, null),
                    backgroundColor: isDark ? Colors.grey[900] : Colors.grey[200],
                    shape: const CircleBorder(),
                  ),
                ),
              VerticalDivider(indent: 10, endIndent: 10, color: Colors.grey[400]),
              _buildChip(l10n.all, null, currentFilter == null, isDark),
              _buildChip(l10n.vaccine, MedicalRecordEventType.VACCINE, currentFilter == MedicalRecordEventType.VACCINE, isDark),
              _buildChip(l10n.medication, MedicalRecordEventType.MEDICATION, currentFilter == MedicalRecordEventType.MEDICATION, isDark),
              _buildChip(l10n.visit, MedicalRecordEventType.VISIT, currentFilter == MedicalRecordEventType.VISIT, isDark),
              _buildChip(l10n.lab, MedicalRecordEventType.TEST_LAB_IMAGING, currentFilter == MedicalRecordEventType.TEST_LAB_IMAGING, isDark),
              _buildChip(l10n.surgeryLabel, MedicalRecordEventType.PROCEDURE_SURGERY, currentFilter == MedicalRecordEventType.PROCEDURE_SURGERY, isDark),
              _buildChip(l10n.event, MedicalRecordEventType.HEALTH_EVENT, currentFilter == MedicalRecordEventType.HEALTH_EVENT, isDark),
              _buildChip(l10n.note, MedicalRecordEventType.NOTE, currentFilter == MedicalRecordEventType.NOTE, isDark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChip(String label, MedicalRecordEventType? filter, bool isSelected, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            _cubit.filterByEventType(widget.pet.id, filter);
          }
        },
        selectedColor: AppColors.orange,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildTimeline(List<MedicalRecordEntity> records, bool isDark, AppLocalizations l10n) {
    final Map<String, List<MedicalRecordEntity>> groupedRecords = {};
    for (var record in records) {
      final key = DateFormat('MMMM yyyy', l10n.locale.languageCode).format(record.occurredAt).toUpperCase();
      if (!groupedRecords.containsKey(key)) {
        groupedRecords[key] = [];
      }
      groupedRecords[key]!.add(record);
    }

    final keys = groupedRecords.keys.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final monthKey = keys[index];
        final monthRecords = groupedRecords[monthKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(
                monthKey,
                style: const TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 13,
                ),
              ),
            ),
            ...monthRecords.map((record) => _buildRecordCard(record, isDark, l10n)),
          ],
        );
      },
    );
  }

  Widget _buildRecordCard(MedicalRecordEntity record, bool isDark, AppLocalizations l10n) {
    final Color cardColor = isDark ? Colors.grey[900]! : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;

    final IconData icon = _getIconForEventType(record.eventType);
    final Color iconColor = _getColorForEventType(record.eventType);

    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () => _showRecordDetails(record, l10n, isDark),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
              Container(width: 2, height: 20, color: Colors.grey[300]),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor, width: 2),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Expanded(child: Container(width: 2, color: Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                border: Border(left: BorderSide(color: iconColor, width: 4), right: BorderSide(color: iconColor, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _getRecordTitle(record, l10n),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, hh:mm a', l10n.locale.languageCode).format(record.occurredAt),
                        style: TextStyle(fontSize: 12, color: subTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getRecordSummary(record, l10n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: subTextColor, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  if (_getRecordLocation(record) != null)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: subTextColor),
                        const SizedBox(width: 4),
                        Text(
                          _getRecordLocation(record)!,
                          style: TextStyle(fontSize: 12, color: subTextColor),
                        ),
                      ],
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

  void _showRecordDetails(MedicalRecordEntity record, AppLocalizations l10n, bool isDark) {
    final icon = _getIconForEventType(record.eventType);
    final color = _getColorForEventType(record.eventType);
    final payload = record.payload;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(icon, color: color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getRecordTitle(record, l10n), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(DateFormat('MMMM dd, yyyy - hh:mm a', l10n.locale.languageCode).format(record.occurredAt), style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 48),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem(l10n.status, record.source.name.capitalizeFirst!, Icons.info_outline, isDark),
                    if (_getRecordLocation(record) != null)
                      _buildDetailItem(l10n.locationProvider, _getRecordLocation(record)!, Icons.location_on_outlined, isDark),
                    
                    const SizedBox(height: 16),
                    Text(l10n.eventDetails.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
                    const SizedBox(height: 12),
                    
                    ..._buildDynamicDetailsFields(record, l10n, isDark),

                    if (_getRecordNotes(record) != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: isDark ? Colors.black26 : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                        child: Text(_getRecordNotes(record)!, style: const TextStyle(fontSize: 15, height: 1.5)),
                      ),
                    ],

                    const SizedBox(height: 32),
                    if (payload['attachments'] != null || payload['prescriptionImageUrls'] != null) ...[
                       Text(l10n.attachments.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
                       const SizedBox(height: 16),
                       _buildAttachmentList(payload['attachments'] ?? payload['prescriptionImageUrls'], isDark),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.orange),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicDetailsFields(MedicalRecordEntity record, AppLocalizations l10n, bool isDark) {
    final payload = record.payload;
    switch (record.eventType) {
      case MedicalRecordEventType.MEDICATION:
        return [_buildDetailItem(l10n.dosage, payload['dosage'] ?? 'N/A', Icons.scale_outlined, isDark)];
      case MedicalRecordEventType.VACCINE:
        return [_buildDetailItem(l10n.category, payload['vaccineCategory'] ?? 'N/A', Icons.category_outlined, isDark)];
      case MedicalRecordEventType.VISIT:
        return [if (payload['visitType'] != null) _buildDetailItem(l10n.visitType, payload['visitType'], Icons.medical_services_outlined, isDark)];
      case MedicalRecordEventType.TEST_LAB_IMAGING:
        return [if (payload['testType'] != null) _buildDetailItem(l10n.testType, payload['testType'], Icons.science_outlined, isDark)];
      case MedicalRecordEventType.PROCEDURE_SURGERY:
        return [if (payload['procedureName'] != null) _buildDetailItem(l10n.procedureName, payload['procedureName'], Icons.precision_manufacturing_outlined, isDark)];
      default: return [];
    }
  }

  Widget _buildAttachmentList(dynamic attachments, bool isDark) {
    final List<dynamic> list = attachments is List ? attachments : [];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          String url = list[index].toString();
          
          // Use the central image resolution logic
          url = _resolveImageUrl(url);
          
          final isPdf = url.toLowerCase().contains('.pdf');
          
          return GestureDetector(
            onTap: () => _showFullScreenImage(url, isPdf),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 100,
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isPdf 
                  ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32), const SizedBox(height: 8), Text('PDF', style: TextStyle(fontSize: 10, color: Colors.grey[500]))])
                  : CachedNetworkImage(
                      imageUrl: url, 
                      fit: BoxFit.cover, 
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.orange)),
                      errorWidget: (c, e, s) => const Icon(Icons.broken_image_outlined, color: Colors.grey),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _resolveImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // MinIO base for this project
    const minioBaseUrl = 'https://minio-api.aleefy-app.com/uploads';
    String cleanPath = path;

    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }
    
    if (cleanPath.startsWith('api/')) {
      return 'https://api.aleefy-app.com/$cleanPath';
    }

    // Medical records are specifically stored in the 'medical-records/' subfolder
    if (!cleanPath.startsWith('medical-records/')) {
      cleanPath = 'medical-records/$cleanPath';
    }

    return '$minioBaseUrl/$cleanPath';
  }

  void _showFullScreenImage(String url, bool isPdf) {
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: Center(
          child: isPdf
              ? SfPdfViewer.network(
                  url,
                  canShowScrollHead: true,
                  canShowPaginationDialog: true,
                )
              : InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const CircularProgressIndicator(color: AppColors.orange),
                    errorWidget: (c, e, s) => const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
                  ),
                ),
        ),
      ),
    );
  }

  String? _getRecordNotes(MedicalRecordEntity record) {
    final payload = record.payload;
    return payload['notes'] ?? payload['summary'] ?? payload['text'] ?? payload['instructions'] ?? payload['resultSummary'];
  }

  IconData _getIconForEventType(MedicalRecordEventType type) {
    switch (type) {
      case MedicalRecordEventType.VACCINE: return Icons.vaccines;
      case MedicalRecordEventType.MEDICATION: return Icons.medical_services;
      case MedicalRecordEventType.VISIT: return Icons.medical_information;
      case MedicalRecordEventType.TEST_LAB_IMAGING: return Icons.science;
      case MedicalRecordEventType.PROCEDURE_SURGERY: return Icons.precision_manufacturing;
      case MedicalRecordEventType.HEALTH_EVENT: return Icons.warning_amber_rounded;
      case MedicalRecordEventType.NOTE: return Icons.note_alt_outlined;
    }
  }

  Color _getColorForEventType(MedicalRecordEventType type) {
    switch (type) {
      case MedicalRecordEventType.VACCINE: return Colors.teal;
      case MedicalRecordEventType.MEDICATION: return Colors.orange;
      case MedicalRecordEventType.VISIT: return Colors.blue;
      case MedicalRecordEventType.TEST_LAB_IMAGING: return Colors.purple;
      case MedicalRecordEventType.PROCEDURE_SURGERY: return Colors.indigo;
      case MedicalRecordEventType.HEALTH_EVENT: return Colors.redAccent;
      case MedicalRecordEventType.NOTE: return Colors.brown;
    }
  }

  String _getRecordTitle(MedicalRecordEntity record, AppLocalizations l10n) {
    final payload = record.payload;
    switch (record.eventType) {
      case MedicalRecordEventType.NOTE: return payload['title'] ?? l10n.note;
      case MedicalRecordEventType.HEALTH_EVENT: return payload['eventName'] ?? payload['customEvent'] ?? l10n.event;
      case MedicalRecordEventType.MEDICATION: return payload['medicationName'] ?? l10n.medication;
      case MedicalRecordEventType.VISIT: return payload['visitType'] ?? l10n.visit;
      case MedicalRecordEventType.TEST_LAB_IMAGING: return payload['testType'] ?? l10n.lab;
      case MedicalRecordEventType.PROCEDURE_SURGERY: return payload['procedureName'] ?? payload['customProcedure'] ?? l10n.surgeryLabel;
      case MedicalRecordEventType.VACCINE: return '${payload['vaccineType'] ?? l10n.vaccine}';
    }
  }

  String _getRecordSummary(MedicalRecordEntity record, AppLocalizations l10n) {
    final payload = record.payload;
    switch (record.eventType) {
      case MedicalRecordEventType.NOTE: return payload['text'] ?? '';
      case MedicalRecordEventType.HEALTH_EVENT: return payload['notes'] ?? '';
      case MedicalRecordEventType.MEDICATION: return '${l10n.dosage}: ${payload['dosage'] ?? 'N/A'}. ${payload['instructions'] ?? ''}';
      case MedicalRecordEventType.VISIT: return payload['summary'] ?? payload['diagnosis'] ?? '';
      case MedicalRecordEventType.TEST_LAB_IMAGING: return payload['resultSummary'] ?? '';
      case MedicalRecordEventType.PROCEDURE_SURGERY: return payload['notes'] ?? '';
      case MedicalRecordEventType.VACCINE: return payload['notes'] ?? '';
    }
  }

  String? _getRecordLocation(MedicalRecordEntity record) {
    final payload = record.payload;
    return payload['location'] ?? payload['provider'] ?? payload['clinicName'];
  }
}
