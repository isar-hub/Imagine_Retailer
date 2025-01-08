import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';

class AddressPicker extends StatelessWidget {
  final Function(String) selectedState;
  final Function(String) selectedCountry;
  final Function(String) selectedCity;
  final String? initialCountry;

  final String? initialState;
  final String? initialCity;

  const AddressPicker(
      {super.key,
      required this.selectedState,
      required this.selectedCountry,
      required this.selectedCity,
      this.initialCountry,
      this.initialState,
      this.initialCity,
      });

  @override
  Widget build(BuildContext context) {
    return CSCPickerPlus(
      showStates: true,
      showCities: true,
      flagState: CountryFlag.ENABLE,
      dropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1)),
      disabledDropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade300, width: 1)),
      countrySearchPlaceholder: initialCountry ?? "Select Country",
      stateSearchPlaceholder: initialState ?? "Select State",
      citySearchPlaceholder: initialCity ?? "Select City",
      countryDropdownLabel: "*Country",
      stateDropdownLabel: "*State",
      cityDropdownLabel: "*City",
      defaultCountry: CscCountry.India,
      selectedItemStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      dropdownHeadingStyle: const TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      dropdownItemStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),

      dropdownDialogRadius: 10.0,
      searchBarRadius: 10.0,

      ///triggers once country selected in dropdown
      onCountryChanged: (value) {
        selectedCountry(value);
      },

      onStateChanged: (value) {
        selectedState(value ?? "");
      },

      onCityChanged: (value) {
        selectedCity(value ?? "");
      },
    );
  }
}
