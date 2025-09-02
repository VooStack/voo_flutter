enum USStates {
  alabama,
  alaska,
  arizona,
  arkansas,
  california,
  colorado,
  connecticut,
  delaware,
  florida,
  georgia,
  hawaii,
  idaho,
  illinois,
  indiana,
  iowa,
  kansas,
  kentucky,
  louisiana,
  maine,
  maryland,
  massachusetts,
  michigan,
  minnesota,
  mississippi,
  missouri,
  montana,
  nebraska,
  nevada,
  new_hampshire,
  new_jersey,
  new_mexico,
  new_york,
  north_carolina,
  north_dakota,
  ohio,
  oklahoma,
  oregon,
  pennsylvania,
  rhode_island,
  south_carolina,
  south_dakota,
  tennessee,
  texas,
  utah,
  vermont,
  virginia,
  washington,
  west_virginia,
  wisconsin,
  wyoming,
}

extension USStateExtensions on USStates {
  String get displayName {
    switch (this) {
      case USStates.alabama:
        return 'Alabama';
      case USStates.alaska:
        return 'Alaska';
      case USStates.arizona:
        return 'Arizona';
      case USStates.arkansas:
        return 'Arkansas';
      case USStates.california:
        return 'California';
      case USStates.colorado:
        return 'Colorado';
      case USStates.connecticut:
        return 'Connecticut';
      case USStates.delaware:
        return 'Delaware';
      case USStates.florida:
        return 'Florida';
      case USStates.georgia:
        return 'Georgia';
      case USStates.hawaii:
        return 'Hawaii';
      case USStates.idaho:
        return 'Idaho';
      case USStates.illinois:
        return 'Illinois';
      case USStates.indiana:
        return 'Indiana';
      case USStates.iowa:
        return 'Iowa';
      case USStates.kansas:
        return 'Kansas';
      case USStates.kentucky:
        return 'Kentucky';
      case USStates.louisiana:
        return 'Louisiana';
      case USStates.maine:
        return 'Maine';
      case USStates.maryland:
        return 'Maryland';
      case USStates.massachusetts:
        return 'Massachusetts';
      case USStates.michigan:
        return 'Michigan';
      case USStates.minnesota:
        return 'Minnesota';
      case USStates.mississippi:
        return 'Mississippi';
      case USStates.missouri:
        return 'Missouri';
      case USStates.montana:
        return 'Montana';
      case USStates.nebraska:
        return 'Nebraska';
      case USStates.nevada:
        return 'Nevada';
      case USStates.new_hampshire:
        return 'New Hampshire';
      case USStates.new_jersey:
        return 'New Jersey';
      case USStates.new_mexico:
        return 'New Mexico';
      case USStates.new_york:
        return 'New York';
      case USStates.north_carolina:
        return 'North Carolina';
      case USStates.north_dakota:
        return 'North Dakota';
      case USStates.ohio:
        return 'Ohio';
      case USStates.oklahoma:
        return 'Oklahoma';
      case USStates.oregon:
        return 'Oregon';
      case USStates.pennsylvania:
        return 'Pennsylvania';
      case USStates.rhode_island:
        return 'Rhode Island';
      case USStates.south_carolina:
        return 'South Carolina';
      case USStates.south_dakota:
        return 'South Dakota';
      case USStates.tennessee:
        return 'Tennessee';
      case USStates.texas:
        return 'Texas';
      case USStates.utah:
        return 'Utah';
      case USStates.vermont:
        return 'Vermont';
      case USStates.virginia:
        return 'Virginia';
      case USStates.washington:
        return 'Washington';
      case USStates.west_virginia:
        return 'West Virginia';
      case USStates.wisconsin:
        return 'Wisconsin';
      case USStates.wyoming:
        return 'Wyoming';
    }
  }
}
