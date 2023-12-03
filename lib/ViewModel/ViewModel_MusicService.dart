import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify/spotify.dart';



class ViewModel_MusicService {

  final String clientId = 'f05bd868d0c04f1e964b67628ef80798';
  final String clientSecret = 'ce2dbce7e4e34a34b5b420bc439fe25f';
  SpotifyApi? spotify;


  Future<dynamic> begin() async {

    var credentials = SpotifyApiCredentials(clientId, clientSecret);
    spotify = SpotifyApi(credentials);


  }

  String? extractCodeFromUrl(String responseBody) {
    final uri = Uri.parse(responseBody);
    print(uri.queryParameters['code']);
    return uri.queryParameters['code'];
  }


  Future<Iterable<PlaylistSimple>?> getTrendingPlaylists() async {

    Iterable<PlaylistSimple>? featuredPlaylists;
    featuredPlaylists = await spotify?.playlists.featured.all();

    // featuredPlaylists?.forEach((playlist) async {
    //   PlaylistSimple tmp = playlist;
    //   Iterable<Track> track = await getTracks(tmp.id.toString());
    //
    //   track.forEach((trk) async {
    //     Track tmp = trk;
    //     print(tmp.uri);
    //   });
    // });
    // get track from playlist*


    return featuredPlaylists;
  }

  Future<Iterable<Track>> getTracks(String playlistID) async {

    Iterable<Track> track = await getPlaylistTracks(spotify!,playlistID);
    return track;
  }

  Future<Iterable<Track>> getPlaylistTracks(SpotifyApi? spotify, String playlistId) async {
    var tracksPage = spotify?.playlists.getTracksByPlaylistId(playlistId);
    return (await tracksPage?.first())?.items ?? [];
  }

// Add more methods for other API endpoints as needed
}
