//= require jquery
//= require scrollreveal
//= require typedjs

$("span#home-chtext").typed(
  {
    strings: ["Desafios", "Pessoas", "Empresas", "Soluções", "Pesquisas", "Cientistas"],
    typeSpeed: 100,
    startDelay: 0,
    backSpeed: 50,
    shuffle: true,
    backDelay: 1500,
    loop: true,
    showCursor: false,
  }
);

$("span#bouncing-arrow").on('click tap', function(e) {
  $("html, body").animate({ scrollTop: $("#home-main-hero").height() }, 1000);
});

window.sr = ScrollReveal({ delay: 200, distance : '90px' }).reveal('.reveal-bot').reveal('.reveal-left', { origin: 'left' }).reveal('.reveal-right', { origin: 'right' });
