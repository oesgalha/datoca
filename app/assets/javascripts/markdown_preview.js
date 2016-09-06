function applyMarkdownPreview(input, preview) {
  preview.html(markdown.toHTML(input.val()));
}
function bindMarkdownPreview(input, preview) {
  input.keyup(function() {
    applyMarkdownPreview(input, preview);
  });
}
$(document).on("nested:fieldAdded", function(event){
  bindMarkdownPreview(
    event.field.find(".markdown-input"),
    event.field.find(".markdown-preview")
  );
})
$(".markdown-input").each(function(_) {
  var mdinput = $(this);
  var mdpreview = $(this).parent().parent().find(".markdown-preview");
  applyMarkdownPreview(mdinput, mdpreview);
  bindMarkdownPreview(mdinput, mdpreview);
});
