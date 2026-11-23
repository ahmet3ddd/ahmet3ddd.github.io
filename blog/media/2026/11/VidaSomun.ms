-- =====================================================================
--  Vida & Somun Üretici  (3ds Max 2019+)
--  İmbus / alyan, havşa, mercimek, torx, setskur, yıldız (Phillips),
--  düz tornavida, altıgen cıvata, somun, fiberli somun, pul.
--  M2 - M24, gerçek helis diş (isteğe bağlı), 2B önizleme + tip galerisi.
--  Kullanım: Scripting > Run Script... > VidaSomun.ms
--  Ölçüler mm cinsinden hesaplanır, sahnenin sistem birimine çevrilir.
--  Ahmet Çandöken · https://ahmetoff.com/blog/2026/11/23/vida-somun-uretici/
--  Betik Claude (Anthropic) ile yazıldı. MIT lisansı: dilediğiniz gibi kullanın.
-- =====================================================================

global vs_NO_UI
global vs_Rollout
global vs_matCache = #()

-- ---------------------------------------------------------------------
--  Tablolar (indeks = ölçü sırası)
-- ---------------------------------------------------------------------
global vs_sizes = #("M2", "M3","M4","M5","M6","M8","M10","M12","M16","M20","M24")
global vs_d     = #(2.0, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 12.0, 16.0, 20.0, 24.0)
global vs_P     = #(0.4, 0.5, 0.7, 0.8, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0)
global vs_lengths = #(3,4,5,6,8,10,12,14,16,20,25,30,35,40,45,50,55,60,65,70,80,90,100,110,120,140,160,180,200)

-- DIN 912 imbus silindir baş
global vs_dk912 = #(3.8, 5.5, 7.0, 8.5, 10.0, 13.0, 16.0, 18.0, 24.0, 30.0, 36.0)
global vs_s912  = #(1.5, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 14.0, 17.0, 19.0)
-- DIN 7991 imbus havşa baş
global vs_dk7991 = #(4.0, 6.0, 8.0, 10.0, 12.0, 16.0, 20.0, 24.0, 30.0, 36.0, 39.0)
global vs_s7991  = #(1.3, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 12.0, 14.0)
-- ISO 7380 imbus mercimek baş
global vs_dk7380 = #(3.5, 5.7, 7.6, 9.5, 10.5, 14.0, 17.5, 21.0, 28.0, 35.0, 42.0)
global vs_k7380  = #(1.3, 1.65, 2.2, 2.75, 3.3, 4.4, 5.5, 6.6, 8.8, 11.0, 13.2)
global vs_s7380  = #(1.3, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 12.0, 14.0)
-- ISO 14579 torx (T no ve uç-uç çap A)
global vs_torxT = #(6, 20, 25, 30, 40, 45, 50, 55, 70, 90, 100)
global vs_torxA = #(1.75, 3.86, 4.42, 5.53, 6.65, 7.78, 8.79, 11.1, 15.4, 17.5, 22.1)
-- DIN 913/914 setskur alyan
global vs_s913 = #(0.9, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 12.0)
-- DIN 7985 yıldız yuvarlak baş
global vs_dk7985 = #(4.0, 5.6, 8.0, 9.5, 12.0, 16.0, 20.0, 24.0, 30.0, 36.0, 42.0)
global vs_k7985  = #(1.6, 2.4, 3.1, 3.8, 4.6, 6.0, 7.5, 9.0, 12.0, 15.0, 18.0)
global vs_m7985  = #(2.0, 3.0, 4.4, 4.9, 6.6, 8.8, 10.0, 12.0, 15.0, 18.0, 22.0)
global vs_ph     = #(0, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4)
-- DIN 965 yıldız havşa baş
global vs_dk965 = #(3.8, 5.5, 8.4, 9.3, 11.3, 15.8, 18.3, 22.0, 29.0, 36.0, 39.0)
global vs_m965  = #(1.9, 3.2, 4.6, 5.2, 6.8, 8.9, 10.0, 12.0, 15.0, 18.0, 22.0)
-- DIN 84 düz tornavida silindir baş
global vs_dk84 = #(3.8, 5.5, 7.0, 8.5, 10.0, 13.0, 16.0, 18.0, 24.0, 30.0, 36.0)
global vs_k84  = #(1.3, 2.0, 2.6, 3.3, 3.9, 5.0, 6.0, 7.0, 9.0, 11.0, 13.0)
global vs_n84  = #(0.5, 0.8, 1.2, 1.2, 1.6, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0)
global vs_t84  = #(0.6, 0.85, 1.1, 1.3, 1.6, 2.0, 2.4, 2.8, 3.6, 4.4, 5.2)
-- DIN 933 altıgen başlı cıvata / DIN 934 somun / DIN 985 fiberli somun
global vs_s933 = #(4.0, 5.5, 7.0, 8.0, 10.0, 13.0, 17.0, 19.0, 24.0, 30.0, 36.0)
global vs_k933 = #(1.4, 2.0, 2.8, 3.5, 4.0, 5.3, 6.4, 7.5, 10.0, 12.5, 15.0)
global vs_m934 = #(1.6, 2.4, 3.2, 4.0, 5.0, 6.5, 8.0, 10.0, 13.0, 16.0, 19.0)
global vs_h985 = #(3.0, 4.0, 5.0, 5.0, 6.0, 8.0, 10.0, 12.0, 16.0, 20.0, 24.0)
-- DIN 125 düz pul
global vs_d1_125 = #(2.2, 3.2, 4.3, 5.3, 6.4, 8.4, 10.5, 13.0, 17.0, 21.0, 25.0)
global vs_d2_125 = #(5.0, 7.0, 9.0, 10.0, 12.0, 16.0, 20.0, 24.0, 30.0, 37.0, 44.0)
global vs_h125   = #(0.3, 0.5, 0.8, 1.0, 1.6, 1.6, 2.0, 2.5, 3.0, 3.0, 4.0)

global vs_types = #(#cap, #csk, #button, #torxcap, #setflat, #setcone, #phpan, #phcsk, #slotcheese, #hexbolt, #hexnut, #nylock, #washer)
global vs_typeNames = #(
	"İmbus silindir baş (DIN 912)",
	"İmbus havşa baş (DIN 7991)",
	"İmbus mercimek baş (ISO 7380)",
	"Torx silindir baş (ISO 14579)",
	"Setskur, düz uç (DIN 913)",
	"Setskur, sivri uç (DIN 914)",
	"Yıldız yuvarlak baş (DIN 7985)",
	"Yıldız havşa baş (DIN 965)",
	"Düz tornavida silindir baş (DIN 84)",
	"Altıgen başlı cıvata (DIN 933)",
	"Altıgen somun (DIN 934)",
	"Fiberli somun (DIN 985)",
	"Düz pul (DIN 125)")
