import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petapp/core/models/country_code.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/validation_utils.dart';
import 'package:petapp/core/styles/input_styles.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, CountryCode)? onChanged;
  final String? hintText;
  final bool isDark;
  final String? Function(String?)? validator;
  
  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Phone Number',
    required this.isDark,
    this.validator,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  CountryCode _selectedCountry = CountryCodes.commonCodes.first;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        prefixIcon: _buildCountryCodeDropdown(),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[400],
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: focusedFieldStyle(),
        focusedBorder: focusedFieldStyle(),
        filled: true,
        fillColor: widget.isDark ? AppColors.lightblack : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        errorStyle: const TextStyle(height: 0.8),
      ),
      validator: widget.validator ?? 
        (value) => ValidationUtils.validatePhone(value, countryCode: _selectedCountry.dialCode),
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value, _selectedCountry);
        }
      },
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: widget.isDark ? Colors.white : Colors.black,
          ),
    );
  }

  Widget _buildCountryCodeDropdown() {
    return GestureDetector(
      onTap: _showCountryCodePicker,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedCountry.flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 4.0),
            Text(
              _selectedCountry.dialCode,
              style: TextStyle(
                fontSize: 14,
                color: widget.isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 24,
              width: 1,
              color: Colors.grey[400],
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CountryCodePicker(
        selectedCountry: _selectedCountry,
        onCountrySelected: (country) {
          setState(() {
            _selectedCountry = country;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(widget.controller.text, country);
          }
          Navigator.pop(context);
        },
        isDark: widget.isDark,
      ),
    );
  }
}

class _CountryCodePicker extends StatefulWidget {
  final CountryCode selectedCountry;
  final Function(CountryCode) onCountrySelected;
  final bool isDark;

  const _CountryCodePicker({
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.isDark,
  });

  @override
  State<_CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<_CountryCodePicker> {
  late List<CountryCode> _filteredCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = CountryCodes.commonCodes;
    _searchController.addListener(() {
      _filterCountries();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = CountryCodes.commonCodes.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.dialCode.contains(query) ||
            country.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : Colors.black;
    final subTextColor = widget.isDark ? Colors.grey[400] : Colors.grey[600];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Country Code',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search country...',
              prefixIcon: Icon(Icons.search, color: subTextColor),
              filled: true,
              fillColor: widget.isDark ? Colors.grey[800] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: textColor),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = widget.selectedCountry.code == country.code;
                
                return ListTile(
                  leading: Text(
                    country.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    country.name,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Text(
                    country.dialCode,
                    style: TextStyle(
                      color: isSelected ? AppColors.orange : subTextColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => widget.onCountrySelected(country),
                  selected: isSelected,
                  selectedColor: AppColors.orange.withOpacity(0.1),
                  selectedTileColor: widget.isDark 
                      ? AppColors.orange.withOpacity(0.1) 
                      : AppColors.orange.withOpacity(0.05),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}