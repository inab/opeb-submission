---
---

function loadStyleSheet(src, media=null){
  if (document.createStyleSheet)
    document.createStyleSheet(src);
  else {
    var stylesheet = document.createElement('link');
    stylesheet.href = src;
    stylesheet.rel = 'stylesheet';
    stylesheet.type = 'text/css';
    if (media) stylesheet.media = media;
    document.getElementsByTagName('head')[0].appendChild(stylesheet);
  }
};

loadStyleSheet('https://fonts.googleapis.com/css?family=Roboto:500');
loadStyleSheet("{{ '/assets/css/style.css?v=' | append: site.github.url | relative_url }}");
loadStyleSheet("{{ '/assets/css/print.css' | append: site.github.url | relative_url }}}", 'print');

