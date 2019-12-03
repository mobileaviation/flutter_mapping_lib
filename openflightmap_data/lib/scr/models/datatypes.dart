/// A unit of measurement for temperature.
enum uomT {
  C,
  F
}

/// A unit of measurement for an elevation.
/// E.g. metres or  feet.
enum uomElev {
  FT,
  M
}

/// A code specifying whether a particular entity occurrence is an
/// Aerodrome or a Heliport.
enum codeTypeAdHp {
  AD,
  AH,
  HP,
  LS
}

/// A unit of measurement for a horizontal distance.
/// E.g. metres, feet, nautical miles, kilometres, etc. .
enum uomDistHorz {
  NM,
  KM,
  M,
  FT
}

/// A unit of measurement for a vertical distance.
/// E.g. Flight Level, metres, feet.
enum uomDistVerBase {
  FT,
  M,
  FL,
  SM
}


/// A code indicating the composition of a surface.
/// Eg. asphalt, concrete etc..
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

/// A code indicating the type of the North reference used.
enum codeTypeNorthBase {
  TRUE,
  MAG,
  GRID,
  OTHER,
}

///A code indicating the geodetic datum in which the geographical co-ordinates
///are expressed (list of allowable based on the ICAO WGS-84 Manual;
///abbreviations based on ARINC 424, Attachment 2).
enum codeDatumBase {
  WGE,
  WGC,
  EUS,
  EUT,
  ANS,
  BEL,
  BRN,
  CHI,
  DGI,
  IGF,
  POT,
  GRK,
  HJO,
  IRL,
  ROM,
  IGL,
  NTH,
  OGB,
  DLX,
  PRD,
  RNB,
  STO,
  NAS,
  NAW,
  U
}

/// A code indicating the reference for a vertical distance.
/// Two series of values exist:
/// 1) real distance: from GND, from the MSL, from the WGS-84 ellipsoid
/// 2) pressure  distance: QFE, QNH, STD.
enum codeDistVerBase {
  HEI,
  ALT,
  W84,
  QFE,
  QNH,
  STD,
  OTHER
}

/// Allowed types of Airspace.
enum  codeTypeAsBase {
  ICAO,
  ECAC,
  CFMU,
  IFPS,
  TACT,
  NAS,
  NAS_P,
  FIR,
  FIR_P,
  UIR,
  UIR_P,
  CTA,
  CTA_P,
  OCA_P,
  OCA,
  UTA,
  UTA_P,
  TMA,
  TMA_P,
  CTR,
  CTR_P,
  ATZ,
  ATZ_P,
  MNPSA,
  MNPSA_P,
  OTA,
  SECTOR,
  SECTOR_C,
  TSA,
  CBA,
  RCA,
  RAS,
  CDA,
  AWY,
  RTECL,
  P,
  R,
  D,
  R_AMC,
  D_AMC,
  MIL,
  ADIZ,
  HTZ,
  OIL,
  BIRD,
  SPORT,
  LMA,
  NO_FIR,
  PART,  CLASS,
  POLITICAL,
  D_OTHER,
  TRA,
  A,
  W,
  PROTECT,
  AMA,
  ASR,
  TMZ,
  GLDR,
  HPGLDR,
  HPZ
}

/// One letter code for the type of airspace according to Annex 11, Appendix 4.
enum codeClassAsBase {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  OTHER
}



