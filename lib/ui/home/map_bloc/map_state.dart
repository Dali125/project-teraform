part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}


class GeoPointsLoading extends MapState{

}


class GeoPointsLoaded extends MapState{

  final List<GeoPoint> geoPoints;

  GeoPointsLoaded(this.geoPoints);


}