global vs_typeShort = #("İmbus", "İmbus havşa", "İmbus mercimek", "Torx", "Setskur düz", "Setskur sivri",
	"Yıldız", "Yıldız havşa", "Düz tornavida", "Altıgen cıvata", "Somun", "Fiberli somun", "Pul")
global vs_typeCodes = #("DIN912", "DIN7991", "ISO7380", "ISO14579", "DIN913", "DIN914", "DIN7985", "DIN965",
	"DIN84", "DIN933", "DIN934", "DIN985", "DIN125")
global vs_finishNames = #("Paslanmaz çelik", "Siyah oksit", "Sarı galvaniz", "Pirinç")

struct vs_SpecS (kind, d = 0.0, P = 0.0, L = 0.0, R = 0.0, k = 0.0, c = 0.0, e = 0.0, rec = undefined,
	t = 0.0, drop = 0.0, kc = 0.0, rim = 0.0, s = 0.0, m = 0.0, h = 0.0, hm = 0.0, d1 = 0.0, d2 = 0.0, si = 1)

-- ---------------------------------------------------------------------
--  Küçük yardımcılar
-- ---------------------------------------------------------------------
fn vs_frac x = x - (floor x)

fn vs_angNorm x = (
	local y = mod x 360.0
	if y < 0 do y += 360.0
	if y >= 360.0 - 1e-9 do y = 0.0
	y
)

fn vs_uniqueSorted a = (
	local b = for x in a collect (vs_angNorm x)
	sort b
	local out = #()
	for x in b do if out.count == 0 or (x - out[out.count]) > 1e-3 do append out x
	if out.count > 1 and (out[1] + 360.0 - out[out.count]) < 1e-3 do deleteItem out out.count
	out
)

fn vs_rad p = sqrt (p.x*p.x + p.y*p.y)

fn vs_num x = (
	local v = (floor (x*100.0 + 0.5)) / 100.0
	if abs (v - (floor v)) < 0.001 then ((v as integer) as string) else (v as string)
)

fn vs_typeIndex typ = findItem vs_types typ

fn vs_hasLength typ = not (typ == #hexnut or typ == #nylock or typ == #washer)

fn vs_isHexType typ = (typ == #hexbolt or typ == #hexnut or typ == #nylock)

-- altıgen: anahtar ağzı s, köşeler 0/60/120... derecede
fn vs_hexR th s = (
	local a = mod th 60.0
	if a < 0 do a += 60.0
	(s/2.0) / (cos (a - 30.0))
)

-- torx: 6 loblu yıldız, uç-uç çap A
fn vs_torxR th A = (
	local rA = A/2.0
	local rB = A*0.36
	local c = (1.0 + (cos (6.0*th)))/2.0
	rB + (rA - rB)*(c^0.7)
)

-- merkezden th açısıyla çıkan ışının çokgeni kestiği en yakın uzaklık
fn vs_rayPoly th poly = (
	local dx = cos th
	local dy = sin th
	local best = 1e9
	local n = poly.count
	for i = 1 to n do (
		local p = poly[i]
		local q = poly[if i == n then 1 else i + 1]
		local ex = q.x - p.x
		local ey = q.y - p.y
		local den = dx*ey - dy*ex
		if (abs den) > 1e-9 do (
			local t = (p.x*ey - p.y*ex)/den
			local u = (p.x*dy - p.y*dx)/den
			if t > 1e-7 and u >= -1e-7 and u <= 1.0000001 and t < best do best = t
		)
	)
	best
)

fn vs_crossPoly L w = #([L, -w], [L, w], [w, w], [w, L], [-w, L], [-w, w], [-L, w], [-L, -w], [-w, -w], [-w, -L], [w, -L], [w, -w])

fn vs_slotPoly w = #([-1000.0, -w], [1000.0, -w], [1000.0, w], [-1000.0, w])

-- yuva (recess) tanımı: #(tür, ölçü, çokgen)
fn vs_recessR th rec = (
	case rec[1] of (
		#hex: vs_hexR (th + 30.0) rec[2]
		#torx: vs_torxR th rec[2]
		#cross: vs_rayPoly th rec[3]
		#slot: vs_rayPoly th rec[3]
		default: 0.0
	)
)

-- yıldız yuva piramit gibi daralır: uçta sığ, ortada derin
fn vs_recessDepth ri rec t = (
	if rec[1] == #cross then t*(1.0 - 0.7*(amin #(1.0, ri/rec[2]))) else t
)

-- ---------------------------------------------------------------------
--  Ölçü tanımı
-- ---------------------------------------------------------------------
fn vs_spec typ si L = (
	local sp = vs_SpecS kind:typ
	local d = vs_d[si]
	sp.si = si
	sp.d = d
	sp.P = vs_P[si]
	sp.L = L as float
	if typ == #cap then (
		sp.R = vs_dk912[si]/2.0; sp.k = d; sp.c = 0.04*vs_dk912[si]
		sp.rec = #(#hex, vs_s912[si]); sp.t = 0.55*d; sp.drop = 0.3*vs_s912[si]
	)
	else if typ == #torxcap then (
		sp.R = vs_dk912[si]/2.0; sp.k = d; sp.c = 0.04*vs_dk912[si]
		sp.rec = #(#torx, vs_torxA[si]); sp.t = 0.5*d; sp.drop = 0.2*vs_torxA[si]
	)
	else if typ == #csk then (
		sp.R = vs_dk7991[si]/2.0; sp.rim = 0.025*vs_dk7991[si]; sp.kc = sp.rim + sp.R - d/2.0
		sp.rec = #(#hex, vs_s7991[si]); sp.t = 0.7*(sp.R - d/2.0) + sp.rim; sp.drop = 0.2*vs_s7991[si]
	)
	else if typ == #button then (
		sp.R = vs_dk7380[si]/2.0; sp.k = vs_k7380[si]; sp.e = 0.18*sp.k
		sp.rec = #(#hex, vs_s7380[si]); sp.t = 0.6*sp.k; sp.drop = 0.25*vs_s7380[si]
	)
	else if typ == #setflat or typ == #setcone then (
		sp.rec = #(#hex, vs_s913[si]); sp.t = amin #(0.6*d, 0.45*L); sp.drop = 0.25*vs_s913[si]
	)
	else if typ == #phpan then (
		local m = vs_m7985[si]
		sp.R = vs_dk7985[si]/2.0; sp.k = vs_k7985[si]; sp.e = 0.55*sp.k
		sp.rec = #(#cross, m/2.0, vs_crossPoly (m/2.0) (0.1*m)); sp.t = 0.6*sp.k; sp.drop = 0.0
	)
	else if typ == #phcsk then (
		local m = vs_m965[si]
		sp.R = vs_dk965[si]/2.0; sp.rim = 0.025*vs_dk965[si]; sp.kc = sp.rim + sp.R - d/2.0
		sp.rec = #(#cross, m/2.0, vs_crossPoly (m/2.0) (0.1*m)); sp.t = 0.8*sp.kc; sp.drop = 0.0
	)
	else if typ == #slotcheese then (
		sp.R = vs_dk84[si]/2.0; sp.k = vs_k84[si]; sp.c = 0.04*vs_dk84[si]
		sp.rec = #(#slot, vs_n84[si]/2.0, vs_slotPoly (vs_n84[si]/2.0)); sp.t = vs_t84[si]
	)
	else if typ == #hexbolt then (
		sp.s = vs_s933[si]; sp.k = vs_k933[si]
	)
	else if typ == #hexnut then (
		sp.s = vs_s933[si]; sp.m = vs_m934[si]
	)
	else if typ == #nylock then (
		sp.s = vs_s933[si]; sp.h = vs_h985[si]; sp.hm = 0.72*sp.h
	)
	else if typ == #washer then (
		sp.d1 = vs_d1_125[si]; sp.d2 = vs_d2_125[si]; sp.h = vs_h125[si]
	)
	sp
)

