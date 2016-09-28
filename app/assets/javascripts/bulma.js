$("div.notification button.delete").click(function() {
  $(this).parent().addClass("is-hidden");
});

$(document).on("upload:start", "form", function(e) {
  $(this).find("input[type=submit]").attr("disabled", true);
});

$(document).on("upload:start", "input", function(e) {
  $(this).parent().find("progress").removeClass("is-hidden");
});

$(document).on("upload:progress", "input", function(e) {
  var progress = e.originalEvent.detail.progress;
  var percentage = Math.round((progress.loaded / progress.total) * 100);
  $(this).parent().find("progress").attr("value", percentage);
});

$(document).on("upload:complete", "input", function(e) {
  $(this).parent().find("progress").addClass("is-hidden");
});

$(document).on("upload:complete", "form", function(e) {
  if(!$(this).find("input.uploading").length) {
    $(this).find("input[type=submit]").removeAttr("disabled")
  }
});
