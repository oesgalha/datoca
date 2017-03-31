var mdit = window.markdownit();

function applyMarkdownPreview(input, preview) {
  preview.html(mdit.render(input.val()));
}
function bindMarkdownPreview(input, preview) {
  input.keyup(function() {
    applyMarkdownPreview(input, preview);
  });
}

function fileIsImage(file) {
  var images_types = ['image/jpeg', 'image/png', 'image/jpg', 'image/gif'];
  return images_types.indexOf(file.type) > -1;
}

function bindMarkdownUpload(input) {
  window.URL = window.URL || window.webkitURL;
  var file_input = input.parent().find("input[type=file]");
  file_input.on("change", function() {
    var files = this.files;
    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      var name = file.name.replace(/\s/g, '_')
      // Continue only if the attachment is new to the text
      // ie: the markdown [filename](url) is not present
      if (input.val().indexOf("[" + name + "]") === -1) {
        var tmpURL = window.URL.createObjectURL(file);
        var mdUrl = "[" + name + "](" + tmpURL + ")\n\n";
        // If it is an image add the bang (!) to the beginning
        if (fileIsImage(file)) {
          mdUrl = "!" + mdUrl;
        }
        // Append the markdown url
        input.val(input.val() + "\n\n" + mdUrl);
        // Refresh the preview
        input.trigger("keyup");
      }
    }
  });
}

$(document).on("nested:fieldAdded", function(event){
  var mdinput = event.field.find(".markdown-input");
  var mdpreview = event.field.find(".markdown-preview");
  bindMarkdownPreview(mdinput, mdpreview);
  bindMarkdownUpload(mdinput);
});

$(".markdown-input").each(function(_) {
  var mdinput = $(this);
  var mdpreview = $(this).parent().parent().find(".markdown-preview");
  applyMarkdownPreview(mdinput, mdpreview);
  bindMarkdownPreview(mdinput, mdpreview);
  bindMarkdownUpload(mdinput);
});
