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

## Telefon görünümü (8 Kasım 2026)
- Sahne telefonda kalan yüksekliğe göre: `clamp(220px,calc(100svh - 370px),420px)`, viewBox `0 70 440 520`. İsim (40px), dört bölüm,
  alt bağlantılar ve en alttaki "© 2026 … Son güncelleme" satırı ilk ekrana sığar (640 px yüksek telefonda da);
  cisim tutulunca ipler bölümlere görünür biçimde ulaşır.
- Cisimlerde `touchstart` engellenir (sayfa kaymasın, sürükleme kesilmesin); gölgeler (`.shd`) telefonda tutulmaz.
- İki kez dokununca cisimler yerine döner (dblclick yerine dokunma sayacı).
- İpucu yazısı dokunmatik ekranda: "Cisimleri parmağınla sürükle; iki kez dokununca yerlerine döner."
- İp tuvali (`#ropes`) CSS boyutu JS ile innerWidth/innerHeight'e eşitlenir; 100vh kullanılmaz (telefonda adres çubuğu yüzünden ipler yanlış yeri gösteriyordu).
- ≤440px'te dört bölüm tek satır (16px, iki yana yaslı).

## Sahne ve başlık (8 Kasım 2026)
- Cisim gölgeleri kemerin üstüne düşmez: gölge kemerin arkasındaysa (zemin y < 515) kemerin altında çizilir ve kemer onu örter,
  önündeyse önde çizilir. Kemer taşınınca diğer gölgeler yeniden sıralanır.
- Alt yazı ("Merak ettiği şeyleri…") soyada yakın ama yapışık değil: `display:block;width:max-content;margin-top:6px` (~7px boşluk).
  Telefonda altındaki bölüm grubu `margin-top:28px`.
- Telefonda sahne yüksekliğini JS belirler: ekran yüksekliği − (sahne dışındaki içerik) − 16px, 220–620px arası.
  Yalnız genişlik değişince yeniden hesaplanır (adres çubuğu açılıp kapanınca zıplamasın). CSS clamp yedek olarak durur.
- Zemin ufkun önünde de devam eder: merdiven öndeyken (y > 410) adam ufuk çizgisine ışınlanmaz, merdivenin dibinden tırmanır.
  Merdiven zeminden 24 birime kadar yukarıdaysa "yerde" sayılır (harflere çarpıp hafif havada kalınca adam takılmasın).
- Çizgi adam derinliğe göre katmanlanır: zemindeki konumu (merdivendeyken merdivenin dibi) hangi cismin önündeyse
  o cisim onu örter, arkasındakilerin önünde görünür. Bir cismin üstünde dinlenirken o cismin hemen önünde çizilir; harflerin üstündeyken hep önde.

## İçerik
- Ana sayfada dört bölüm var: Tasarım, Yazılım, Üretim, Araştırma. Üretim ve Yazılım'daki
  "Önceki çalışmalar" ile Araştırma'daki "Yazılar" blog yazılarına bağlanır; kart görselleri `img/blog/`.
- 3D Dizayn 2026 başında kapandı: her yerde geçmiş zamanla, "1994–2026" diye anılır.
- 3D Print Model Kontrol ayrıntılı sayfada yalnızca Tarayıcı araçları'nda yer alır.
- `ayrintili.html` ana sayfadaki her şeyi içermeli ("her şey tek sayfada").
- Sosyal medya (Instagram, YouTube) şimdilik eklenmiyor.

## Lamba3D (8 Kasım 2026)
- Ahmet'in en önemli tasarım ve imalat projesi. Üretim bölümünün en üstünde öne çıkan blok (feature) olarak durur,
  Hakkımda'da da (ana sayfa ve ayrıntılı) "en önemli tasarım ve imalat işi" diye anılır. Görsel yerine bitmiş lambanın videosu (9 Kasım 2026, Ahmet isteği: "bitmiş videoya ulaşmak kolay olsun"): `img/blog/lamba3d-final.mp4` (kaynak `H:\PRJ\PRJ-www\Youtube\Lamba\Lamba3D-final.mp4`, 37 sn, 720p), kapak görseli `img/blog/lamba3d-kapak.jpg` poster olarak.

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
- Hamam kurnası Ahmet'in işi (Şenay'ın değil). Kartlarda tek tek isim yazılmaz; yalnızca koleksiyon altındaki genel not kalır.

## Teknik (8 Kasım 2026)
- Sayfa içine base64 görsel gömülmez; görseller ayrı dosya (`img/ana/` vb.). index.html 1,16 MB → 79 KB oldu.
- Paylaşım önizlemesi: `img/og.png` (1200×630, ana sayfa görüntüsü); index ve ayrintili'de og:image + twitter:card.
- Cloudflare Web Analytics: her HTML'in `</body>` öncesinde beacon (cloudflareinsights). Yeni sayfaya da eklenir.
  Ziyaret verisi sitede gösterilmez; yalnız Ahmet sorduğunda söylenir.

## Robot kol (9 Kasım 2026)
- Blog yazısı `/blog/2026/11/09/robot-kol/` (Üretim). Metin Ahmet'in kendi sözleri (yalnız yazım düzeltmesi); altına tarih/teknik özet ve fotoğraf/video bölümleri.
- Medya `blog/media/2019/06/robot-kol-*` (13 foto 1200px, 5 video ≤720p). Videolar Instagram'a bağlı değil, sitede barınır.
- Ana sayfa Üretim > Elektronik ve nesneler'de 2019 kartı (`img/blog/robot-kol.jpg`), ayrintili.html'de de var.
- Yazıya Ahmet'in kendi çizimleri eklendi: devre şeması (`Robot kol şema-2.jpg`) ve AutoCAD tork hesabı (`Robot kol tork hesabı.dwg` + altlık foto IMAG3902, ODA + ezdxf ile görüntüye çevrildi). Adaptör görseli küçük (190px).

