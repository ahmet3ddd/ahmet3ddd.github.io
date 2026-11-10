// ahmetoff.com iletişim formu gönderici (Cloudflare Worker).
// Kaynak burada tutulur; Cloudflare panelinde "ahmetoff-iletisim" adlı Worker'a yapıştırılarak yayınlanır.
// Gerekli bağlama: Send Email, adı SEB, hedef adres = Email Routing'de doğrulanmış Gmail adresi.
// Gönderen adres iletisim@ahmetoff.com; ziyaretçinin adresi yalnızca Reply-To'da durur.
// Konu sabittir: ziyaretçinin yazdığı hiçbir şey konuya girmez ("[beyin-not]" gibi etiketler sokulamasın).
import { EmailMessage } from "cloudflare:email";

const ALLOWED = ["https://ahmetoff.com", "https://www.ahmetoff.com"];
const FROM = "iletisim@ahmetoff.com";

function cors(origin) {
  return {
    "Access-Control-Allow-Origin": ALLOWED.includes(origin) ? origin : ALLOWED[0],
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Vary": "Origin",
  };
}
function reply(status, obj, origin) {
  return new Response(JSON.stringify(obj), { status, headers: { "Content-Type": "application/json; charset=utf-8", ...cors(origin) } });
}
function clean(s, max) {
  return String(s || "").replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]/g, "").trim().slice(0, max);
}
function b64(str) {
  const bytes = new TextEncoder().encode(str);
  let bin = "";
  for (let i = 0; i < bytes.length; i++) bin += String.fromCharCode(bytes[i]);
  return btoa(bin).replace(/.{1,76}/g, "$&\r\n").trim();
}
function encWord(str) {
  return "=?UTF-8?B?" + btoa(String.fromCharCode(...new TextEncoder().encode(str))) + "?=";
}

export default {
  async fetch(request, env) {
    const origin = request.headers.get("Origin") || "";
    if (request.method === "OPTIONS") return new Response(null, { status: 204, headers: cors(origin) });
    if (request.method !== "POST") return reply(405, { ok: false, error: "method" }, origin);
    if (!ALLOWED.includes(origin)) return reply(403, { ok: false, error: "origin" }, origin);

    let d;
    try { d = await request.json(); } catch { return reply(400, { ok: false, error: "json" }, origin); }

    // Bot tuzakları: görünmez alan dolu ya da form 3 saniyeden kısa sürede gönderildiyse sessizce kabul et, gönderme.
    if (d.website || (Number(d.t) && Date.now() - Number(d.t) < 3000)) return reply(200, { ok: true }, origin);

    const name = clean(d.name, 100).replace(/[\r\n<>"\[\]]/g, " ");
    const email = clean(d.email, 200);
    const message = clean(d.message, 5000);
    if (!/^[^\s@<>()",;:]+@[^\s@<>()",;:]+\.[^\s@<>()",;:]+$/.test(email)) return reply(400, { ok: false, error: "email" }, origin);
    if (message.length < 2) return reply(400, { ok: false, error: "message" }, origin);

    const ip = request.headers.get("CF-Connecting-IP") || "";
    const country = request.headers.get("CF-IPCountry") || "";
    const now = new Date().toISOString();
    const body =
      "ahmetoff.com iletişim formundan yeni mesaj\r\n\r\n" +
      "Ad: " + (name || "(yazılmamış)") + "\r\n" +
      "E-posta: " + email + "\r\n" +
      "Tarih: " + now + "\r\n" +
      "Ülke: " + country + "\r\n\r\n" +
      "Mesaj:\r\n" + message + "\r\n\r\n" +
      "--\r\nYanıtla dediğinizde cevap ziyaretçinin adresine gider.\r\n";

    const id = "<" + crypto.randomUUID() + "@ahmetoff.com>";
    const raw =
      "From: " + encWord("ahmetoff.com iletişim") + " <" + FROM + ">\r\n" +
      "To: <" + env.TO + ">\r\n" +
      "Reply-To: " + (name ? encWord(name) + " " : "") + "<" + email + ">\r\n" +
      "Subject: " + encWord("ahmetoff.com iletişim formu") + "\r\n" +
      "Message-ID: " + id + "\r\n" +
      "Date: " + new Date().toUTCString() + "\r\n" +
      "MIME-Version: 1.0\r\n" +
      "Content-Type: text/plain; charset=UTF-8\r\n" +
      "Content-Transfer-Encoding: base64\r\n" +
      "X-Iletisim-IP: " + ip + "\r\n\r\n" +
      b64(body) + "\r\n";

    try {
      await env.SEB.send(new EmailMessage(FROM, env.TO, raw));
    } catch (e) {
      return reply(502, { ok: false, error: "send", detail: String(e && e.message || e).slice(0, 200) }, origin);
    }
    return reply(200, { ok: true }, origin);
  },
};
