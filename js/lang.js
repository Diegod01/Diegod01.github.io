function googleTranslateElementInit() {
  new google.translate.TranslateElement({
    pageLanguage: 'es',
    includedLanguages: 'en,es',
    autoDisplay: false
  }, 'google_translate_element');
}

function traducir(lang) {
  const combo = document.querySelector(".goog-te-combo");
  if (combo) {
    combo.value = lang;
    combo.dispatchEvent(new Event("change"));
    localStorage.setItem("lang", lang);
  }
}

// Persistir idioma elegido
document.addEventListener("DOMContentLoaded", () => {
  const saved = localStorage.getItem("lang");
  if (saved) traducir(saved);
});
