import 'package:flutter/material.dart';

enum VooFieldType {
  text,
  number,
  email,
  password,
  phone,
  url,
  multiline,
  date,
  time,
  dateTime,
  boolean,
  dropdown,
  multiSelect,
  radio,
  checkbox,
  slider,
  file,
  color,
  rating,
  custom,
}

extension VooFieldTypeExtension on VooFieldType {
  String get label {
    switch (this) {
      case VooFieldType.text:
        return 'Text';
      case VooFieldType.number:
        return 'Number';
      case VooFieldType.email:
        return 'Email';
      case VooFieldType.password:
        return 'Password';
      case VooFieldType.phone:
        return 'Phone';
      case VooFieldType.url:
        return 'URL';
      case VooFieldType.multiline:
        return 'Multiline Text';
      case VooFieldType.date:
        return 'Date';
      case VooFieldType.time:
        return 'Time';
      case VooFieldType.dateTime:
        return 'Date & Time';
      case VooFieldType.boolean:
        return 'Boolean';
      case VooFieldType.dropdown:
        return 'Dropdown';
      case VooFieldType.multiSelect:
        return 'Multi Select';
      case VooFieldType.radio:
        return 'Radio';
      case VooFieldType.checkbox:
        return 'Checkbox';
      case VooFieldType.slider:
        return 'Slider';
      case VooFieldType.file:
        return 'File';
      case VooFieldType.color:
        return 'Color';
      case VooFieldType.rating:
        return 'Rating';
      case VooFieldType.custom:
        return 'Custom';
    }
  }

  TextInputType? get keyboardType {
    switch (this) {
      case VooFieldType.text:
      case VooFieldType.password:
        return TextInputType.text;
      case VooFieldType.number:
        return TextInputType.number;
      case VooFieldType.email:
        return TextInputType.emailAddress;
      case VooFieldType.phone:
        return TextInputType.phone;
      case VooFieldType.url:
        return TextInputType.url;
      case VooFieldType.multiline:
        return TextInputType.multiline;
      case VooFieldType.date:
      case VooFieldType.time:
      case VooFieldType.dateTime:
        return TextInputType.datetime;
      default:
        return null;
    }
  }

  bool get isTextInput {
    return [
      VooFieldType.text,
      VooFieldType.number,
      VooFieldType.email,
      VooFieldType.password,
      VooFieldType.phone,
      VooFieldType.url,
      VooFieldType.multiline,
    ].contains(this);
  }

  bool get isSelectionInput {
    return [
      VooFieldType.dropdown,
      VooFieldType.multiSelect,
      VooFieldType.radio,
      VooFieldType.checkbox,
    ].contains(this);
  }

  bool get isDateTimeInput {
    return [
      VooFieldType.date,
      VooFieldType.time,
      VooFieldType.dateTime,
    ].contains(this);
  }
}