## Ev tipi klima (9 Kasım 2026)
- Blog yazısı `/blog/2026/11/09/ev-tipi-klima/` (Üretim). Metin Ahmet'in (yalnız yazım düzeltmesi: buzluğa, serinliyordum). Medya `blog/media/2021/08/klima-*` (orijinaller `H:\PRJ\PRJ_klima`). Ana sayfa ve ayrintili'de 2021 kartı.

## Bakım turu (10 Kasım 2026)
- Blog görselleri en fazla 2000 px'e indirildi ve yeniden sıkıştırıldı (309 MB → 62 MB, 263 dosya). Asıllar git geçmişinde duruyor;
  geçmiş yeniden yazılmadı (diğer makinelerdeki kopyalar bozulmasın). Yeni görseller de aynı sınırla eklenir.
- Ayrıntılı sayfanın açılışı ana sayfanın diline çekildi: "Tasarlar, kodlar, üretir…". "Disiplin" kutusu "Alanlar: Tasarım · Yazılım · Üretim · Araştırma"
  oldu; iç mimarlık yalnızca Eğitim bölümünde. Ahmet iç mimar diye öne çıkarılmak istemiyor.
- Ayrıntılı sayfanın gövde yazı tipi Instrument Sans → Onest, vurgu rengi ana sayfanın turkuazı. Pafta düzeni, Gloock başlıklar ve mono etiketler kalır.
- İngilizce tek sayfa: `/en/` (tam çeviri değil, siteye kısa rehber). Ana sayfada konum satırının yanında "English", ayrıntılı'da "← Ana sayfa" yanında.
  index ve en'de hreflang. Site içeriği değişince /en/ de güncellenir.
- Araç bağlantıları doğrudan `https://ahmetoff.com/ahmetoff/...` (github.io adresi zaten buraya yönleniyordu).
  ahmet3ddd/ahmetoff reposundaki 10 araca sol altta "← ahmetoff.com" düğmesi eklendi; 5 sn sonra küçük oka döner.
- Girişteki ince alt yazı ve 12 px ipucu yazısına dokunulmadı (8 Kasım kararı).
- İletişim: sitede yayınlanmış e-posta yok. Hangi adresin yazılacağı Ahmet'e soruldu; karar gelene kadar eklenmez.

## İletişim (10 Kasım 2026)
- Sitedeki iletişim adresi: iletisim@ahmetoff.com (Cloudflare Email Routing ile Ahmet'in Gmail'ine yönlenir). Gmail adresi sitede yayınlanmaz:
  beyin notlarının işlendiği kutu o, açıkta durursa dışarıdan "[beyin-not]" sokulabilir.
- Adres sayfa kaynağında düz yazılmaz; küçük bir betik `a.mail` bağlantılarını açılışta doldurur (betik yoksa "iletisim (at) ahmetoff.com").
- Ana sayfada "İletişim" e-posta programını açmaz, kendi panelini açar (`#iletisim`, diğer bölümler gibi): büyük adres,
  "E-posta yaz" ve "Adresi kopyala" düğmeleri, altında GitHub, Blog, ORCID, CGTrader. Hakkımda'daki E-posta satırı bu panele gider.
  Panel düğmeleri `.mbtn` (eski `.btn` başka yerde kullanılıyor). Ayrintili Pafta 05 ve /en/ Elsewhere'da adres doğrudan yazılı.
- (10 Kasım 2026, sonra) Panelde "E-posta yaz" (mailto) Windows'ta varsayılan e-posta programı yoksa hiçbir şey açmıyordu.
  Düğmeler: "Gmail ile yaz" ve "Outlook ile yaz" (web yazma penceresi, yeni sekme), "E-posta uygulaması" (mailto), "Adresi kopyala".
- İletişim formu (10 Kasım 2026): panelde Ad / E-posta / Mesaj formu, "Gönder" mesajı doğrudan Gmail'e iletir. Altında "Ya da kendi
  e-postanızdan": adres, Gmail ile yaz, Outlook ile yaz, kopyala.
- Gönderici: Cloudflare Worker "ahmetoff-iletisim" (https://ahmetoff-iletisim.3ddizayn-proje.workers.dev/), kaynağı `worker/iletisim-worker.js`.
  Email Service bağlaması SEB, ortam değişkeni TO = Gmail adresi (kaynakta yazmaz). Gönderen iletisim@ahmetoff.com, ziyaretçi Reply-To'da.
  Yalnız ahmetoff.com kökenli istekleri kabul eder; görünmez alan ve 3 sn tuzağı var. Konu sabit "ahmetoff.com iletişim formu".
  Kod değişirse: dosyayı güncelle, Cloudflare'da Worker'ın "Edit code" ekranına yapıştırıp Deploy.
- form.ahmetoff.com özel alan adı denendi; DNS değişikliği izni gerektirdiği için yapılmadı. Workers.dev adresi kullanılıyor.
- (10 Kasım 2026) İngilizce bağlantısı sağ üstte: tema düğmesinin solunda aynı boyda "EN" düğmesi (`.langsw`, sabit konum),
  ana sayfada ve ayrıntılı sayfada. Konum satırındaki "· English" ve ayrıntılı'daki üst "English" bağlantısı kaldırıldı.
  Alt bölümlerin üst çubuğunda sağ boşluk 88 px (iki düğme sığsın).
