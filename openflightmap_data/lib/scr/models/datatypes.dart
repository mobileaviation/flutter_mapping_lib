/// A unit of measurement for temperature.
enum uomT {
  C,
  F
}

/// A unit of measurement for an elevation.  E.g. metres or  feet.
enum uomElev {
  FT,
  M
}

///A code specifying whether a particular entity occurrence is an Aerodrome or a Heliport.
enum codeTypeAdHp {
  AD,
  AH,
  HP,
  LS
}

/// A unit of measurement for a horizontal distance.  E.g. metres, feet, nautical miles, kilometres, etc. .
enum uomDistHorz {
  NM,
  KM,
  M,
  FT
}

/// A code indicating the composition of a surface.  Eg. asphalt, concrete etc..
enum codeCompositionSfcBase {
  ASPH,
  ASP_GRS,
  CONC,
  CONC_ASPH,
  CONC_GRS,
  GRASS,
  SAND,
  WATER,
  BITUM,
  BRICK,
  MACADAM,
  STONE,
  CORAL,
  CLAY,
  LATERITE,
  GRADE,
  GRAVE,
  ICE,
  SNOW,
  MEMBRANE,
  METAL,
  MATS,
  PSP,
  WOOD,
  OTHER,
}

/// A code indicating the pavement behaviour (rigid or flexible) used for the PCN determination.
enum codePcnPavementTypeBase {
  F,
  R
}

/// A code indicating the subgrade strength category related to a PCN number.
enum codePcnPavementSubgradeBase {
  A,
  B,
  C,
  D
}

/// A code indicating the maximum allowable tire pressure categoryrelated to a PCN number.
enum codePcnMaxTirePressureBase {
  W,
  X,
  Y,
  Z
}

/// A code indicating the method used in the evaluation of a PCN number.
enum codePcnEvalMethodBase {
  T,
  U
}

/// Type of a service such as Flight Information etc.
enum codeTypeSerBase {
  ACS,
  ADS,
  ADVS,
  AFIS,
  AFS,
  AIS,
  ALRS,
  AMS,
  AMSS,
  APP,
  APP_ARR,
  APP_DEP,
  ARTCC,
  ATC,
  ATFM,
  ATIS,
  ATIS_ARR,
  ATIS_DEP,
  ATM,
  ATS,
  BOF,
  BS,
  COM,
  CTAF,
  DVDF,
  EFAS,
  FCST,
  FIS,
  FISA,
  FSS,
  GCA,
  OAC,
  NOF,
  MET,
  PAR,
  RAC,
  RADAR,
  RAF,
  RCC,
  SAR,
  SIGMET,
  SMC,
  SMR,
  SRA,
  SSR,
  TAR,
  TWEB,
  TWR,
  UAC,
  UDF,
  VDF,
  VOLMET,
  VOT,
  OVERFLT,
  ENTRY,
  EXIT,
  INFO,
  OTHER
}


/// A unit of measurement for a frequency.  E.g. Hz, kHz, MHz,GHz.
enum uomFreqBase {
  HZ,
  KHZ,
  MHZ,
  GHZ
}





