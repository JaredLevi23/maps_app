part of 'gps_bloc.dart';

class GpsState extends Equatable {

  final bool isGpsEnabled;
  final bool isGpsGrantedPermission;

  bool get isAllGranted => isGpsEnabled && isGpsGrantedPermission;

  const GpsState({
    required this.isGpsGrantedPermission,
    required this.isGpsEnabled
  });

  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsGrantedPermission
  })=> GpsState(
    isGpsGrantedPermission: isGpsGrantedPermission ?? this.isGpsGrantedPermission, 
    isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled
  );
  
  @override
  List<Object> get props => [ isGpsGrantedPermission, isGpsEnabled ];

  @override
  String toString() {
    return '{ isGpsEnabled: $isGpsEnabled, isGpsGrantedPermission: $isGpsGrantedPermission }';
  }
}
