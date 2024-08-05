# Flutter Map Project

Bu proje, [Flutter Map](https://pub.dev/packages/flutter_map) kütüphanesini kullanarak bir harita uygulaması oluşturmak amacıyla geliştirilmiştir. Uygulama, haritada marker'lar eklemeye, silmeye, güncellemeye ve marker'ların belirli bir mesafeye göre renk almasını sağlamaya olanak tanır. Ayrıca, WMS katmanları ekleyebilir ve haritayı zoom yapabilirsiniz.

## Özellikler

- Haritada marker ekleme, güncelleme ve silme
- Marker'ların, bir önceki marker'a olan uzaklığa göre renk değiştirmesi
- WMS (Web Map Service) katmanları ekleme ve çıkarma
- Harita üzerinde animasyonlu zoom yapabilme
- Mouse tekerleği ile zoom in/out (deneme aşamasında)

## Gereksinimler

- Flutter SDK >= 2.12.0 < 3.0.0
- Dart SDK
- `get` paketinin versiyonu: ^4.6.6
- `flutter_map` paketinin versiyonu: ^5.0.0
- `latlong2` paketinin versiyonu: ^0.9.1
- `flutter_map_marker_popup` paketinin versiyonu: ^5.0.0

## Kurulum

1. **Projeyi klonlayın:**

    ```bash
    git clone https://github.com/YasinSeyhun/leaflet-map-app
    cd proje_adi
    ```

2. **Gereksinimleri yükleyin:**

    ```bash
    flutter pub get
    ```

3. **Uygulamayı çalıştırın:**

    ```bash
    flutter run
    ```

## Kullanım

- Haritaya tıklayarak yeni bir marker ekleyebilirsiniz.
- Marker'ların üstüne tıklayarak popup ile detayları görüntüleyebilirsiniz.
- WMS katmanlarını sağ üstteki butonlar ile açıp kapatabilirsiniz.
- Sol üstteki butonları kullanarak haritada zoom in/out yapabilirsiniz.
- Marker renklerinden yola çıkarak markerın bir önceki markere olan uzaklığını hesaplayabilirsiniz.
- Marker ismini düzenleyebilir, ona doğrudan gidebilir ve markerı dilediğiniz gibi silebilirsiniz.
  
## Kod Düzeni

- **Model**: `marker_model.dart`
- **Controller**: `marker_controller.dart`, `map_controller.dart`
- **Services**: `map_zoom_service.dart`, `mouse_zoom_service.dart`
- **View**: `map_view.dart`, `map_marker.dart`, `marker_list.dart`, `wms_view.dart`

Proje, Dart standartlarına uygun olarak yazılmıştır. Sınıf ve dosya isimleri genel olarak Dart konvansiyonlarına uygun olup, değişkenler ve fonksiyonlar anlamlı isimlendirmelerle düzenlenmiştir.

## Geliştirme

Bu projeye katkıda bulunmak isterseniz, lütfen bir issue açın veya pull request gönderin. Her türlü geri bildirime açığız.

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasını kontrol edebilirsiniz.

