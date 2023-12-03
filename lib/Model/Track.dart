import 'package:spotify/spotify.dart';
import 'Album.dart';
class Track {
  String _name;
  String _id;
  List<Artist>? _artists;
  Image _img;

  Track(this._name, this._id, this._artists, this._img);

  String get name => _name;
  set name(String value) {
    _name = value;
  }

  String get id => _id;
  set id(String value) {
    _id = value;
  }

  List<Artist>? get artists => _artists;
  set artists(List<Artist>? value) {
    _artists = value;
  }

  Image get img => _img;
  set img(Image value) {
    _img = value;
  }

}
