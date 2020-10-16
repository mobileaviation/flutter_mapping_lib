import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:mapping_library_bloc/scr/tiles/sources/tilesource.dart';
import 'package:mapping_library_bloc/scr/tiles/tile.dart';

class HttpTileSource extends TileSource {
  HttpTileSource(this._url) {
    log("Tilesource created: ${_url} ");
  }
  final String _url;

  @override
  Future<Tile> retrieveTile(Tile source) async {
    String _url = _getUrl(source);

    log("get tile: ${_url} ");

    Uint8List imgData = await _downloadImage(_url);
    source.image = await getImageFromBytes(imgData);
    return source;
  }

  String _getUrl(Tile tile) {
    String _url = this._url.replaceAll('##X##', tile.x.toString());
    _url = _url.replaceAll("##Y##", tile.y.toString());
    _url = _url.replaceAll('##Z##', tile.z.floor().toString());
    return _url;
  }

  Future<Uint8List> _downloadImage(String url) async {
    http.Client client = http.Client();
    var req = await client.get(Uri.parse(url));
    return req.bodyBytes;
  }

  Future<Image> getImageFromBytes(Uint8List data) async {
    var codec = await instantiateImageCodec(data);
    var f = await codec.getNextFrame();
    return f.image;
  }

}