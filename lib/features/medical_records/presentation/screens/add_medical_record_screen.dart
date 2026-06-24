import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/medical_records/domain/entities/medical_record_entity.dart';
import 'package:petapp/features/medical_records/presentation/cubit/log_medical_record_cubit.dart';
import 'package:petapp/features/medical_records/presentation/cubit/log_medical_record_state.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/di/service_locator.dart';


class AddMedicalRecordScreen extends StatefulWidget {
  final PetModel pet;

  const AddMedicalRecordScreen({super.key, required this.pet});

  @override
  State<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late LogMedicalRecordCubit _cubit;

  MedicalRecordEventType _selectedType = MedicalRecordEventType.HEALTH_EVENT;
  DateTime _selectedDate = DateTime.now();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _customSymptomController = TextEditingController();
  
  final List<String> _commonSymptoms = ['Vomiting', 'Diarrhea', 'Itching', 'Loss of Appetite', 'Lethargy', 'Coughing', 'Limping'];
  final List<String> _selectedSymptoms = [];
  final List<PlatformFile> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _cubit = sl<LogMedicalRecordCubit>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainController.dispose();
    _dosageController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _customSymptomController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles(AppLocalizations l10n) async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          if (_selectedFiles.length + result.files.length > 10) {
            Get.snackbar(l10n.limitReached, l10n.attachLimitMsg, backgroundColor: Colors.orange, colorText: Colors.white);
            _selectedFiles.addAll(result.files.take(10 - _selectedFiles.length));
          } else {
            _selectedFiles.addAll(result.files);
          }
        });
      }
    } catch (e) {
      Get.snackbar(l10n.error, l10n.tryAgain, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.black : Colors.grey[50];
    final textColor = isDark ? Colors.white : Colors.black87;

    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<LogMedicalRecordCubit, LogMedicalRecordState>(
        listener: (context, state) {
          if (state is LogMedicalRecordSuccess) {
            Get.back(result: true);
            Get.snackbar(l10n.success, l10n.recordCreatedSuccessfully, backgroundColor: Colors.green, colorText: Colors.white);
          } else if (state is LogMedicalRecordError) {
            Get.snackbar(l10n.error, state.message, backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(l10n.logHealthEvent, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: isDark ? Colors.black : Colors.white,
            foregroundColor: textColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.selectRecordType, isDark),
                  const SizedBox(height: 16),
                  _buildTypeSelector(isDark, l10n),
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildDynamicFields(isDark, l10n),
                        _buildDatePicker(isDark, l10n),
                        const SizedBox(height: 16),
                        _buildTextField(l10n.locationProvider, 'e.g. City Vet Lab', _locationController, isDark, l10n),
                        const SizedBox(height: 16),
                        _buildTextField(l10n.eventDetails, l10n.addNotes, _notesController, isDark, l10n, maxLines: 4),
                        const SizedBox(height: 24),
                        _buildSectionTitle('${l10n.attachments} (${_selectedFiles.length}/10)', isDark),
                        const SizedBox(height: 12),
                        _buildAttachmentPicker(isDark, l10n),
                        if (_selectedFiles.isNotEmpty) _buildFileList(isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<LogMedicalRecordCubit, LogMedicalRecordState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is LogMedicalRecordLoading ? null : () => _submitForm(l10n),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: state is LogMedicalRecordLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(l10n.saveRecord, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDynamicFields(bool isDark, AppLocalizations l10n) {
    switch (_selectedType) {
      case MedicalRecordEventType.HEALTH_EVENT:
        return [
          _buildSectionTitle(l10n.commonSymptoms, isDark),
          const SizedBox(height: 12),
          _buildSymptomChips(isDark, l10n),
          const SizedBox(height: 16),
          _buildTextField(l10n.customSymptom, l10n.enterPetName, _customSymptomController, isDark, l10n),
          const SizedBox(height: 16),
        ];
      case MedicalRecordEventType.MEDICATION:
        return [
          _buildTextField(l10n.medicationName, l10n.medicationName, _mainController, isDark, l10n, required: true),
          const SizedBox(height: 16),
          _buildTextField(l10n.dosage, 'e.g. 250mg', _dosageController, isDark, l10n),
          const SizedBox(height: 16),
        ];
      case MedicalRecordEventType.NOTE:
        return [
          _buildTextField(l10n.title, l10n.title, _titleController, isDark, l10n),
          const SizedBox(height: 16),
          _buildTextField(l10n.note, l10n.note, _mainController, isDark, l10n, required: true, maxLines: 3),
          const SizedBox(height: 16),
        ];
      case MedicalRecordEventType.VISIT:
        return [
          _buildTextField(l10n.visitType, l10n.visitType, _mainController, isDark, l10n, required: true),
          const SizedBox(height: 16),
        ];
      case MedicalRecordEventType.TEST_LAB_IMAGING:
        return [
          _buildTextField(l10n.testType, l10n.testType, _mainController, isDark, l10n, required: true),
          const SizedBox(height: 16),
        ];
      case MedicalRecordEventType.PROCEDURE_SURGERY:
        return [
          _buildTextField(l10n.procedureName, l10n.procedureName, _mainController, isDark, l10n, required: true),
          const SizedBox(height: 16),
        ];
      case MedicalRecordEventType.VACCINE:
        return [
          _buildTextField(l10n.vaccineTypeLabel, l10n.vaccineTypeLabel, _mainController, isDark, l10n, required: true),
          const SizedBox(height: 16),
          _buildTextField(l10n.category, l10n.category, _dosageController, isDark, l10n),
          const SizedBox(height: 16),
        ];
    }
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white60 : Colors.black54,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildTypeSelector(bool isDark, AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildTypeIcon(l10n.vaccine, Icons.vaccines, MedicalRecordEventType.VACCINE, isDark),
        _buildTypeIcon(l10n.medication, Icons.medical_services, MedicalRecordEventType.MEDICATION, isDark),
        _buildTypeIcon(l10n.visit, Icons.medical_information, MedicalRecordEventType.VISIT, isDark),
        _buildTypeIcon(l10n.lab, Icons.science, MedicalRecordEventType.TEST_LAB_IMAGING, isDark),
        _buildTypeIcon(l10n.event, Icons.warning_amber_rounded, MedicalRecordEventType.HEALTH_EVENT, isDark),
        _buildTypeIcon(l10n.surgeryLabel, Icons.precision_manufacturing, MedicalRecordEventType.PROCEDURE_SURGERY, isDark),
        _buildTypeIcon(l10n.note, Icons.note_alt_outlined, MedicalRecordEventType.NOTE, isDark),
      ],
    );
  }

  Widget _buildTypeIcon(String label, IconData icon, MedicalRecordEventType type, bool isDark) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.orange : (isDark ? Colors.grey[900] : Colors.white),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.orange.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
            ),
            child: Icon(icon, color: isSelected ? Colors.white : (isDark ? Colors.white60 : Colors.black54), size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.orange : (isDark ? Colors.white70 : Colors.black54))),
        ],
      ),
    );
  }

  Widget _buildSymptomChips(bool isDark, AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _commonSymptoms.map((symptom) {
        final isSelected = _selectedSymptoms.contains(symptom);
        return FilterChip(
          label: Text(symptom),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) { _selectedSymptoms.add(symptom); } else { _selectedSymptoms.remove(symptom); }
            });
          },
          selectedColor: AppColors.orange.withValues(alpha: 0.1),
          checkmarkColor: AppColors.orange,
          labelStyle: TextStyle(color: isSelected ? AppColors.orange : (isDark ? Colors.white70 : Colors.black87), fontSize: 12),
          backgroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isSelected ? AppColors.orange : (isDark ? Colors.white12 : Colors.grey[300]!)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, bool isDark, AppLocalizations l10n, {int maxLines = 1, bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label, isDark),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          validator: required ? (value) => value == null || value.isEmpty ? l10n.pleaseEnterValidAge : null : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: isDark ? Colors.black : Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(bool isDark, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.dateOfEvent, isDark),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.orange, // Header and selected circle color
                      onPrimary: Colors.white, // Text color on top of primary
                      surface: isDark ? Colors.grey[900]! : Colors.white, // Background of dialog
                      onSurface: isDark ? Colors.white : Colors.black, // Normal day numbers color
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.orange, // OK/Cancel button color
                      ),
                    ), dialogTheme: DialogThemeData(backgroundColor: isDark ? Colors.grey[900] : Colors.white),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: isDark ? Colors.black : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MM/dd/yyyy').format(_selectedDate), style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                Icon(Icons.calendar_today, size: 18, color: isDark ? Colors.white38 : Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentPicker(bool isDark, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _pickFiles(l10n),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white12 : Colors.grey[300]!, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.cyanAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.cloud_upload_outlined, color: Colors.cyan, size: 32),
            ),
            const SizedBox(height: 12),
            Text(l10n.uploadImages.replaceAll('images', 'files'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text('JPG, PNG, PDF up to 10MB', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _selectedFiles.length,
          itemBuilder: (context, index) {
            final file = _selectedFiles[index];
            final isImage = ['jpg', 'jpeg', 'png'].contains(file.extension?.toLowerCase());

            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 90, height: 100,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black45 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isImage && file.path != null
                        ? Image.file(File(file.path!), fit: BoxFit.cover)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                file.extension?.toLowerCase() == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file,
                                color: file.extension?.toLowerCase() == 'pdf' ? Colors.red : Colors.blue,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  file.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Positioned(
                  right: 4, top: 0,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFiles.removeAt(index)),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.9), shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _submitForm(AppLocalizations l10n) {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> payload = {};
    
    switch (_selectedType) {
      case MedicalRecordEventType.HEALTH_EVENT:
        payload['eventName'] = _selectedSymptoms.join(', ') + (_customSymptomController.text.isNotEmpty ? ', ${_customSymptomController.text}' : '');
        if (payload['eventName'].isEmpty) {
          Get.snackbar(l10n.inputRequired, l10n.selectSymptomPrompt, backgroundColor: Colors.orange, colorText: Colors.white);
          return;
        }
        payload['notes'] = _notesController.text;
        break;
      case MedicalRecordEventType.NOTE:
        payload['text'] = _mainController.text;
        payload['title'] = _titleController.text.isNotEmpty ? _titleController.text : l10n.note;
        break;
      case MedicalRecordEventType.MEDICATION:
        payload['medicationName'] = _mainController.text;
        payload['dosage'] = _dosageController.text;
        payload['instructions'] = _notesController.text;
        break;
      case MedicalRecordEventType.VISIT:
        payload['visitType'] = _mainController.text;
        payload['summary'] = _notesController.text;
        break;
      case MedicalRecordEventType.TEST_LAB_IMAGING:
        payload['testType'] = _mainController.text;
        payload['resultSummary'] = _notesController.text;
        break;
      case MedicalRecordEventType.PROCEDURE_SURGERY:
        payload['procedureName'] = _mainController.text;
        payload['notes'] = _notesController.text;
        break;
      case MedicalRecordEventType.VACCINE:
        payload['vaccineType'] = _mainController.text;
        payload['vaccineCategory'] = _dosageController.text;
        payload['notes'] = _notesController.text;
        break;
    }

    if (_locationController.text.isNotEmpty) { payload['location'] = _locationController.text; }

    _cubit.createRecord(
      petId: widget.pet.id,
      eventType: _selectedType,
      payload: payload,
      occurredAt: _selectedDate,
      files: _selectedFiles.map((file) => file.path!).toList(),
    );
  }
}
