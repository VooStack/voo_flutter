import 'package:equatable/equatable.dart';

/// Country code entity for phone number formatting
class CountryCode extends Equatable {
  /// ISO 3166-1 alpha-2 country code (e.g., 'US', 'GB')
  final String isoCode;

  /// Country dial code (e.g., '+1', '+44')
  final String dialCode;

  /// Country name (e.g., 'United States', 'United Kingdom')
  final String name;

  /// Country flag emoji (e.g., '🇺🇸', '🇬🇧')
  final String flag;

  /// Phone number format pattern (e.g., '(XXX) XXX-XXXX' for US)
  final String format;

  /// Phone number length (excluding country code)
  final int phoneLength;

  /// Example phone number for placeholder
  final String example;

  const CountryCode({
    required this.isoCode,
    required this.dialCode,
    required this.name,
    required this.flag,
    required this.format,
    required this.phoneLength,
    required this.example,
  });

  @override
  List<Object?> get props => [isoCode, dialCode, name, flag, format, phoneLength, example];

  /// Common country codes with their details
  static const List<CountryCode> allCountries = [
    CountryCode(isoCode: 'US', dialCode: '+1', name: 'United States', flag: '🇺🇸', format: '(XXX) XXX-XXXX', phoneLength: 10, example: '(555) 123-4567'),
    CountryCode(isoCode: 'GB', dialCode: '+44', name: 'United Kingdom', flag: '🇬🇧', format: 'XXXX XXXXXX', phoneLength: 10, example: '7911 123456'),
    CountryCode(isoCode: 'CA', dialCode: '+1', name: 'Canada', flag: '🇨🇦', format: '(XXX) XXX-XXXX', phoneLength: 10, example: '(416) 555-0123'),
    CountryCode(isoCode: 'AU', dialCode: '+61', name: 'Australia', flag: '🇦🇺', format: 'XXXX XXX XXX', phoneLength: 9, example: '0412 345 678'),
    CountryCode(isoCode: 'DE', dialCode: '+49', name: 'Germany', flag: '🇩🇪', format: 'XXX XXXXXXXX', phoneLength: 11, example: '030 12345678'),
    CountryCode(isoCode: 'FR', dialCode: '+33', name: 'France', flag: '🇫🇷', format: 'X XX XX XX XX', phoneLength: 9, example: '6 12 34 56 78'),
    CountryCode(isoCode: 'IT', dialCode: '+39', name: 'Italy', flag: '🇮🇹', format: 'XXX XXX XXXX', phoneLength: 10, example: '312 345 6789'),
    CountryCode(isoCode: 'ES', dialCode: '+34', name: 'Spain', flag: '🇪🇸', format: 'XXX XX XX XX', phoneLength: 9, example: '612 34 56 78'),
    CountryCode(isoCode: 'MX', dialCode: '+52', name: 'Mexico', flag: '🇲🇽', format: 'XX XXXX XXXX', phoneLength: 10, example: '55 1234 5678'),
    CountryCode(isoCode: 'BR', dialCode: '+55', name: 'Brazil', flag: '🇧🇷', format: '(XX) XXXXX-XXXX', phoneLength: 11, example: '(11) 91234-5678'),
    CountryCode(isoCode: 'JP', dialCode: '+81', name: 'Japan', flag: '🇯🇵', format: 'XX-XXXX-XXXX', phoneLength: 10, example: '90-1234-5678'),
    CountryCode(isoCode: 'CN', dialCode: '+86', name: 'China', flag: '🇨🇳', format: 'XXX XXXX XXXX', phoneLength: 11, example: '138 0013 8000'),
    CountryCode(isoCode: 'IN', dialCode: '+91', name: 'India', flag: '🇮🇳', format: 'XXXXX XXXXX', phoneLength: 10, example: '98765 43210'),
    CountryCode(isoCode: 'RU', dialCode: '+7', name: 'Russia', flag: '🇷🇺', format: 'XXX XXX-XX-XX', phoneLength: 10, example: '912 345-67-89'),
    CountryCode(isoCode: 'ZA', dialCode: '+27', name: 'South Africa', flag: '🇿🇦', format: 'XX XXX XXXX', phoneLength: 9, example: '71 234 5678'),
    CountryCode(isoCode: 'NG', dialCode: '+234', name: 'Nigeria', flag: '🇳🇬', format: 'XXX XXX XXXX', phoneLength: 10, example: '802 123 4567'),
    CountryCode(isoCode: 'EG', dialCode: '+20', name: 'Egypt', flag: '🇪🇬', format: 'XX XXXX XXXX', phoneLength: 10, example: '10 1234 5678'),
    CountryCode(isoCode: 'KR', dialCode: '+82', name: 'South Korea', flag: '🇰🇷', format: 'XX-XXXX-XXXX', phoneLength: 10, example: '10-1234-5678'),
    CountryCode(isoCode: 'TH', dialCode: '+66', name: 'Thailand', flag: '🇹🇭', format: 'XX XXX XXXX', phoneLength: 9, example: '81 234 5678'),
    CountryCode(isoCode: 'VN', dialCode: '+84', name: 'Vietnam', flag: '🇻🇳', format: 'XX XXX XXXX', phoneLength: 9, example: '91 234 5678'),
    CountryCode(isoCode: 'PH', dialCode: '+63', name: 'Philippines', flag: '🇵🇭', format: 'XXX XXX XXXX', phoneLength: 10, example: '917 123 4567'),
    CountryCode(isoCode: 'ID', dialCode: '+62', name: 'Indonesia', flag: '🇮🇩', format: 'XXX-XXX-XXXX', phoneLength: 10, example: '812-345-6789'),
    CountryCode(isoCode: 'MY', dialCode: '+60', name: 'Malaysia', flag: '🇲🇾', format: 'XX-XXX XXXX', phoneLength: 9, example: '12-345 6789'),
    CountryCode(isoCode: 'SG', dialCode: '+65', name: 'Singapore', flag: '🇸🇬', format: 'XXXX XXXX', phoneLength: 8, example: '9123 4567'),
    CountryCode(isoCode: 'NZ', dialCode: '+64', name: 'New Zealand', flag: '🇳🇿', format: 'XX XXX XXXX', phoneLength: 9, example: '21 123 4567'),
    CountryCode(isoCode: 'AR', dialCode: '+54', name: 'Argentina', flag: '🇦🇷', format: 'XX XXXX-XXXX', phoneLength: 10, example: '11 1234-5678'),
    CountryCode(isoCode: 'CL', dialCode: '+56', name: 'Chile', flag: '🇨🇱', format: 'X XXXX XXXX', phoneLength: 9, example: '9 1234 5678'),
    CountryCode(isoCode: 'CO', dialCode: '+57', name: 'Colombia', flag: '🇨🇴', format: 'XXX XXX XXXX', phoneLength: 10, example: '301 234 5678'),
    CountryCode(isoCode: 'PE', dialCode: '+51', name: 'Peru', flag: '🇵🇪', format: 'XXX XXX XXX', phoneLength: 9, example: '912 345 678'),
    CountryCode(isoCode: 'VE', dialCode: '+58', name: 'Venezuela', flag: '🇻🇪', format: 'XXX-XXX-XXXX', phoneLength: 10, example: '412-123-4567'),
    CountryCode(isoCode: 'SA', dialCode: '+966', name: 'Saudi Arabia', flag: '🇸🇦', format: 'XX XXX XXXX', phoneLength: 9, example: '50 123 4567'),
    CountryCode(isoCode: 'AE', dialCode: '+971', name: 'United Arab Emirates', flag: '🇦🇪', format: 'XX XXX XXXX', phoneLength: 9, example: '50 123 4567'),
    CountryCode(isoCode: 'IL', dialCode: '+972', name: 'Israel', flag: '🇮🇱', format: 'XX-XXX-XXXX', phoneLength: 9, example: '50-123-4567'),
    CountryCode(isoCode: 'TR', dialCode: '+90', name: 'Turkey', flag: '🇹🇷', format: 'XXX XXX XXXX', phoneLength: 10, example: '532 123 4567'),
    CountryCode(isoCode: 'PL', dialCode: '+48', name: 'Poland', flag: '🇵🇱', format: 'XXX XXX XXX', phoneLength: 9, example: '512 345 678'),
    CountryCode(isoCode: 'NL', dialCode: '+31', name: 'Netherlands', flag: '🇳🇱', format: 'XX XXX XXXX', phoneLength: 9, example: '06 1234 5678'),
    CountryCode(isoCode: 'BE', dialCode: '+32', name: 'Belgium', flag: '🇧🇪', format: 'XXX XX XX XX', phoneLength: 9, example: '470 12 34 56'),
    CountryCode(isoCode: 'CH', dialCode: '+41', name: 'Switzerland', flag: '🇨🇭', format: 'XX XXX XX XX', phoneLength: 9, example: '78 123 45 67'),
    CountryCode(isoCode: 'AT', dialCode: '+43', name: 'Austria', flag: '🇦🇹', format: 'XXX XXXXXXX', phoneLength: 10, example: '660 1234567'),
    CountryCode(isoCode: 'SE', dialCode: '+46', name: 'Sweden', flag: '🇸🇪', format: 'XX-XXX XX XX', phoneLength: 9, example: '70-123 45 67'),
    CountryCode(isoCode: 'NO', dialCode: '+47', name: 'Norway', flag: '🇳🇴', format: 'XXX XX XXX', phoneLength: 8, example: '412 34 567'),
    CountryCode(isoCode: 'DK', dialCode: '+45', name: 'Denmark', flag: '🇩🇰', format: 'XX XX XX XX', phoneLength: 8, example: '32 12 34 56'),
    CountryCode(isoCode: 'FI', dialCode: '+358', name: 'Finland', flag: '🇫🇮', format: 'XX XXX XXXX', phoneLength: 9, example: '41 123 4567'),
    CountryCode(isoCode: 'PT', dialCode: '+351', name: 'Portugal', flag: '🇵🇹', format: 'XXX XXX XXX', phoneLength: 9, example: '912 345 678'),
    CountryCode(isoCode: 'GR', dialCode: '+30', name: 'Greece', flag: '🇬🇷', format: 'XXX XXX XXXX', phoneLength: 10, example: '691 234 5678'),
    CountryCode(isoCode: 'IE', dialCode: '+353', name: 'Ireland', flag: '🇮🇪', format: 'XX XXX XXXX', phoneLength: 9, example: '85 123 4567'),
    CountryCode(isoCode: 'CZ', dialCode: '+420', name: 'Czech Republic', flag: '🇨🇿', format: 'XXX XXX XXX', phoneLength: 9, example: '601 123 456'),
    CountryCode(isoCode: 'HU', dialCode: '+36', name: 'Hungary', flag: '🇭🇺', format: 'XX XXX XXXX', phoneLength: 9, example: '20 123 4567'),
    CountryCode(isoCode: 'RO', dialCode: '+40', name: 'Romania', flag: '🇷🇴', format: 'XXX XXX XXX', phoneLength: 9, example: '721 234 567'),
    CountryCode(isoCode: 'BG', dialCode: '+359', name: 'Bulgaria', flag: '🇧🇬', format: 'XX XXX XXXX', phoneLength: 9, example: '88 123 4567'),
    CountryCode(isoCode: 'HR', dialCode: '+385', name: 'Croatia', flag: '🇭🇷', format: 'XX XXX XXXX', phoneLength: 9, example: '91 123 4567'),
    CountryCode(isoCode: 'SK', dialCode: '+421', name: 'Slovakia', flag: '🇸🇰', format: 'XXX XXX XXX', phoneLength: 9, example: '901 123 456'),
    CountryCode(isoCode: 'SI', dialCode: '+386', name: 'Slovenia', flag: '🇸🇮', format: 'XX XXX XXX', phoneLength: 8, example: '31 234 567'),
    CountryCode(isoCode: 'LT', dialCode: '+370', name: 'Lithuania', flag: '🇱🇹', format: 'XXX XXXXX', phoneLength: 8, example: '612 34567'),
    CountryCode(isoCode: 'LV', dialCode: '+371', name: 'Latvia', flag: '🇱🇻', format: 'XX XXX XXX', phoneLength: 8, example: '21 234 567'),
    CountryCode(isoCode: 'EE', dialCode: '+372', name: 'Estonia', flag: '🇪🇪', format: 'XXXX XXXX', phoneLength: 8, example: '5123 4567'),
    CountryCode(isoCode: 'UA', dialCode: '+380', name: 'Ukraine', flag: '🇺🇦', format: 'XX XXX XXXX', phoneLength: 9, example: '50 123 4567'),
    CountryCode(isoCode: 'BY', dialCode: '+375', name: 'Belarus', flag: '🇧🇾', format: 'XX XXX-XX-XX', phoneLength: 9, example: '29 123-45-67'),
    CountryCode(isoCode: 'KZ', dialCode: '+7', name: 'Kazakhstan', flag: '🇰🇿', format: 'XXX XXX-XX-XX', phoneLength: 10, example: '701 234-56-78'),
    CountryCode(isoCode: 'PK', dialCode: '+92', name: 'Pakistan', flag: '🇵🇰', format: 'XXX XXXXXXX', phoneLength: 10, example: '301 2345678'),
    CountryCode(isoCode: 'BD', dialCode: '+880', name: 'Bangladesh', flag: '🇧🇩', format: 'XXXX-XXXXXX', phoneLength: 10, example: '1712-345678'),
    CountryCode(isoCode: 'LK', dialCode: '+94', name: 'Sri Lanka', flag: '🇱🇰', format: 'XX XXX XXXX', phoneLength: 9, example: '71 234 5678'),
    CountryCode(isoCode: 'HK', dialCode: '+852', name: 'Hong Kong', flag: '🇭🇰', format: 'XXXX XXXX', phoneLength: 8, example: '9123 4567'),
    CountryCode(isoCode: 'TW', dialCode: '+886', name: 'Taiwan', flag: '🇹🇼', format: 'XXX XXX XXX', phoneLength: 9, example: '912 345 678'),
  ];

  /// Find country by ISO code
  static CountryCode? findByIsoCode(String isoCode) {
    try {
      return allCountries.firstWhere((country) => country.isoCode.toUpperCase() == isoCode.toUpperCase());
    } catch (_) {
      return null;
    }
  }

  /// Find country by dial code
  static CountryCode? findByDialCode(String dialCode) {
    try {
      return allCountries.firstWhere((country) => country.dialCode == dialCode);
    } catch (_) {
      return null;
    }
  }

  /// Get default country (US)
  static CountryCode get defaultCountry => allCountries.first;
}
