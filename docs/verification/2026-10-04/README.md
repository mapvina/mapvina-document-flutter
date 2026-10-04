# mapvina-document-flutter: verification 04/10/2026

**Status: BLOCKED.**

Three public Flutter packages resolve `1.0.1`; native dependency resolution/runtime is not accepted.

Source baseline: `fbb788d9d31d08e4c4e2acb8e944020acbef5671` (`origin/main` plus the sample/doc changes in this PR).

Audit only: no SDK API/version changes, tags, publishing or main merge.

## Tái hiện với package pub.dev

Sample pin `mapvina_gl: 1.0.1`, không dùng path override và không dùng Maven local
trong repositories của app. Lockfile được resolve lại bằng Flutter 3.41.6 /
Dart 3.11.4; các thay đổi dependency transitive do constraints toolchain được giữ
trong lockfile để phản ánh chính xác input đã thử.

```bash
flutter pub get
flutter build apk --debug --no-pub
flutter build ios --simulator --debug --no-pub
```

- Pub get: PASS; mapvina_gl/web/platform_interface đều `1.0.1`.
- Android: BLOCKED tại `url_launcher_android-6.3.32/android/build.gradle.kts`,
  `compilerOptions`/`jvmTarget` không resolve. Chưa đến map runtime.
- iOS: BLOCKED tại Swift compiler, `Unable to resolve module dependency: 'MapVina'`
  từ `mapvina_gl-1.0.1/.../Constants.swift`. Chưa chạy simulator.
- Lỗi API key runtime ghi nhận tháng 9 không được tái xác nhận hôm nay, vì build
  hiện tại đã chặn trước runtime. Không đánh dấu lỗi cũ là kết quả mới.

Các ví dụ API, cấu hình quyền và style ở README là tham khảo, không phải golden
path production đã chạy được. Không thêm key bằng workaround SDK/local cache
để che lỗi package public. API key, logo và layout runtime: NOT TESTED.
Không sửa logic wrapper, nâng SDK version hoặc publish pub.dev trong PR này.

## Evidence and acceptance boundary

- [flutter-pub-get.log](evidence/flutter-pub-get.log)
- [flutter-android.log](evidence/flutter-android.log)
- [flutter-ios.log](evidence/flutter-ios.log)

[Cross-repository artifact and runtime audit](https://github.com/mapvina/mapvina-document-android/blob/codex/docs-verification-20261004/docs/verification/2026-10-04/README.md).

PASS applies only to the named checks. BLOCKED is a reproduced failure; NOT TESTED is not a pass.

## Separate follow-up

[Reproduced blocker issue](https://github.com/mapvina/flutter-mapvina-gl/issues/33). SDK/infra fixes are outside this PR.