fn vs_outerR sp = (
	local typ = sp.kind
	if vs_isHexType typ then sp.s/(sqrt 3.0)
	else if typ == #setflat or typ == #setcone then sp.d/2.0
	else if typ == #washer then sp.d2/2.0
	else sp.R
)

-- ---------------------------------------------------------------------
--  Ağ (mesh) kurucular
--  Her açı için (r,z) profil sütunu üretilir, komşu sütunlar dörtgenle
--  bağlanır. Profil (r,z) düzleminde saat yönünün tersine dolaşılırsa
--  normaller dışa bakar.
-- ---------------------------------------------------------------------
fn vs_colToXYZ col th = (
	local c = cos th
	local s = sin th
	for p in col collect [p.x*c, p.x*s, p.y]
)

fn vs_meshFromColumns cols closedProf seamShift = (
	local verts = #()
	local faces = #()
	local nc = cols.count
	local np = cols[1].count
	for col in cols do join verts col
	local jmax = if closedProf then np else np - 1
	for i = 1 to nc do (
		local i2 = if i == nc then 1 else i + 1
		local sh = if i == nc then seamShift else 0
		for j = 1 to jmax do (
			local j2 = if j == np then 1 else j + 1
			local jb = j + sh
			local jb2 = j2 + sh
			if jb >= 1 and jb2 >= 1 and jb <= np and jb2 <= np do (
				local a = (i - 1)*np + j
				local b = (i2 - 1)*np + jb
				local c = (i2 - 1)*np + jb2
				local d = (i - 1)*np + j2
				append faces [a, b, c]
				append faces [a, c, d]
			)
		)
	)
	#(verts, faces)
)

fn vs_append acc part = (
	local ofs = acc[1].count
	join acc[1] part[1]
	for f in part[2] do append acc[2] (f + [ofs, ofs, ofs])
	acc
)

fn vs_fanPart ring center normalUp = (
	local verts = #(center)
	join verts ring
	local faces = #()
	local n = ring.count
	for i = 1 to n do (
		local a = i + 1
		local b = if i == n then 2 else i + 2
		if normalUp then append faces [1, a, b] else append faces [1, b, a]
	)
	#(verts, faces)
)

fn vs_revolve prof segs closedProf = (
	local cols = for i = 0 to segs - 1 collect (vs_colToXYZ prof (360.0*i/segs))
	vs_meshFromColumns cols closedProf 0
)

-- ISO metrik diş profili (yaklaşık): tepe ve dipte küçük düzlük
fn vs_threadR z th P rMaj h = (
	local u = vs_frac ((z - P*th/360.0)/P)
	local v = (abs (u - 0.5))*2.0
	local t = (v - 0.125)/0.75
	if t < 0.0 do t = 0.0
	if t > 1.0 do t = 1.0
	rMaj - h*t
)

-- o = #(uç pahı r0, üst pah r0, alt havşa r, üst havşa r); kullanılmayan < 0
fn vs_limitR r z zb zt o = (
	if o[1] >= 0 do r = amin #(r, o[1] + (z - zb))
	if o[2] >= 0 do r = amin #(r, o[2] + (zt - z))
	if o[3] > 0 do r = amax #(r, o[3] - (z - zb))
	if o[4] > 0 do r = amax #(r, o[4] - (zt - z))
	r
)

-- Dişli (ya da düz) boru yüzeyi. Dişli olanda satırlar helisi izler,
-- böylece diş tepeleri keskin çıkar; ek yerinde satırlar 8 kayar.
fn vs_tube zb zt P rMaj h segs o internal = (
	local angs = for i = 0 to segs - 1 collect (360.0*i/segs)
	local cols = #()
	local shift = 0
	if h > 0 then (
		local dz = P/8.0
		local n = 16 + ((ceil ((zt - zb)/dz)) as integer)
		for th in angs do (
			local col = #()
			for k = 0 to n do (
				local z = zb + (k - 8)*dz + P*th/360.0
				if z < zb do z = zb
				if z > zt do z = zt
				append col [vs_limitR (vs_threadR z th P rMaj h) z zb zt o, z]
			)
			append cols (vs_colToXYZ col th)
		)
		shift = 8
	)
	else (
		local zs = #(zb, zt)
		if o[1] >= 0 do append zs (zb + rMaj - o[1])
		if o[2] >= 0 do append zs (zt - (rMaj - o[2]))
		if o[3] > 0 do append zs (zb + o[3] - rMaj)
		if o[4] > 0 do append zs (zt - (o[4] - rMaj))
		zs = for z in zs where z >= zb and z <= zt collect z
		sort zs
		local zu = #()
		for z in zs do if zu.count == 0 or (z - zu[zu.count]) > 1e-6 do append zu z
		for th in angs do (
			local col = for z in zu collect [vs_limitR rMaj z zb zt o, z]
			append cols (vs_colToXYZ col th)
		)
	)
	local part = vs_meshFromColumns cols false shift
	local faces = part[2]
	if internal do faces = for f in faces collect [f.x, f.z, f.y]
	local bot = for c in cols collect c[1]
	local top = for c in cols collect c[c.count]
	#(part[1], faces, bot, top, angs)
)

fn vs_addShank acc zb zt d P threaded tipKind = (
	local rMaj = d/2.0
	local h = if threaded then 0.6134*P else 0.0
	local rMin = rMaj - 0.6134*P
	local tipR0 = if tipKind == #cone then 0.0 else rMin*0.92
	local tube = vs_tube zb zt P rMaj h 48 #(tipR0, -1.0, -1.0, -1.0) false
	vs_append acc tube
	vs_append acc (vs_fanPart tube[3] [0, 0, zb] false)
	vs_append acc (vs_fanPart tube[4] [0, 0, zt] true)
	acc
)

-- ---------------------------------------------------------------------
--  Baş profilleri (her açı için sabit sayıda nokta)
-- ---------------------------------------------------------------------
fn vs_colCap th R k c rec t drop = (
	local ri = vs_recessR th rec
	local zf = k - (vs_recessDepth ri rec t)
	#([0, 0], [R, 0], [R, k - c], [R - c, k], [ri, k], [ri, zf], [0, k - t - drop])
)

