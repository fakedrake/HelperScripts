liberator.plugins.extralib = (function () {
  var extraLib = {
    lastResponse: null,
    get: get
  };

  function get (url, callback) {
    function _callback(arg) {
        extraLib.lastResponse = arg;
        callback(arg.responseText || arg);
    }

    var req = new libly.Request(url, null, {asynchronous: true});
    req.addEventListener("success", _callback);
    req.addEventListener("failure", _callback);
    req.addEventListener("exception", _callback);
    req.get();
  }

  return extraLib;
})();
