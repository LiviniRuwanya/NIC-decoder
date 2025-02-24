class NicDecoderResult {
  final DateTime birthDate;
  final String gender;
  final String voteEligibility;
  final String format;

  NicDecoderResult({
    required this.birthDate,
    required this.gender,
    required this.voteEligibility,
    required this.format,
  });
}

class NicDecoder {
  static NicDecoderResult? decode(String nic, String nicType) {
    try {
      if (nicType == 'Old NIC') {
        return _decodeOldNic(nic);
      } else {
        return _decodeNewNic(nic);
      }
    } catch (e) {
      return null;
    }
  }

  static NicDecoderResult _decodeOldNic(String nic) {
    // Extract year (first 2 digits)
    int year = int.parse('19${nic.substring(0, 2)}');
    
    // Extract days (next 3 digits)
    int days = int.parse(nic.substring(2, 5));
    
    // Determine gender
    String gender = days > 500 ? 'Female' : 'Male';
    
    // Adjust days for females
    if (days > 500) days -= 500;
    
    // Calculate birth date
    DateTime birthDate = _calculateDate(year, days);
    
    // Check vote eligibility
    String voteEligibility = nic.toLowerCase().endsWith('v') ? 'Eligible' : 'Not Eligible';

    return NicDecoderResult(
      birthDate: birthDate,
      gender: gender,
      voteEligibility: voteEligibility,
      format: 'Old Format',
    );
  }

  static NicDecoderResult _decodeNewNic(String nic) {
    // Extract year (first 4 digits)
    int year = int.parse(nic.substring(0, 4));
    
    // Extract days (next 3 digits)
    int days = int.parse(nic.substring(4, 7));
    
    // Determine gender
    String gender = days > 500 ? 'Female' : 'Male';
    
    // Adjust days for females
    if (days > 500) days -= 500;
    
    // Calculate birth date
    DateTime birthDate = _calculateDate(year, days);

    return NicDecoderResult(
      birthDate: birthDate,
      gender: gender,
      voteEligibility: 'Unknown',
      format: 'New Format',
    );
  }

  static DateTime _calculateDate(int year, int days) {
    // Create January 1st of the given year
    final firstDay = DateTime(year, 1, 1);
    
    // Add the days (subtract 1 because January 1st is day 1)
    final birthDate = firstDay.add(Duration(days: days - 1));
    
    // For verification: April 12, 2000 should be a Wednesday
    // print('Date: ${birthDate.toString()}');
    // print('Weekday: ${birthDate.weekday}'); // 1 = Monday, 3 = Wednesday, etc.
    
    return birthDate;
  }
}
