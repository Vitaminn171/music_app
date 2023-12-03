import 'package:flutter/material.dart';
import 'dart:async';
import 'package:spotify/spotify.dart';
import 'package:flutter/services.dart';

import '../../ViewModel/ViewModel_MusicService.dart';

void main() async {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        dividerColor: Colors.transparent,
        colorSchemeSeed: Colors.lightBlueAccent,
        useMaterial3: true,

      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool shadowColor = true;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  final ViewModel_MusicService _MusicService = ViewModel_MusicService();
  late List<PlaylistSimple> pl = [];


  @override
  void initState() {
    super.initState();


    fetchTrendingPlaylists();
  }

  Future<void> fetchTrendingPlaylists() async {
    try {
      _MusicService.begin();

      final Iterable<PlaylistSimple>? playlists = await _MusicService.getTrendingPlaylists();
      setState(() {
          playlists?.forEach((playlist) {
            PlaylistSimple tmp = playlist;
            pl.add(tmp);
          });
        });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);



    @override
    void dispose() {
      _searchController.dispose(); // Dispose the controller when it's no longer needed.
      super.dispose();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isSearching ? 65 : kToolbarHeight),
        child: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.fromLTRB(10,0,10,0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    _searchController.clear();
                  });
                },
                icon: Icon(_isSearching ? Icons.cancel : Icons.search, size: 30),

              ),
            ),

          ],
          title: _isSearching ? _buildSearchField() : Text('My App'),
          scrolledUnderElevation: 12,
          shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        ),
      ),
      body: GridView.builder(
        itemCount: pl.length,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.6,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          String? name = pl[index].name;
          return FutureBuilder<Iterable<Track>>(
            future: _MusicService.getTracks(pl[index].id.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Iterable<Track> tracks = snapshot.data ?? [];

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.music_note,
                            color: Colors.teal[900],
                          ),
                          Text(
                            name!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,

                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (Track track in tracks)

                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 150,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: evenItemColor,
                                      image: DecorationImage(
                                        image: NetworkImage(track.album!.images!.first.url.toString()),
                                        fit: BoxFit.cover, // Adjust the fit based on your needs
                                      ),
                                    ),
                                    alignment: Alignment.topCenter,
                                  ),
                                  Text(
                                    track.name ?? 'Unknown',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                                  ),
                                  Text(
                                    track.artists?.first.name ?? 'Unknown Artist',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 13.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),

      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: Colors.white,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,

            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: evenItemColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text('Drawer Header',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26.0,color: Colors.black),
                      overflow: TextOverflow.ellipsis,),
                  ],

                ),
              ),

              Material(
                child: ListTile(
                  title: const Text('Item 1'),
                  textColor: Colors.black,
                  tileColor: Colors.white,

                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),

              ),
              Material(
                child: ListTile(
                  title: const Text('Item 1'),
                  textColor: Colors.black,


                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        contentPadding: const EdgeInsets.fromLTRB(0,0,10,0),
        border: OutlineInputBorder( // Customize the border
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: const Icon(Icons.search), // Add a prefix icon
      ),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      cursorColor: Colors.grey, // Change the cursor color
      keyboardType: TextInputType.text, // Set the keyboard type
      textCapitalization: TextCapitalization.none, // Don't capitalize the entered text
      autofocus: true, // Automatically focus on the search field
      onChanged: (value) {
        // Perform search functionality as user types
        print(value);
      },
    );
  }
}