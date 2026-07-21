Update Document

# MapVina Flutter Demo Application

## Giới Thiệu

Đây là ứng dụng demo cho MapVina Flutter GL - một thư viện bản đồ mạnh mẽ dành cho ứng dụng Flutter. Ứng dụng demo này minh họa các tính năng chính của MapVina bao gồm hiển thị bản đồ, tìm kiếm địa chỉ, clustering, animation, và nhiều tính năng khác trên nhiều quốc gia khác nhau.

## Tính Năng Chính

- 🗺️ **Hiển thị bản đồ đa quốc gia**: Hỗ trợ Việt Nam, Singapore, Thailand, Taiwan, Malaysia
- 🔍 **Tìm kiếm địa chỉ**: Autocomplete với API geocoding
- 📍 **Định vị GPS**: Lấy vị trí hiện tại của người dùng
- 🎯 **Waypoint Navigation**: Tính năng điều hướng với điểm đi và điểm đến
- 🔘 **Clustering**: Hiển thị dữ liệu cluster từ API
- ✨ **Animation**: Demo các hiệu ứng animation trên bản đồ
- 🗂️ **Quản lý trạng thái**: `flutter_bloc` (BLoC pattern)

## Mục Lục

1. [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
2. [Cài Đặt](#cài-đặt)
3. [Cấu Trúc Dự Án](#cấu-trúc-dự-án)
4. [Các Trang Demo](#các-trang-demo)
5. [Cấu Hình Theo Nền Tảng](#cấu-hình-theo-nền-tảng)
6. [API và Services](#api-và-services)
7. [Xử Lý Sự Cố](#xử-lý-sự-cố)
8. [Tài Nguyên](#tài-nguyên)

## Yêu Cầu Hệ Thống

Trước khi chạy ứng dụng demo này, hãy đảm bảo bạn có:

- Flutter SDK đã cài đặt (phiên bản 2.18.6 hoặc cao hơn)
- Dart SDK 2.18.6 hoặc cao hơn
- Android Studio hoặc Xcode (cho development mobile)
- Hiểu biết cơ bản về phát triển Flutter

## Cài Đặt

### Bước 1: Clone Repository

```bash
git clone <repository-url>
cd mapvina-document-flutter-github
```

### Bước 2: Cài Đặt Dependencies

Ứng dụng sử dụng các dependencies chính sau:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

  # MapVina Core
  mapvina_gl: 1.0.0

  # State Management
  flutter_bloc: ^8.1.4

  # Location
  geolocator: ^11.0.0
  permission_handler: ^11.3.1

  # Networking
  dio: ^4.0.0
  http: ^1.2.0

  # Data Persistence
  shared_preferences: ^2.3.2

  # UI & Utils
  flutter_screenutil: ^5.7.0
  textfield_tags: ^3.0.1
  dropdown_button2: ^2.3.9
  url_launcher: ^6.3.2
  intl: 0.18.0

  # JSON Serialization / Codegen
  freezed: ^2.0.4
  json_serializable: ^6.2.0

# ⚠️ Ghim phiên bản plugin dùng Gradle DSL cổ điển (xem mục "Kiểm chứng Build & Runtime").
dependency_overrides:
  url_launcher_android: 6.3.29
  shared_preferences_android: 2.4.13
```

Chạy lệnh sau để cài đặt dependencies:

```bash
flutter pub get
```

> ℹ️ **Đồng bộ với `pubspec.yaml` thực tế:** dự án **không** dùng `rudder_sdk_flutter`
> (đã bỏ khỏi tài liệu). `permission_handler` là `^11.3.1`, `shared_preferences` là
> `^2.3.2`, `url_launcher` là `^6.3.2`.

### Bước 3: Cấu Hình Platform

## Triển Khai Cơ Bản

### Bước 1: Import Package MapVina

Thêm dòng import sau vào file Dart của bạn:

```dart
import 'package:mapvina_gl/mapvina_gl.dart';
```

### Bước 2: Tạo Map Controller

Định nghĩa biến controller để quản lý bản đồ:

```dart
MapvinaMapController? mapController;
```

### Bước 3: Triển Khai Widget Bản Đồ

Thêm widget MapvinaMap vào phương thức build:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: MapvinaMap(
      onMapCreated: _onMapCreated,
      styleString: "https://maps.mapvina.com/styles/v2/streets.json?key=public",
      initialCameraPosition: const CameraPosition(target: LatLng(16.25658, 106.31679), zoom: 4.8),
      onStyleLoadedCallback: _onStyleLoadedCallback,
    ),
  );
}
```

### Bước 4: Triển Khai Các Callback

Thêm các phương thức callback cần thiết:

```dart
void _onMapCreated(MapvinaMapController controller) {
  mapController = controller;
}

void _onStyleLoadedCallback() {
  // Code thực thi sau khi style bản đồ được tải
  // Ví dụ: thêm markers, polylines, v.v.
}
```

## Tính Năng Nâng Cao

### Thêm Markers

Để thêm marker vào bản đồ:

```dart
Symbol addMarker(LatLng position) {
  final SymbolOptions symbolOptions = SymbolOptions(
    geometry: position,
    iconImage: 'marker-icon', // Đảm bảo asset này có sẵn
    iconSize: 1.5,
  );
  
  return mapController!.addSymbol(symbolOptions);
}
```

### Theo Dõi Vị Trí Người Dùng

Bật tính năng theo dõi vị trí người dùng:

```dart
MapvinaMap(
  // Các thuộc tính khác...
  myLocationEnabled: true,
  myLocationTrackingMode: MyLocationTrackingMode.Tracking,
  myLocationRenderMode: MyLocationRenderMode.COMPASS,
)
```

### Điều Khiển Tương Tác Bản Đồ

Bật các điều khiển tương tác bản đồ:

```dart
MapvinaMap(
  // Các thuộc tính khác...
  compassEnabled: true,
  zoomGesturesEnabled: true,
  tiltGesturesEnabled: true,
  rotateGesturesEnabled: true,
)
```

### Xử Lý Sự Kiện Click Bản Đồ

Xử lý sự kiện click trên bản đồ:

```dart
MapvinaMap(
  // Các thuộc tính khác...
  onMapClick: (Point<double> point, LatLng coordinates) {
    // Xử lý sự kiện click
    print("Đã click tại: ${coordinates.latitude}, ${coordinates.longitude}");
  },
)
```

### Di Chuyển Camera

Điều khiển camera theo chương trình:

```dart
// Di chuyển camera đến vị trí cụ thể
mapController?.animateCamera(
  CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), zoomLevel),
);

// Di chuyển camera để vừa với vùng giới hạn
mapController?.animateCamera(
  CameraUpdate.newLatLngBounds(
    LatLngBounds(
      southwest: LatLng(southwestLat, southwestLng),
      northeast: LatLng(northeastLat, northeastLng),
    ),
    left: 50,
    top: 50,
    right: 50,
    bottom: 50,
  ),
);
```

## Cấu Hình Theo Nền Tảng

### Cấu Hình Android

Cấu hình thực tế của dự án (`android/app/build.gradle`):

```gradle
android {
    compileSdkVersion 36
    ndkVersion "28.1.13356709"
    namespace "com.example.mapvina"
    defaultConfig {
        applicationId "com.example.mapvina"
        minSdkVersion 26
        targetSdkVersion 35
    }
}
```

Toolchain (`android/settings.gradle`): AGP `8.9.1`, Kotlin `2.2.20`, Gradle wrapper `8.11.1`.

Quyền trong `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

> ⚠️ **Hai chỉnh sửa bắt buộc để build được Android** (đã áp dụng, xem mục "Kiểm chứng"):
> 1. **Ghim plugin dùng Gradle DSL cổ điển** trong `pubspec.yaml` (`url_launcher_android: 6.3.29`,
>    `shared_preferences_android: 2.4.13`). Bản mới hơn dùng DSL `kotlin { compilerOptions {} }`
>    của AGP built-in Kotlin mà toolchain AGP 8.9 không biên dịch được.
> 2. **Thêm `mavenLocal()`** vào `android/build.gradle` (`allprojects.repositories`): artifact
>    `android-sdk-geojson:1.0.0` publish công khai đóng gói sai namespace `com.mapvina.geojson.*`,
>    trong khi `mapvina_gl` cần `io.github.mapvina.geojson.*` (bản đúng chỉ có trong Maven local).

### Cấu Hình iOS

1. Cập nhật file `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Ứng dụng cần quyền truy cập vị trí khi đang mở.</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
<key>MGLMapboxMetricsEnabledSettingShownInApp</key>
<true/>
```

2. Native iOS (`MapVina.xcframework`) được cung cấp qua **Swift Package Manager** từ MapVina GL
   Native Distribution — podspec **cố ý không** khai báo dependency này. Vì vậy **bắt buộc bật
   Flutter SPM** trước khi build iOS:

   ```bash
   flutter config --enable-swift-package-manager
   ```

   Nếu không bật, build iOS sẽ lỗi `Unable to resolve module dependency: 'MapVina'`.
   Package native: [MapVina GL Native Distribution](https://github.com/mapvina/mapvina-gl-native-distribution) (pin `exact: "1.0.0"`).

### Cấu Hình Web

Đối với hỗ trợ web, đảm bảo bạn đã cài đặt và cấu hình đúng package `mapvina_gl_web`.

## Xử Lý Sự Cố

### Vấn Đề Thường Gặp

1. **Bản đồ không hiển thị**: Kiểm tra URL style và kết nối internet.
2. **Vị trí không hoạt động**: Kiểm tra cấu hình quyền truy cập.
3. **Markers không hiển thị**: Xác minh assets marker đã được thêm đúng cách.

### Mẹo Debug

- Sử dụng lệnh `print` hoặc logger để theo dõi các sự kiện vòng đời bản đồ.
- Kiểm tra console để xem thông báo lỗi liên quan đến MapVina.
- Xác minh tất cả dependencies đã được cài đặt và cập nhật đúng cách.

## Hình Ảnh Demo

<p align="center">
  <img src="https://git.advn.vn/sangnguyen/mapvina-document/-/raw/master/images/flutter_1.png" alt="FLUTTER" width="18%">   
  <img src="https://git.advn.vn/sangnguyen/mapvina-document/-/raw/master/images/flutter_2.png" alt="FLUTTER" width="18%">
  <img src="https://git.advn.vn/sangnguyen/mapvina-document/-/raw/master/images/flutter_3.png" alt="FLUTTER" width="18%">
  <img src="https://git.advn.vn/sangnguyen/mapvina-document/-/raw/master/images/flutter_4.png" alt="FLUTTER" width="18%">
</p>

## Tài Nguyên

### Repository Chính Thức

- [MapVina Flutter GL (Thư viện chính)](https://github.com/mapvina/flutter-mapvina-gl)
- [MapVina GL Native Distribution (Native iOS)](https://github.com/mapvina/mapvina-gl-native-distribution)
- [MapVina Flutter GL - iOS Podspec](https://github.com/mapvina/flutter-mapvina-gl/tree/main/mapvina_gl/ios)

### Dự Án Mẫu

Repository MapVina Flutter GL chứa các dự án mẫu minh họa các tính năng và trường hợp sử dụng khác nhau. Clone repository và khám phá các ví dụ để hiểu rõ hơn cách triển khai các tính năng cụ thể.

### Hỗ Trợ Cộng Đồng

Nếu bạn gặp vấn đề hoặc có câu hỏi, bạn có thể:
- Tạo issue trên GitHub repository
- Kiểm tra các issue hiện có để tìm giải pháp
- Đóng góp cho dự án bằng cách gửi pull requests

## ✅ Kiểm chứng Build & Runtime

Tài liệu này đã được đồng bộ với codebase và **kiểm chứng bằng build + chạy thực tế** trên
Android emulator và iOS simulator (Flutter `3.41.6`, Dart `3.11.4`).

### iOS — chạy được (đã kiểm chứng)
- Bật `flutter config --enable-swift-package-manager`, sau đó `flutter build ios --debug --simulator`
  build thành công (SPM tự tải `MapVina.xcframework` từ mapvina-gl-native-distribution `1.0.0`).
- Chạy trên iPhone 16 simulator: **style "streets" của MapVina render đúng** (nền đất be
  `rgb(244,244,232)`, nước xanh `rgb(138,212,249)`), không crash. Ảnh: `simulator_ios_map_verification.png`.

### Android — build được; **runtime bị chặn bởi lỗi plugin** (đã kiểm chứng)
- Sau 2 chỉnh sửa (ghim plugin + `mavenLocal()`), `flutter build apk --debug` thành công.
- **Nhưng khi chạy, app crash native:** `std::runtime_error: You must provide API key for tile sources`.
  Nguyên nhân: plugin `mapvina_gl 1.0.0` khởi tạo SDK bằng `MapVina.getInstance(context)` (không kèm
  API key) tại `MapVinaMapController`. Bản 1-tham-số này reset `apiKey = null`, nên tile source bị hủy.
  Khởi tạo key ở `MainActivity` **không có tác dụng** vì plugin ghi đè lại thành null.
- **Đã kiểm chứng cách khắc phục:** patch tạm plugin để gọi
  `MapVina.getInstance(context, "public", WellKnownTileServer.MapVina)` → app chạy, **style MapVina
  render đúng** (nền be + nước xanh, giống iOS). Ảnh: `emulator_android_map_verification.png`.

> 👉 **Khuyến nghị (upstream):** phát hành lại `mapvina_gl` để truyền API key khi khởi tạo native SDK
> (hoặc thêm API Dart để set key/tile-server). Đồng thời publish lại `android-sdk-geojson` đúng
> namespace `io.github.mapvina.geojson.*` để không phải phụ thuộc `mavenLocal()`.

### Style URLs (khớp `lib/constants.dart`)
- Streets: `https://maps.mapvina.com/styles/v2/streets.json?key=public` (và các domain vùng: `sg-`, `th-`, `tw-`, `my-`).
- Satellite/3D: `https://tiles.mapvina.com/sats/v1/satellite/satellite.json?key=public`.

### Chưa kiểm chứng trong môi trường này
- Điều hướng waypoint, geocoding/autocomplete API, và chạy trên thiết bị thật phụ thuộc mạng/khoá; chỉ mô tả theo mã nguồn.

---

## Kết Luận

MapVina cung cấp giải pháp bản đồ mạnh mẽ cho ứng dụng Flutter với nhiều tính năng và tùy chọn tùy chỉnh. Bằng cách làm theo hướng dẫn này, bạn có thể tích hợp thành công MapVina vào dự án Flutter của mình và tận dụng các khả năng của nó để tạo trải nghiệm bản đồ hấp dẫn cho người dùng.