fn vs_colDome th R k e rec t drop nSeg = (
	local ri = vs_recessR th rec
	local col = #([0, 0], [R, 0], [R, e])
	local phiEnd = acos (amin #(1.0, ri/R))
	for i = 1 to nSeg do (
		local phi = phiEnd*i/(nSeg as float)
		append col [R*(cos phi), e + (k - e)*(sin phi)]
	)
	col[col.count] = [ri, col[col.count].y]
	local zt = col[col.count].y
	append col [ri, zt - (vs_recessDepth ri rec t)]
	append col [0, k - t - drop]
	col
)

fn vs_colSlot th R k c rec t = (
	local ri = vs_recessR th rec
	if ri >= R - c - 1e-4 then
		#([0, 0], [R, 0], [R, k - t], [R, k - t], [R, k - t], [R, k - t], [0, k - t])
	else
		#([0, 0], [R, 0], [R, k - c], [R - c, k], [ri, k], [ri, k - t], [0, k - t])
)

fn vs_colCsk th rk rd kc rim rec t drop = (
	local ri = vs_recessR th rec
	local zf = -(vs_recessDepth ri rec t)
	#([0, -kc], [rd, -kc], [rk, -rim], [rk, 0], [ri, 0], [ri, zf], [0, -t - drop])
)

fn vs_hexCham s = (
	local rc = 0.475*s
	#(rc, (s/(sqrt 3.0) - rc)/1.732)
)

fn vs_colHexHead th s k = (
	local Rh = vs_hexR th s
	local hc = vs_hexCham s
	local rc = hc[1]
	local ch = hc[2]
	#([0, 0], [Rh, 0], [Rh, k - ch], [amin #(Rh, rc + ch*0.866), k - ch*0.5], [amin #(Rh, rc), k], [0, k])
)

fn vs_colNutShell th s m rib rit chamTop = (
	local Rh = vs_hexR th s
	local hc = vs_hexCham s
	local rc = hc[1]
	local ch = hc[2]
	local col = #([rib, 0], [amin #(Rh, rc), 0], [amin #(Rh, rc + ch*0.866), ch*0.5], [Rh, ch])
	if chamTop then
		join col #([Rh, m - ch], [amin #(Rh, rc + ch*0.866), m - ch*0.5], [amin #(Rh, rc), m])
	else
		join col #([Rh, m], [Rh, m], [Rh, m])
	append col [rit, m]
	col
)

fn vs_headAngles rec rimR = (
	local a = for i = 0 to 119 collect (3.0*i)
	if rec != undefined and rec[1] == #cross do
		for p in rec[3] do append a (atan2 p.y p.x)
	if rec != undefined and rec[1] == #slot do (
		local e = asin (amin #(1.0, rec[2]/rimR))
		for b in #(e, 180.0 - e, 180.0 + e, 360.0 - e) do (
			append a (b - 0.05)
			append a (b + 0.05)
		)
	)
	vs_uniqueSorted a
)

fn vs_headPart sp colKind = (
	local rimR = if colKind == #slot then sp.R - sp.c else sp.R
	local angs = if colKind == #hexhead then (for i = 0 to 71 collect (5.0*i)) else (vs_headAngles sp.rec rimR)
	local cols = #()
	for th in angs do (
		local col = case colKind of (
			#slot: vs_colSlot th sp.R sp.k sp.c sp.rec sp.t
			#dome: vs_colDome th sp.R sp.k sp.e sp.rec sp.t sp.drop 8
			#csk: vs_colCsk th sp.R (sp.d/2.0) sp.kc sp.rim sp.rec sp.t sp.drop
			#hexhead: vs_colHexHead th sp.s sp.k
			default: vs_colCap th sp.R sp.k sp.c sp.rec sp.t sp.drop
		)
		append cols (vs_colToXYZ col th)
	)
	vs_meshFromColumns cols false 0
)

-- ---------------------------------------------------------------------
--  Malzeme ve nesne
-- ---------------------------------------------------------------------
fn vs_getMat fin = (
	local names = #("VS_Paslanmaz", "VS_SiyahOksit", "VS_SariGalvaniz", "VS_Pirinc", "VS_Naylon")
	local nm = names[fin]
	for m in vs_matCache do if m.name == nm do return m
	local cols = #(color 200 202 208, color 45 45 48, color 215 195 120, color 205 160 85, color 235 235 228)
	local metal = #(1.0, 0.85, 1.0, 1.0, 0.0)
	local rough = #(0.28, 0.45, 0.35, 0.3, 0.55)
	local m
	try (
		m = PhysicalMaterial name:nm
		m.base_color = cols[fin]
		m.metalness = metal[fin]
		m.roughness = rough[fin]
	) catch (
		m = StandardMaterial name:nm diffuse:cols[fin] specularLevel:80 glossiness:50
	)
	append vs_matCache m
	m
)

fn vs_unitScale = (
	local s = 1.0
	try (s = units.decodeValue "1mm") catch (s = 1.0)
	if s == undefined or s <= 0 do s = 1.0
	s
)

fn vs_cleanDegenerate m = (
	local bad = #{}
	for i = 1 to m.numfaces do (
		local f = getFace m i
		if f.x == f.y or f.y == f.z or f.x == f.z do bad[i] = true
	)
	if bad.numberSet > 0 do meshop.deleteFaces m bad delIsoVerts:true
)

fn vs_makeNode acc nm fin = (
	local sc = vs_unitScale()
	local verts = for v in acc[1] collect (v*sc)
	local m = mesh vertices:verts faces:acc[2]
	m.name = uniqueName (nm + "_")
	meshop.weldVertsByThreshold m #{1..m.numverts} (0.0005*sc)
	vs_cleanDegenerate m
	meshop.autoSmooth m #{1..m.numfaces} 40.0
	update m
	convertToPoly m
	local mat = vs_getMat fin
	m.material = mat
	m.wirecolor = if fin == 5 then (color 235 235 228) else (color 175 178 185)
	m
)

fn vs_objName sp = (
	local i = vs_typeIndex sp.kind
	local nm = vs_typeCodes[i] + "_" + vs_sizes[sp.si]
	if vs_hasLength sp.kind do nm += "x" + (vs_num sp.L)
	nm
)

