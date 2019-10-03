import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ghosts_on_the_train/models/app_state.dart';
import 'package:ghosts_on_the_train/models/location.dart';
import 'package:ghosts_on_the_train/redux/actions.dart';
import 'package:ghosts_on_the_train/widgets/map_widget.dart';
import 'package:ptv_api_client/model/v3_stops_by_distance_response.dart';
import 'package:redux/redux.dart';

class MyApp extends StatelessWidget {
  MyApp(this.store);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'PTV Clone',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyScaffold(),
        },
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PTV Clone'),
      ),
      body: StoreConnector<AppState, int>(
        converter: (store) => store.state.homeIndex,
        builder: (context, index) => IndexedStack(
          index: index,
          children: <Widget>[
            StoreConnector<AppState, Location>(
              converter: (store) => store.state.location,
              builder: (context, location) =>
                  StoreConnector<AppState, V3StopsByDistanceResponse>(
                converter: (store) => store.state.nearbyStops,
                builder: (context, stops) =>
                    MapWidget(location.latitude, location.longitude, stops),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
                StoreProvider.of<AppState>(context).dispatch(
                  ActionStoreHome(index: 0),
                );
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
                StoreProvider.of<AppState>(context).dispatch(
                  ActionStoreHome(index: 1),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
