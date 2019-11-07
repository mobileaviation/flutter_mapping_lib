import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mapping_library/src/objects/fixedobject/scalebar.dart';
import 'package:mapping_library/src/objects/fixedobject/fixedobject.dart';
import 'package:mapping_library/src/objects/markers/markers.dart';
import 'package:mapping_library/src/objects/vector/geombase.dart';
import 'package:mapping_library/src/objects/vector/polygon.dart';
import 'package:mapping_library/src/objects/vector/polyline.dart';
import 'package:mapping_library/src/objects/vector/vectors.dart';
import 'package:mapping_library/src/tiles/sources/httptilesource.dart';
import 'package:mapping_library/src/layers/layers.dart';
import 'package:mapping_library/src/utils/mapposition.dart';
import 'package:mapping_library/src/utils/geopoint.dart';
import 'package:mapping_library/src/utils/geopoints.dart';
import 'package:mapping_library/src/layers/mapview.dart';
import 'package:mapping_library/src/layers/tilelayer.dart';
import 'package:mapping_library/src/layers/fixedobjectlayer.dart';
import 'package:mapping_library/src/layers/markerslayer.dart';
import 'package:mapping_library/src/objects/markers/renderers/simplemarkerrenderer.dart';
import 'package:mapping_library/src/objects/markers/simplemarker.dart';
import 'package:mapping_library/src/objects/markers/markerbase.dart';
import 'package:mapping_library/src/layers/vectorlayer.dart';
import 'package:mapping_library/src/layers/overlaylayer.dart';
import 'package:mapping_library/src/objects/overlay/overlayimage.dart';
import 'package:mapping_library/src/objects/overlay/overlayimages.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() : super() {}

  Markers _getMarkers() {
    GeoPoint s = new GeoPoint(52.45657243868931, 5.52041338863477);
    SimpleMarkerRenderer drawer = new SimpleMarkerRenderer();
    SimpleMarker marker = new SimpleMarker(drawer, Size(100, 100), s);
    marker.dragable = true;
    marker.name = "Marker1";
    marker.rotation = 45;
    Markers markers = Markers();
    markers.add(marker);
    return markers;
  }

  GeomBase _getEHAMCtr(){
    String crtEHAM = "4.63472222,52.415,0 4.64,52.4725,0 4.80333333,52.46694444,0 4.80083333,52.43916667,0 4.80785584852373,52.4383619332707,0 4.81483107970069,52.4374170354758,0 4.8217514795786,52.4363329992925,0 4.82860956494179,52.4351109978676,0 4.83539792194114,52.4337523535153,0 4.84210921401313,52.4322585362489,0 4.84873619010467,52.4306311621498,0 4.85527169272911,52.4288719915739,0 4.86170866574294,52.4269829272002,0 4.86804016223541,52.4249660119216,0 4.87425935202906,52.4228234265817,0 4.88035952930676,52.4205574875601,0 4.88633411991035,52.4181706442092,0 4.89217668845641,52.4156654761455,0 4.89788094547063,52.4130446903981,0 4.90344075414447,52.4103111184194,0 4.90885013708994,52.4074677129596,0 4.91410328267179,52.4045175448101,0 4.91919455141374,52.4014637994195,0 4.92411848201159,52.3983097733859,0 4.92886979720684,52.395058870829,0 4.9334434094004,52.3917145996486,0 4.93783442609722,52.3882805676708,0 4.94203815508983,52.3847604786891,0 4.9460501094341,52.3811581284034,0 4.94986601212847,52.3774774002622,0 4.95348180059927,52.3737222612129,0 4.95689363095838,52.3698967573653,0 4.96009788194331,52.3660050095721,0 4.963091158639,52.3620512089337,0 4.96587029594963,52.3580396122301,0 4.96843236178563,52.3539745372868,0 4.97077466001986,52.3498603582787,0 4.97289473311187,52.3457015009786,0 4.97479036456212,52.3415024379546,0 4.97645958099455,52.3372676837225,0 4.97790065405385,52.3330017898573,0 4.97911210194895,52.328709340072,0 4.98009269081713,52.3243949452654,0 4.98084143573716,52.3200632385478,0 4.98135760150914,52.3157188702477,0 4.98164070311773,52.3113665029062,0 4.98169050603017,52.3070108062643,0 4.98150702609488,52.3026564522477,0 4.98109052923454,52.2983081099563,0 4.98044153088764,52.2939704406611,0 4.97956079515501,52.2896480928172,0 4.97844933367993,52.2853456970948,0 4.97710840428337,52.2810678614359,0 4.97553950935205,52.2768191661407,0 4.97374439392689,52.2726041589893,0 4.97172504358657,52.2684273504037,0 4.96948368207414,52.2642932086543,0 4.96702276861619,52.2602061551182,0 4.96434499512388,52.2561705595907,0 4.96145328303599,52.2521907356578,0 4.95835077998372,52.2482709361331,0 4.95504085623815,52.2444153485637,0 4.95152710090886,52.2406280908099,0 4.94781331791149,52.2369132067027,0 4.9439035217832,52.2332746617845,0 4.93980193321414,52.2297163391358,0 4.93551297441948,52.2262420352934,0 4.93104126428376,52.2228554562627,0 4.92639161336218,52.2195602136296,0 4.92156901866199,52.2163598207742,0 4.91657865817701,52.2132576891917,0 4.91142588542437,52.2102571249223,0 4.90611622360869,52.2073613250951,0 4.9006553597533,52.2045733745878,0 4.89504913864931,52.2018962428073,0 4.88930355660782,52.1993327805921,0 4.883424755102,52.1968857172419,0 4.87741901434601,52.1945576576743,0 4.87129274656918,52.1923510797143,0 4.86505248929498,52.1902683315173,0 4.85870489851097,52.1883116291276,0 4.85225674167828,52.1864830541772,0 4.84571489057102,52.1847845517241,0 4.8390863142147,52.1832179282342,0 4.83237807152988,52.1817848497072,0 4.82559730399061,52.18048683995,0 4.81875122822649,52.1793252789972,0 4.81184712846296,52.1783014016817,0 4.80489234903771,52.1774162963562,0 4.79789428669848,52.1766709037661,0 4.79086038298698,52.1760660160765,0 4.78379811658563,52.1756022760521,0 4.77671499522959,52.1752801763931,0 4.76961854870018,52.1751000592249,0 4.76251632068323,52.175062115745,0 4.75541585866386,52.1751663860256,0 4.74832471184278,52.175412758972,0 4.74125041727937,52.175800972438,0 4.73420049537503,52.1763306134975,0 4.7271824411347,52.1770011188715,0 4.72020371671844,52.177811775512,0 4.71327174343314,52.1787617213392,0 4.70639389429674,52.1798499461348,0 4.69957748624526,52.1810752925877,0 4.69282977252864,52.1824364574929,0 4.68615793528504,52.1839319931016,0 4.67956907796569,52.1855603086221,0 4.67307021802309,52.1873196718686,0 4.6666682795065,52.1892082110581,0 4.66037008589958,52.191223916753,0 4.65418235295122,52.1933646439468,0 4.6481116816633,52.1956281142928,0 4.64216455133734,52.1980119184715,0 4.63634731278969,52.2005135186962,0 4.63066618162242,52.203130251354,0 4.62512723169445,52.2058593297791,0 4.61973638867185,52.2086978471563,0 4.61449942372611,52.2116427795523,0 4.60942194743565,52.214690989071,0 4.60450940371879,52.2178392271302,0 4.59976706411293,52.2210841378572,0 4.59520002199074,52.224422261599,0 4.59081318716832,52.2278500385443,0 4.58661128051616,52.2313638124537,0 4.58259882890156,52.2349598344942,0 4.57878016017991,52.2386342671749,0 4.57515939850034,52.2423831883795,0 4.5717404597522,52.2462025954916,0 4.56852704718742,52.2500884096089,0 4.56552264736242,52.2540364798423,0 4.56273052619185,52.2580425876955,0 4.56015372523179,52.2621024515203,0 4.55779505829117,52.2662117310435,0 4.55565710812982,52.2703660319613,0 4.55374222351253,52.2745609105955,0 4.55205251642164,52.2787918786071,0 4.55058985954733,52.2830544077636,0 4.5493558840491,52.2873439347531,0 4.54835197749193,52.2916558660419,0 4.54757928213566,52.2959855827694,0 4.54703869338532,52.3003284456768,0 4.54673085856398,52.3046798000615,0 4.54665617592859,52.3090349807561,0 4.54681479395719,52.3133893171225,0 4.54720661086263,52.3177381380588,0 4.54783127445168,52.3220767770123,0 4.54868818217498,52.3264005769937,0 4.5497764815031,52.3307048955865,0 4.5510950705336,52.3349851099471,0 4.55264259890546,52.3392366217893,0 4.55441746897736,52.3434548623481,0 4.55641783723871,52.3476352973174,0 4.55864161604268,52.3517734317562,0 4.56108647563048,52.3558648149575,0 4.56374984631425,52.3599050452746,0 4.56662892107052,52.3638897749004,0 4.56972065828733,52.3678147145919,0 4.57302178487243,52.3716756383377,0 4.5765287995113,52.3754683879605,0 4.58023797632604,52.3791888776511,0 4.58414536862581,52.382833098428,0 4.58824681308821,52.3863971225171,0 4.59253793402907,52.3898771076479,0 4.59701414804312,52.3932693012592,0 4.60167066881065,52.3965700446117,0 4.60650251217606,52.3997757768001,0 4.61150450141679,52.4028830386629,0 4.61667127279467,52.4058884765827,0 4.62199728131726,52.4087888461744,0 4.62747680663297,52.4115810158556,0";
    GeoPoints ctrEHAMpoints = new GeoPoints();
    ctrEHAMpoints.addFromString(crtEHAM, true);
    Polygon crtEHAMpolygon = new Polygon(ctrEHAMpoints);
    crtEHAMpolygon.geomPaint.color = Colors.greenAccent;
    crtEHAMpolygon.name = "CTR EHAM";
    return crtEHAMpolygon;
  }

  GeomBase _drawLelystadCircuit() {
    // The dircuit area on top of Lelystad airport
    String trafficCircuitEHLE = "5.52458889125152,52.4587277800044 5.52484300122376,52.4588697791537 5.52484300122376,52.4588697791537 5.54633722695909,52.4708757305781 5.54832623653387,52.4719861738938 5.55154930110094,52.4719006434685 5.55337224570004,52.4706890423896 5.55352320408749,52.4705887939362 5.55352320408749,52.4705887939362 5.56509807329495,52.4629022054321 5.56692098087489,52.4616899250738 5.56677862836174,52.4597233868798 5.5647878156617,52.4586135658832 5.56418015742951,52.4582743515565 5.56418015742951,52.4582743515565 5.50773338212851,52.4267248611918 5.50574667251343,52.4256146779705 5.50252939869441,52.4256997528863 5.50070774734002,52.4269106412474 5.50055697047508,52.4270109291608 5.50055697047508,52.4270109291608 5.48898729553504,52.4347059744646 5.48716516802067,52.4359164763822 5.48730196588175,52.4378771762641 5.48928630300586,52.4389889449381 5.48950357500167,52.4391105196022 5.48950357500167,52.4391105196022 5.51101944002569,52.4511444400002";
    GeoPoints points = new GeoPoints();
    // By default a polygon will be an open polygon.
    points.addFromString(trafficCircuitEHLE);
    Polygon lelystadCircuit = new Polygon(points);
    lelystadCircuit.geomPaint.color = Colors.lightBlue;
    // As an experiment we've added a blur filter to the Paint object
    //lelystadCircuit.geomPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    lelystadCircuit.name = "Traffic Circuit EHLE";
    return lelystadCircuit;
  }

  GeomBase _drawHoogeveenCircuit() {
    String trafficCircuitEHHO = "6.52509200013541,52.7306369999699 6.52536837932791,52.7306259291328 6.52536837932791,52.7306259291328 6.54761711045751,52.7297329136902 6.55067567032722,52.7296095844004 6.55286584800144,52.7307703154414 6.55306938491788,52.7326225121997 6.55308228089967,52.7327409600383 6.55308228089967,52.7327409600383 6.55401875324438,52.7413696337004 6.55422271262167,52.7432247735352 6.55230690861631,52.7445506200243 6.54924252640154,52.744674971413 6.54858097798292,52.7447015852281 6.54858097798292,52.7447015852281 6.48819599186663,52.7471135049954 6.48513928131557,52.7472358827491 6.48294887327464,52.7460737854257 6.48274839225936,52.7442233901648 6.48273543954264,52.7441049321505 6.48273543954264,52.7441049321505 6.48178857164967,52.7354721133458 6.48158822523598,52.7336220554346 6.4835086916069,52.7322966701029 6.48656401156079,52.7321763196082 6.48678930604847,52.7321673575445 6.48678930604847,52.7321673575445 6.50909299981233,52.7312780000086";
    GeoPoints trafficCircuitEHHOPoint = new GeoPoints();
    trafficCircuitEHHOPoint.addFromString(trafficCircuitEHHO);
    Polygon trafficCircuitEHHOpolygon = new Polygon(trafficCircuitEHHOPoint);
    trafficCircuitEHHOpolygon.name = "Traffic Circuit EHHO";
    return trafficCircuitEHHOpolygon;
  }

  GeomBase _testPolyLineUpdate() {
    List<GeoPoint> points = [
      GeoPoint(52.373893, 5.232694),
      GeoPoint(52.389645 , 5.298114),
      GeoPoint(52.402879 , 5.366541),
      GeoPoint(52.435251 , 5.39869),
      GeoPoint(52.470789 , 5.423742),
      GeoPoint(52.499938 , 5.46374),
      GeoPoint(52.514271 , 5.535888),
      GeoPoint(52.494923 , 5.574778),
      GeoPoint(52.463048 , 5.57739),
      GeoPoint(52.437308 , 5.573274),
      GeoPoint(52.406982 , 5.561691),
      GeoPoint(52.3901 , 5.516074),
      GeoPoint(52.358604 , 5.495889),
      GeoPoint(52.331196 , 5.520941)
    ];

    int counter = 0;

    // A polyline consists of two lines painted one over the other
    // This way we are able to draw lines with a border. Under the hood two
    // Paint objects are used which you also have the ability to alter yourself
    Polyline l = new Polyline();
    l.geomPaint.color = Colors.redAccent;
    l.borderColor = Colors.black;
    l.borderWidth = 2;
    l.name = "Updating polyline";

//    for (GeoPoint p in points) {
//      l.addPoint(p);
//    }

    // This will add a sections of the line every second
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      l.addPoint(points[counter]);
      counter++;
      if (counter==points.length) {
        t.cancel();
        //l.Visible = false;
      }
    });

    return l;
  }

  OverlayImages _getOverlayImages() {
    double north = 52.58651688434567;
    double south = 52.27448205017151;
    double east = 5.717278709730119;
    double west = 5.378079539513956;

    String path = "/sdcard/Download";
    String fileEHLE = path + "/" + "EH-AD-2.EHLE-VAC.png";
    OverlayImage ehleImage = OverlayImage(File(fileEHLE));
    ehleImage.setImageBox(north, south, west, east);

    OverlayImages images = OverlayImages();
    images.add(ehleImage);
    return images;
  }

  Vectors _getVectors() {
    Vectors vectors = Vectors();
    vectors.add(_getEHAMCtr());
    vectors.add(_drawLelystadCircuit());
    vectors.add(_drawHoogeveenCircuit());
    vectors.add(_testPolyLineUpdate());
    return vectors;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Container(
            child: Mapview(
                mapPosition: MapPosition.create(
                  // This is a location in the middle of the netherlands
                  geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
                  zoomLevel: 10,
                ),
                layers: Layers(
                  children: <Widget>[
                    TilesLayer(
                      tileSource: HttpTileSource("http://c.tile.openstreetmap.org/##Z##/##X##/##Y##.png"),
                      name: "TilesLayer",
                    ),
                    OverlayLayer(
                      overlayImages: _getOverlayImages(),
                      name: "OverlayLayer",
                    ),
                    FixedObjectLayer(
                      fixedObject: ScaleBar(FixedObjectPosition.lefttop,
                                          Offset(10,10)),
                      name: "Layer2",
                    ),
                    MarkersLayer(
                      markers: _getMarkers(),
                      name: "MarkersLayer",
                      markerSelected: _markerSelected,
                    ),
                    VectorLayer(
                      vectors: _getVectors(),
                      name: "VectorsLayer",
                      vectorSelected: _vectorSelected,
                    )
                  ],
                ))));
  }

  void _vectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    log("Vector selected: ${vector.name}");
  }

  void _markerSelected(MarkerBase marker){
    log("Marker selected: ${marker.name}");
  }
}

// https://www.openstreetmap.org/export#map=11/52.4476/5.5206
// https://b.tile.openstreetmap.org/11/1053/673.png

//https://b.tile.openstreetmap.org/10/529/336.png