-- spec -> sahne nesnesi (fiberli somunda naylon halka alt nesne olarak bağlanır)
fn vs_buildSpec sp threaded fin = (
	local acc = #(#(), #())
	local typ = sp.kind
	local child = undefined
	if typ == #cap or typ == #torxcap then (
		vs_append acc (vs_headPart sp #cap)
		vs_addShank acc (-sp.L) 0.0 sp.d sp.P threaded #chamfer
	)
	else if typ == #button or typ == #phpan then (
		vs_append acc (vs_headPart sp #dome)
		vs_addShank acc (-sp.L) 0.0 sp.d sp.P threaded #chamfer
	)
	else if typ == #slotcheese then (
		vs_append acc (vs_headPart sp #slot)
		vs_addShank acc (-sp.L) 0.0 sp.d sp.P threaded #chamfer
	)
	else if typ == #csk or typ == #phcsk then (
		vs_append acc (vs_headPart sp #csk)
		vs_addShank acc (-sp.L) (-sp.kc) sp.d sp.P threaded #chamfer
	)
	else if typ == #hexbolt then (
		vs_append acc (vs_headPart sp #hexhead)
		vs_addShank acc (-sp.L) 0.0 sp.d sp.P threaded #chamfer
	)
	else if typ == #setflat or typ == #setcone then (
		local rMaj = sp.d/2.0
		local rMin = rMaj - 0.6134*sp.P
		local h = if threaded then 0.6134*sp.P else 0.0
		local tipR0 = if typ == #setcone then 0.0 else rMin*0.92
		local tube = vs_tube (-sp.L) 0.0 sp.P rMaj h 48 #(tipR0, rMin*0.95, -1.0, -1.0) false
		vs_append acc tube
		vs_append acc (vs_fanPart tube[3] [0, 0, -sp.L] false)
		local cols = #()
		for i = 1 to tube[5].count do (
			local th = tube[5][i]
			local rt = vs_rad tube[4][i]
			local ri = vs_recessR th sp.rec
			append cols (vs_colToXYZ #([rt, 0], [ri, 0], [ri, -sp.t], [0, -sp.t - sp.drop]) th)
		)
		vs_append acc (vs_meshFromColumns cols false 0)
	)
	else if typ == #hexnut or typ == #nylock then (
		local isNy = (typ == #nylock)
		local m = if isNy then sp.hm else sp.m
		local rMaj = sp.d/2.0
		local h = if threaded then 0.6134*sp.P else 0.0
		local cs = rMaj*1.08
		local tube = vs_tube 0.0 m sp.P rMaj h 48 #(-1.0, -1.0, cs, (if isNy then -1.0 else cs)) true
		vs_append acc tube
		local cols = #()
		for i = 1 to tube[5].count do (
			local th = tube[5][i]
			local col = vs_colNutShell th sp.s m (vs_rad tube[3][i]) (vs_rad tube[4][i]) (not isNy)
			append cols (vs_colToXYZ col th)
		)
		vs_append acc (vs_meshFromColumns cols false 0)
		if isNy do (
			local hh = sp.h
			local hm = sp.hm
			local rcol = 0.46*sp.s
			local rr = 0.35*(hh - hm)
			local rin = rMaj*1.06
			local rlip = rMaj*0.98
			local lip = 0.18*(hh - hm)
			local prof = #([rin, hm], [rcol, hm], [rcol, hh - rr], [rcol - rr*0.29, hh - rr*0.29], [rcol - rr, hh],
				[rlip, hh], [rlip, hh - lip], [rin, hh - lip])
			vs_append acc (vs_revolve prof 48 true)
			local rnIn = if threaded then rMaj - 0.6134*sp.P*0.95 else rMaj*0.9
			local nyAcc = #(#(), #())
			vs_append nyAcc (vs_revolve #([rnIn, hm + 0.01], [rin, hm + 0.01], [rin, hh - lip], [rnIn, hh - lip]) 48 true)
			child = vs_makeNode nyAcc ((vs_objName sp) + "_naylon") 5
		)
	)
	else if typ == #washer then (
		vs_append acc (vs_revolve #([sp.d1/2.0, 0], [sp.d2/2.0, 0], [sp.d2/2.0, sp.h], [sp.d1/2.0, sp.h]) 64 true)
	)
	local node = vs_makeNode acc (vs_objName sp) fin
	if child != undefined do child.parent = node
	node
)

fn vs_create typ si L threaded fin pos = (
	local sp = vs_spec typ si L
	local n = vs_buildSpec sp threaded fin
	n.pos = pos
	n
)

-- ---------------------------------------------------------------------
--  2B önizleme (dotNet GDI+)
-- ---------------------------------------------------------------------
fn vs_dnColor c = (dotNetClass "System.Drawing.Color").FromArgb 255 (c.x as integer) (c.y as integer) (c.z as integer)

global vs_finishRGB = #(#([238, 240, 245], [110, 114, 124]), #([110, 110, 116], [22, 22, 25]),
	#([248, 232, 160], [160, 130, 50]), #([245, 210, 130], [140, 100, 35]))

-- sağ yarı profil (üst eksenden başlayıp alt eksende biter), diş bölgesi, ek çizgiler
fn vs_outline sp = (
	local typ = sp.kind
	local d = sp.d
	local r = d/2.0
	local L = sp.L
	local ch = 0.08*d
	local pts = #()
	local thr = undefined
	local lines = #()
	local shankTip = #([r, -L + ch], [r - ch, -L], [0, -L])
	if typ == #cap or typ == #torxcap then (
		pts = #([0, sp.k], [sp.R - sp.c, sp.k], [sp.R, sp.k - sp.c], [sp.R, 0], [r, 0])
		join pts shankTip
		thr = #(-L, 0.0)
	)
	else if typ == #button or typ == #phpan then (
		for i = 0 to 10 do (
			local phi = 90.0 - 9.0*i
			append pts [sp.R*(cos phi), sp.e + (sp.k - sp.e)*(sin phi)]
		)
		join pts #([sp.R, 0], [r, 0])
		join pts shankTip
		thr = #(-L, 0.0)
	)
	else if typ == #slotcheese then (
		local w = sp.rec[2]
		pts = #([0, sp.k - sp.t], [w, sp.k - sp.t], [w, sp.k], [sp.R - sp.c, sp.k], [sp.R, sp.k - sp.c], [sp.R, 0], [r, 0])
		join pts shankTip
		thr = #(-L, 0.0)
	)
	else if typ == #csk or typ == #phcsk then (
		pts = #([0, 0], [sp.R, 0], [sp.R, -sp.rim], [r, -sp.kc])
		join pts shankTip
		thr = #(-L, -sp.kc)
	)
	else if typ == #hexbolt then (
		local hc = vs_hexCham sp.s
		local e = sp.s/(sqrt 3.0)
		pts = #([0, sp.k], [hc[1], sp.k], [e, sp.k - hc[2]], [e, 0], [r, 0])
		join pts shankTip
		thr = #(-L, 0.0)
		append lines #([e/2.0, 0], [e/2.0, sp.k - hc[2]*0.5], false)
		append lines #([-e/2.0, 0], [-e/2.0, sp.k - hc[2]*0.5], false)
	)
	else if typ == #setflat or typ == #setcone then (
		pts = #([0, 0], [r - ch, 0], [r, -ch])
		if typ == #setcone then join pts #([r, -L + r], [0, -L]) else join pts shankTip
		thr = #(-L, 0.0)
		append lines #([-(sp.rec[2])/2.0, 0], [-(sp.rec[2])/2.0, -sp.t], true)
		append lines #([(sp.rec[2])/2.0, 0], [(sp.rec[2])/2.0, -sp.t], true)
	)
	else if typ == #hexnut then (
		local hc = vs_hexCham sp.s
		local e = sp.s/(sqrt 3.0)
		pts = #([0, sp.m], [hc[1], sp.m], [e, sp.m - hc[2]], [e, hc[2]], [hc[1], 0], [0, 0])
		append lines #([e/2.0, hc[2]*0.5], [e/2.0, sp.m - hc[2]*0.5], false)
		append lines #([-e/2.0, hc[2]*0.5], [-e/2.0, sp.m - hc[2]*0.5], false)
		append lines #([r, 0], [r, sp.m], true)
		append lines #([-r, 0], [-r, sp.m], true)
	)
	else if typ == #nylock then (
		local hc = vs_hexCham sp.s
		local e = sp.s/(sqrt 3.0)
		local rcol = 0.46*sp.s
		local rr = 0.35*(sp.h - sp.hm)
		pts = #([0, sp.h], [rcol - rr, sp.h], [rcol, sp.h - rr], [rcol, sp.hm], [e, sp.hm], [e, hc[2]], [hc[1], 0], [0, 0])
		append lines #([e/2.0, hc[2]*0.5], [e/2.0, sp.hm], false)
		append lines #([-e/2.0, hc[2]*0.5], [-e/2.0, sp.hm], false)
		append lines #([-rcol, sp.hm], [rcol, sp.hm], false)
		append lines #([r, 0], [r, sp.h], true)
		append lines #([-r, 0], [-r, sp.h], true)
	)
	else if typ == #washer then (
		pts = #([0, sp.h], [sp.d2/2.0, sp.h], [sp.d2/2.0, 0], [0, 0])
		append lines #([sp.d1/2.0, 0], [sp.d1/2.0, sp.h], true)
		append lines #([-sp.d1/2.0, 0], [-sp.d1/2.0, sp.h], true)
	)
	#(pts, thr, lines)
)

