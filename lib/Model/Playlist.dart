import 'Track.dart';

class Playlist {
  List<Track> _tracks = [];
  String _id;
  String _name;

  Playlist(this._id, this._name, this._tracks);


  String get name => _name;
  set name(String value) {
    _name = value;
  }

  String get id => _id;
  set id(String value) {
    _id = value;
  }
  void addTrack(Track track) {
    _tracks.add(track);
  }

  void removeTrack(Track track) {
    _tracks.remove(track);
  }

  @override
  String toString() {
    return 'Playlist: $_tracks';
  }
}