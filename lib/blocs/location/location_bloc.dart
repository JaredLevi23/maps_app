import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  StreamSubscription? positionStream;

  LocationBloc() : super( const LocationState() ) {

    on<LocationEvent>((event, emit) {
      // TODO: implement event handler
    });
    
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    print( position );

    //TODO: Retornar un modelo de lat lon
  }

  void startFollowingUser(){
    print('startFollingUser');
    positionStream =  Geolocator.getPositionStream().listen((event) { 
      final position = event;
      print( position );
    });
  }

  void stopFollowingUser(){
    positionStream?.cancel();
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }

}
