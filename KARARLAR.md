# ahmetoff.com — tasarım kararları

Siteye hangi makineden ya da oturumdan dokunulursa dokunulsun önce bu dosya okunur.
Yeni bir karar alınınca buraya eklenir. İş akışı: başta `git pull`, sonda `git push origin main`.
Patch dosyası ya da push edilmemiş commit bırakılmaz.

## Giriş sayfası (8 Kasım 2026)
- Slogan satırı ("Tasarlar, kodlar, üretir.") sayfada yok. Cümle yalnızca arama motorlarına
  verilen kişi tanımında (JSON-LD) duruyor; orada kalacak.
- Konum satırı ("ahmetoff, İstanbul") en üstte, ince (300).
- İsim küçük ve çok ince: Onest 200, `clamp(46px,4.6vw,56px)`.
- Alt yazı ("Merak ettiği şeyleri yaparak öğrenir.") tek satır, "Çandöken" genişliğinde, açık gri.
- Bölümler kutu değil, yan yana kelime: Tasarım · Yazılım · Üretim · Araştırma (açıklamaları gizli).
  Telefonda dördü tek satıra sığacak kadar küçülür.
- Alt bağlantılar (Hakkımda, GitHub, Blog, ORCID) çerçevesiz, bölüm kelimeleriyle aynı genişlikte,
  sahnedeki yatay çizgilerden birinin üstüne oturur.
- Sahne ipucu yazısı küçük (12px) ve ince.

## İçerik
- Ana sayfada dört bölüm var: Tasarım, Yazılım, Üretim, Araştırma. Üretim ve Yazılım'daki
  "Önceki çalışmalar" ile Araştırma'daki "Yazılar" blog yazılarına bağlanır; kart görselleri `img/blog/`.
- 3D Dizayn 2026 başında kapandı: her yerde geçmiş zamanla, "1994–2026" diye anılır.
- 3D Print Model Kontrol ayrıntılı sayfada yalnızca Tarayıcı araçları'nda yer alır.
- `ayrintili.html` ana sayfadaki her şeyi içermeli ("her şey tek sayfada").
- Sosyal medya (Instagram, YouTube) şimdilik eklenmiyor.

## Blog
- Blog statik HTML, üretici betik yok. Kategori satırı her sayfada kopya olduğundan
  kategori değişikliği bütün `blog/**/*.html` dosyalarına uygulanmalı.
- Kategoriler: Üretim, Yazılım, Düşünce, Resim ve fotoğraf, Genel. Genel kalacak.
- Eski kategori adresleri (3d-printer, 3d-projeler, foto, resim) yenilerine yönlenir.
- Blogun adı "everything is in one place" olarak kalır.

## CGTrader (8 Kasım 2026)
- CGTrader profili (cgtrader.com/designers/ahmetoff, 62 model) Tasarım bölümünde "3D modeller" başlığıyla yer alır
  (Üretim değil: modeller 3ds Max/V-Ray görselleştirme işi, 3D baskı modeli yok). `ayrintili.html`'de 3D Dizayn listesinde.
- Adres JSON-LD `sameAs` listesinde.
- Vefa notu her zaman kalır: "Modellerin bir kısmı, 3D Dizayn'daki ortağı Mim. Şenay Gök Ataman'ın çalışmasıdır."
- Vitrin (8 model): hamam kurnası, oryantal pano, yuvarlak bank, fener, şişe avize, masaj yatağı, deri berjer,
  ahşap sandalye. Görseller `img/cgtrader/` (560×350), kaynağı `H:GB_ahmet_USB\...medya\Cgtrader\..........yayında`
  önizlemeleri. Marka/telifli tasarımlar (Eames, Meridiani, Maxalto, Darth Vader) vitrine konmaz. Ayrı CGTrader adresi
  bilinmeyen kartlar profile bağlanır.