fn vs_newPath pts = (
	local gp = dotNetObject "System.Drawing.Drawing2D.GraphicsPath"
	for i = 1 to pts.count do (
		local p = pts[i]
		local q = pts[if i == pts.count then 1 else i + 1]
		gp.AddLine p.x p.y q.x q.y
	)
	gp.CloseFigure()
	gp
)

fn vs_metalBrush x y w h fin = (
	local rect = dotNetObject "System.Drawing.RectangleF" x y (amax #(w, 1.0)) (amax #(h, 1.0))
	local br = dotNetObject "System.Drawing.Drawing2D.LinearGradientBrush" rect (vs_dnColor vs_finishRGB[fin][2]) (vs_dnColor vs_finishRGB[fin][1]) 0.0
	br.SetBlendTriangularShape 0.35
	br
)

-- yan görünüş; box = #(x, y, w, h)
fn vs_drawSide g sp box fin showThread = (
	local o = vs_outline sp
	local pts = o[1]
	local maxR = 0.0
	local zmin = 1e9
	local zmax = -1e9
	for p in pts do (
		if p.x > maxR do maxR = p.x
		if p.y < zmin do zmin = p.y
		if p.y > zmax do zmax = p.y
	)
	local sc = amin #((box[3] - 16.0)/(2.0*maxR), (box[4] - 16.0)/(zmax - zmin))
	local cx = box[1] + box[3]/2.0
	local cy = box[2] + box[4]/2.0 + ((zmax + zmin)/2.0)*sc
	local scr = for p in pts collect [cx + p.x*sc, cy - p.y*sc]
	for i = pts.count to 1 by -1 do append scr [cx - pts[i].x*sc, cy - pts[i].y*sc]
	local gp = vs_newPath scr
	local br = vs_metalBrush (cx - maxR*sc) (cy - zmax*sc) (2.0*maxR*sc) ((zmax - zmin)*sc) fin
	g.FillPath br gp
	local penO = dotNetObject "System.Drawing.Pen" (vs_dnColor [20, 20, 22]) 1.2
	local penT = dotNetObject "System.Drawing.Pen" (vs_dnColor [40, 40, 45]) 1.0
	local penH = dotNetObject "System.Drawing.Pen" (vs_dnColor [60, 60, 66]) 1.0
	penH.DashStyle = (dotNetClass "System.Drawing.Drawing2D.DashStyle").Dash
	-- diş çizgileri
	if showThread and o[2] != undefined do (
		local r = sp.d/2.0
		local step = sp.P
		if step*sc < 3.0 do step = sp.P*(ceil (3.0/(sp.P*sc)))
		local z0 = o[2][1] + 0.08*sp.d
		local z1 = o[2][2]
		local z = z0 + step*0.5
		while z + step*0.5 <= z1 do (
			g.DrawLine penT (cx - r*sc) (cy - z*sc) (cx + r*sc) (cy - (z + step*0.5)*sc)
			z += step
		)
		local rm = r - 0.6134*sp.P
		g.DrawLine penH (cx - rm*sc) (cy - z0*sc) (cx - rm*sc) (cy - z1*sc)
		g.DrawLine penH (cx + rm*sc) (cy - z0*sc) (cx + rm*sc) (cy - z1*sc)
	)
	for ln in o[3] do (
		local pen = if ln[3] then penH else penT
		g.DrawLine pen (cx + ln[1].x*sc) (cy - ln[1].y*sc) (cx + ln[2].x*sc) (cy - ln[2].y*sc)
	)
	g.DrawPath penO gp
	gp.Dispose(); br.Dispose(); penO.Dispose(); penT.Dispose(); penH.Dispose()
)

-- üst görünüş (baş/yuva şekli)
fn vs_drawTop g sp box fin bg = (
	local typ = sp.kind
	local outR = vs_outerR sp
	local sc = ((amin #(box[3], box[4])) - 12.0)/(2.0*outR)
	local cx = box[1] + box[3]/2.0
	local cy = box[2] + box[4]/2.0
	local penO = dotNetObject "System.Drawing.Pen" (vs_dnColor [20, 20, 22]) 1.2
	local outer = #()
	if vs_isHexType typ then
		outer = for i = 0 to 5 collect [cx + outR*sc*(cos (60.0*i)), cy - outR*sc*(sin (60.0*i))]
	else
		outer = for i = 0 to 89 collect [cx + outR*sc*(cos (4.0*i)), cy - outR*sc*(sin (4.0*i))]
	local gp = vs_newPath outer
	local br = vs_metalBrush (cx - outR*sc) (cy - outR*sc) (2.0*outR*sc) (2.0*outR*sc) fin
	g.FillPath br gp
	g.DrawPath penO gp
	local dark = dotNetObject "System.Drawing.SolidBrush" (vs_dnColor [30, 30, 33])
	local bgBr = dotNetObject "System.Drawing.SolidBrush" (vs_dnColor bg)
	if typ == #nylock do (
		local rc = 0.46*sp.s*sc
		g.DrawEllipse penO (cx - rc) (cy - rc) (2.0*rc) (2.0*rc)
		local wb = dotNetObject "System.Drawing.SolidBrush" (vs_dnColor [235, 235, 228])
		local rn = sp.d/2.0*1.06*sc
		g.FillEllipse wb (cx - rn) (cy - rn) (2.0*rn) (2.0*rn)
		wb.Dispose()
	)
	if typ == #hexnut or typ == #nylock or typ == #washer then (
		local rh = (if typ == #washer then sp.d1/2.0 else (sp.d/2.0 - 0.6134*sp.P))*sc
		g.FillEllipse bgBr (cx - rh) (cy - rh) (2.0*rh) (2.0*rh)
		g.DrawEllipse penO (cx - rh) (cy - rh) (2.0*rh) (2.0*rh)
		if typ != #washer do (
			local penH = dotNetObject "System.Drawing.Pen" (vs_dnColor [60, 60, 66]) 1.0
			penH.DashStyle = (dotNetClass "System.Drawing.Drawing2D.DashStyle").Dash
			local rM = sp.d/2.0*sc
			g.DrawEllipse penH (cx - rM) (cy - rM) (2.0*rM) (2.0*rM)
			penH.Dispose()
		)
	)
	else if sp.rec != undefined do (
		local lim = (if typ == #slotcheese then sp.R else outR)*0.999
		local rp = for i = 0 to 179 collect (
			local th = 2.0*i
			local ri = amin #(vs_recessR th sp.rec, lim)
			[cx + ri*sc*(cos th), cy - ri*sc*(sin th)]
		)
		local gr = vs_newPath rp
		g.FillPath dark gr
		g.DrawPath penO gr
		gr.Dispose()
	)
	gp.Dispose(); br.Dispose(); dark.Dispose(); bgBr.Dispose(); penO.Dispose()
)

fn vs_recessText sp = (
	if sp.rec == undefined then ""
	else case sp.rec[1] of (
		#hex: "alyan " + (vs_num sp.rec[2]) + " mm"
		#torx: "torx T" + (vs_torxT[sp.si] as string)
		#cross: "yıldız PH" + (vs_ph[sp.si] as string)
		#slot: "kanal " + (vs_num (sp.rec[2]*2.0)) + " mm"
		default: ""
	)
)

fn vs_dimLines sp = (
	local typ = sp.kind
	local nm = vs_sizes[sp.si]
	local l1 = if vs_hasLength typ then (nm + " × " + (vs_num sp.L) + " mm") else nm
	l1 += "     adım " + (vs_num sp.P)
	local l2 = ""
	if typ == #cap or typ == #torxcap or typ == #button or typ == #phpan or typ == #slotcheese then
		l2 = "baş Ø" + (vs_num (sp.R*2.0)) + "  yükseklik " + (vs_num sp.k) + "   " + (vs_recessText sp)
	else if typ == #csk or typ == #phcsk then
		l2 = "havşa Ø" + (vs_num (sp.R*2.0)) + "  90°   " + (vs_recessText sp)
	else if typ == #setflat or typ == #setcone then
		l2 = (vs_recessText sp) + "   yuva derinliği " + (vs_num sp.t)
	else if typ == #hexbolt then
		l2 = "anahtar " + (vs_num sp.s) + "  baş yük. " + (vs_num sp.k)
	else if typ == #hexnut then
		l2 = "anahtar " + (vs_num sp.s) + "  yükseklik " + (vs_num sp.m)
	else if typ == #nylock then
		l2 = "anahtar " + (vs_num sp.s) + "  yükseklik " + (vs_num sp.h)
	else if typ == #washer then
		l2 = "iç Ø" + (vs_num sp.d1) + "  dış Ø" + (vs_num sp.d2) + "  kalınlık " + (vs_num sp.h)
	#(l1, l2)
)

global vs_bgCol = [58, 58, 62]

fn vs_previewBitmap sp fin showThread w h = (
	local bmp = dotNetObject "System.Drawing.Bitmap" w h
	local g = (dotNetClass "System.Drawing.Graphics").FromImage bmp
	g.SmoothingMode = (dotNetClass "System.Drawing.Drawing2D.SmoothingMode").AntiAlias
	g.Clear (vs_dnColor vs_bgCol)
	local txtH = 58
	vs_drawSide g sp #(6, 6, w*0.58, h - txtH - 6) fin showThread
	vs_drawTop g sp #(w*0.60, 30, w*0.38, w*0.38) fin vs_bgCol
	local fB = dotNetObject "System.Drawing.Font" "Segoe UI" 9.0 (dotNetClass "System.Drawing.FontStyle").Bold
	local f = dotNetObject "System.Drawing.Font" "Segoe UI" 8.5
	local fS = dotNetObject "System.Drawing.Font" "Segoe UI" 7.5
	local wb = dotNetObject "System.Drawing.SolidBrush" (vs_dnColor [235, 235, 235])
	local gb = dotNetObject "System.Drawing.SolidBrush" (vs_dnColor [170, 170, 175])
	g.DrawString "yan" fS gb 8.0 6.0
	g.DrawString "üst" fS gb (w*0.60) 12.0
	local ls = vs_dimLines sp
	g.DrawString vs_typeNames[vs_typeIndex sp.kind] fB wb 8.0 (h - txtH + 2.0)
	g.DrawString ls[1] f wb 8.0 (h - txtH + 20.0)
	g.DrawString ls[2] f gb 8.0 (h - txtH + 37.0)
	g.Dispose()
	bmp
)

global vs_galCols = 5
global vs_galCellW = 108
global vs_galCellH = 92

fn vs_gallerySpec i = (
	local typ = vs_types[i]
	local L = if typ == #setflat or typ == #setcone then 12.0 else 22.0
	vs_spec typ 6 L
)

fn vs_galleryBitmap sel fin = (
	local rows = (vs_types.count + vs_galCols - 1)/vs_galCols
	local w = vs_galCols*vs_galCellW
	local h = rows*vs_galCellH
	local bmp = dotNetObject "System.Drawing.Bitmap" w h
	local g = (dotNetClass "System.Drawing.Graphics").FromImage bmp
	g.SmoothingMode = (dotNetClass "System.Drawing.Drawing2D.SmoothingMode").AntiAlias
	g.Clear (vs_dnColor vs_bgCol)
	local f = dotNetObject "System.Drawing.Font" "Segoe UI" 7.5
	local wb = dotNetObject "System.Drawing.SolidBrush" (vs_dnColor [225, 225, 225])
	local cellBr = dotNetObject "System.Drawing.SolidBrush" (vs_dnColor [70, 70, 75])
	local selPen = dotNetObject "System.Drawing.Pen" (vs_dnColor [255, 165, 40]) 2.0
	local sf = dotNetObject "System.Drawing.StringFormat"
	sf.Alignment = (dotNetClass "System.Drawing.StringAlignment").Center
	for i = 1 to vs_types.count do (
		local cx = (mod (i - 1) vs_galCols)*vs_galCellW
		local cy = ((i - 1)/vs_galCols)*vs_galCellH
		g.FillRectangle cellBr (cx + 2.0) (cy + 2.0) (vs_galCellW - 4.0) (vs_galCellH - 4.0)
		local sp = vs_gallerySpec i
		local sideW = if vs_hasLength sp.kind then 50.0 else 54.0
		vs_drawSide g sp #(cx + 4.0, cy + 3.0, sideW, vs_galCellH - 22.0) fin true
		vs_drawTop g sp #(cx + sideW + 2.0, cy + 10.0, vs_galCellW - sideW - 6.0, vs_galCellH - 36.0) fin [70, 70, 75]
		local rect = dotNetObject "System.Drawing.RectangleF" (cx + 0.0) (cy + vs_galCellH - 19.0) (vs_galCellW + 0.0) 16.0
		g.DrawString vs_typeShort[i] f wb rect sf
		if i == sel do g.DrawRectangle selPen (cx + 2.0) (cy + 2.0) (vs_galCellW - 4.0) (vs_galCellH - 4.0)
	)
	g.Dispose()
	bmp
)

-- ---------------------------------------------------------------------
--  Arayüz
-- ---------------------------------------------------------------------
rollout vs_Rollout "Vida & Somun Üretici" width:560 height:628
(
	dropdownList ddType "Tip:" items:vs_typeNames pos:[10,6] width:212 height:20
	dropdownList ddSize "Ölçü:" items:vs_sizes pos:[10,50] width:96 height:12 selection:6
	dropdownList ddLen "Standart boy:" items:(for x in vs_lengths collect (x as string)) pos:[116,50] width:106 height:20 selection:12
	spinner spLen "Boy (mm): " range:[1,400,30] type:#float pos:[10,96] fieldwidth:70 align:#left
	checkbox chkThread "Dişi modelle (gerçek helis)" checked:true pos:[10,120]
	dropdownList ddFinish "Kaplama:" items:vs_finishNames pos:[10,142] width:212
	button btnCreate "Oluştur" pos:[10,190] width:212 height:34
	button btnSeries "Bu tip, tüm ölçüler (seri)" pos:[10,230] width:212 height:24
	button btnCatalog "Bu ölçü, tüm tipler (katalog)" pos:[10,258] width:212 height:24
	label lblHint1 "Galeride bir resme tıklayıp tip seç." pos:[10,290] width:212
	label lblHint2 "Somun ve pulda boy kullanılmaz." pos:[10,306] width:212
	dotNetControl pbPrev "System.Windows.Forms.PictureBox" pos:[230,6] width:320 height:316
	dotNetControl pbGal "System.Windows.Forms.PictureBox" pos:[10,330] width:540 height:276
	label lblUnit "" pos:[10,610] width:540

	fn curSpec = vs_spec vs_types[ddType.selection] ddSize.selection spLen.value

	fn setImage pb bmp = (
		local old = pb.Image
		pb.Image = bmp
		if old != undefined do old.Dispose()
	)

	fn refresh = (
		local typ = vs_types[ddType.selection]
		local hasL = vs_hasLength typ
		spLen.enabled = hasL
		ddLen.enabled = hasL
		setImage pbPrev (vs_previewBitmap (curSpec()) ddFinish.selection chkThread.checked 320 316)
		setImage pbGal (vs_galleryBitmap ddType.selection ddFinish.selection)
	)

	on vs_Rollout open do (
		pbPrev.BackColor = vs_dnColor vs_bgCol
		pbGal.BackColor = vs_dnColor vs_bgCol
		lblUnit.text = "Sistem birimi: " + (units.SystemType as string) + "  (1 mm = " + (vs_unitScale() as string) + " birim)"
		refresh()
	)
	on ddType selected i do refresh()
	on ddSize selected i do refresh()
	on ddLen selected i do (spLen.value = vs_lengths[i]; refresh())
	on spLen changed v do refresh()
	on chkThread changed v do refresh()
	on ddFinish selected i do refresh()
	on pbGal MouseClick s e do (
		local c = e.X/vs_galCellW
		local r = e.Y/vs_galCellH
		local i = r*vs_galCols + c + 1
		if c < vs_galCols and i >= 1 and i <= vs_types.count do (
			ddType.selection = i
			refresh()
		)
	)

	on btnCreate pressed do (
		local n
		undo "Vida oluştur" on (
			with redraw off (
				n = vs_create vs_types[ddType.selection] ddSize.selection spLen.value chkThread.checked ddFinish.selection [0, 0, 0]
			)
		)
		select n
		redrawViews()
	)

	on btnSeries pressed do (
		local typ = vs_types[ddType.selection]
		local sc = vs_unitScale()
		local x = 0.0
		local all = #()
		undo "Vida serisi" on (
			with redraw off (
				local dCur = vs_d[ddSize.selection]
				for si = 1 to vs_sizes.count do (
					local L = spLen.value*vs_d[si]/dCur
					local best = vs_lengths[1]
					for v in vs_lengths do if (abs (v - L)) < (abs (best - L)) do best = v
					local sp = vs_spec typ si best
					local rO = vs_outerR sp
					x += rO
					local n = vs_buildSpec sp chkThread.checked ddFinish.selection
					n.pos = [x*sc, 0, 0]
					append all n
					local t = text text:vs_sizes[si] size:((amax #(3.0, vs_d[si]*0.6))*sc) pos:[x*sc, -(rO + 6.0)*sc, 0] wirecolor:(color 255 200 60)
					t.name = uniqueName ("Etiket_" + vs_sizes[si] + "_")
					x += rO + 6.0
				)
			)
		)
		select all
		redrawViews()
	)

	on btnCatalog pressed do (
		local si = ddSize.selection
		local sc = vs_unitScale()
		local x = 0.0
		local all = #()
		undo "Vida katalogu" on (
			with redraw off (
				for i = 1 to vs_types.count do (
					local typ = vs_types[i]
					local L = spLen.value
					if typ == #setflat or typ == #setcone do L = amin #(L, 3.0*vs_d[si])
					local sp = vs_spec typ si L
					local rO = vs_outerR sp
					x += rO
					local n = vs_buildSpec sp chkThread.checked ddFinish.selection
					n.pos = [x*sc, 0, 0]
					append all n
					local t = text text:vs_typeShort[i] size:((amax #(2.0, vs_d[si]*0.35))*sc) pos:[x*sc, -(rO + vs_d[si])*sc, 0] wirecolor:(color 255 200 60)
					t.name = uniqueName ("Etiket_" + vs_typeCodes[i] + "_")
					x += rO + vs_d[si]
				)
			)
		)
		select all
		redrawViews()
	)
)

if vs_NO_UI != true do (
	try (destroyDialog vs_Rollout) catch ()
	createDialog vs_Rollout
)
