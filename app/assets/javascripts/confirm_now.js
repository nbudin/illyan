(function () {
  var currentTimeString, zeroPad;

  zeroPad = function (n) {
    if (n < 10) {
      return "0" + n;
    } else {
      return n.toString();
    }
  };

  currentTimeString = function () {
    var now, ymdhms;
    now = new Date();
    ymdhms = now.getUTCFullYear().toString() + "-";
    ymdhms += zeroPad(now.getUTCMonth() + 1) + "-";
    ymdhms += zeroPad(now.getUTCDate()) + " ";
    ymdhms += zeroPad(now.getUTCHours()) + ":";
    ymdhms += zeroPad(now.getUTCMinutes()) + ":";
    ymdhms += zeroPad(now.getUTCSeconds());
    return ymdhms;
  };

  $(function () {
    return $("[data-set-current-time]").click(function (e) {
      var input;
      e.preventDefault();
      input = $("input[name='" + $(this).data("set-current-time") + "']");
      return input.val(currentTimeString());
    });
  });
}.call(this));
