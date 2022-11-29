import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {

  StreamSubscription? gpsServiceSuscription;

  GpsBloc() : super( const GpsState( isGpsGrantedPermission: false, isGpsEnabled: false )) {

    on<GpsAndPermissionEvent>((event, emit)=> emit( state.copyWith( 
      isGpsEnabled: event.isGpsEnabled,
      isGpsGrantedPermission: event.isGpsPermissionGranted
    )));

    _init();
  }

  Future<void> _init()async{

    // final isEnable = await _checkGpsStatus();
    // final isGranted = await _isPermissionGranted();

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted()
    ]);

    add( GpsAndPermissionEvent(
      isGpsEnabled: gpsInitStatus[0], 
      isGpsPermissionGranted: gpsInitStatus[1]
    ));

  }

  Future<bool>_checkGpsStatus()async{
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSuscription = Geolocator.getServiceStatusStream().listen((event) { 
      final isEnable = ( event.index == 1 ) ? true : false;

      add( GpsAndPermissionEvent(
        isGpsEnabled: isEnable, 
        isGpsPermissionGranted: state.isGpsGrantedPermission 
      ));

    });

    return isEnable;
  }

  Future<void> askGpsAccess()async{

    final status = await  Permission.location.request();

    switch( status ){
      case PermissionStatus.granted:
        add( GpsAndPermissionEvent(isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true ));
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add( GpsAndPermissionEvent(isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: false ));
        break;
    }
  }

  Future<bool> _isPermissionGranted()async{
    return await Permission.location.isGranted;
  }

  @override
  Future<void> close() {
    //Limpiar el ServiceStatus Stream 
    gpsServiceSuscription?.cancel();

    return super.close();
  }

}
