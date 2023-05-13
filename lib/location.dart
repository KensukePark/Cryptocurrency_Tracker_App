/*
import 'package:geolocator/geolocator.dart';

Future<Position?> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 위치 서비스 사용 가능 여부 확인
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 위치 서비스를 사용할 수 없으면 null 반환
    return null;
  }

  // 위치 권한 확인
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // 위치 권한이 없으면 요청
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 위치 권한이 없으면 null 반환
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // 위치 권한이 영구적으로 거절되면 null 반환
    return null;
  }

  // 위치 정보 가져오기
  return await Geolocator.getCurrentPosition();
}
 */
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Location {
  late double latitude2;
  late double longitude2;

  Future<void> getMyCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    // 위치권한을 가지고 있는지 확인
    var status_position = await Permission.location.status;
    if (status_position.isGranted) {
      // 1-2. 권한이 있는 경우 위치정보를 받아와서 변수에 저장합니다.
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      latitude2 = position.latitude;
      longitude2 = position.longitude;

    } else {
      // 1-3. 권한이 없는 경우
      print("위치 권한이 필요합니다.");
    }
  } // ...getMyCurrentLocation()

}