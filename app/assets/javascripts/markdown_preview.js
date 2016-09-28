function applyMarkdownPreview(input, preview) {
  preview.html(markdown.toHTML(input.val()));
}
function bindMarkdownPreview(input, preview) {
  input.keyup(function() {
    applyMarkdownPreview(input, preview);
  });
}

// Ugly nasty glue between refile and inlineattachment
function bindMarkdownUpload(input) {
  var _pfile;
  input.inlineattachment({
    uploadUrl: '/attachments/cache',
    jsonFieldName: 'url',
    urlText: function(filename, result) {
      return "![" + result.id + "](" + filename + ")";
    },
    onFileReceived: function(file) {
      _pfile = file;
    },
    beforeFileUpload: function(xhr) {
      xhr.file = _pfile;
      return true;
    },
    onFileUploadResponse: function(xhr) {
      var id = xhr.id || JSON.parse(xhr.responseText).id;
      var data = [{ id: id, filename: xhr.file.name, content_type: xhr.file.type, size: xhr.file.size }];
      var filefield = input.parent().find("input.is-hidden[type=file]");
      var reference = filefield.data("reference");
      var metadatafield = $("input[type=hidden][data-reference='" + reference + "']");
      metadatafield.attr("value", JSON.stringify(data));
      filefield.removeAttr("name");
      return true;
    },
    onFileUploaded: function() {
      input.trigger("keyup");
    }
  });
}

$(document).on("nested:fieldAdded", function(event){
  bindMarkdownPreview(
    event.field.find(".markdown-input"),
    event.field.find(".markdown-preview")
  );
});

$(".markdown-input").each(function(_) {
  var mdinput = $(this);
  var mdpreview = $(this).parent().parent().find(".markdown-preview");
  applyMarkdownPreview(mdinput, mdpreview);
  bindMarkdownPreview(mdinput, mdpreview);
  bindMarkdownUpload(mdinput);
});
