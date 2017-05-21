var bss = Cc["@mozilla.org/browser/search-service;1"].getService(Ci.nsIBrowserSearchService);

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

if (!bss.getEngineByName('DiscoverED')) {
  bss.addEngineWithDetails(
    "DiscoverED",
    null,
    "discovered",
    "Search DiscoverED",
    "GET",
    "http://discovered.ed.ac.uk/primo_library/libweb/action/search.do?fn=search&ct=search&initialSearch=true&mode=Basic&tab=default_tab&indx=1&dum=true&srt=rank&vid=44UOE_VU1&frbg=&vl(freeText0)={searchTerms}&scp.scps=scope:(44UOE_DSPACE),scope:(44UOE_PURE),scope:(44UOE_ALMA),primo_central_multiple_fe");
}

function saveTitle (fp, title, link) {
  var entry = '- [[' + link + '][' + title + ']]\n';
  var file = new io.File(fp);
  if (file.read().indexOf(entry) >= 0) {
    liberator.echomsg("You already have '" + title + '" in ' + fp);
    return;
  }
  file.write(entry, '>>');
}

function saveLink (indexFile, e)  {
  var title = e.innerHTML.replace('<b>', '').replace('</b>', '');
  saveTitle(indexFile,title, e.href);
  liberator.echomsg("Saved link to '" + title  + '" in ' + indexFile);
}

hints.addMode('l', "Save paper link.", saveLink.bind(null,  '~/Documents/papers.org'), function () {
  return util.makeXPath(["h3//a"]);
});

function saveDoc (filename, cb) {
  let doc = config.browser.contentDocument;
  let chosenData = null;
  let file = io.File(filename);
  chosenData = { file: file,
                 uri: window.makeURI(doc.location.href, doc.characterSet) };

  try {
    var contentDisposition = config.browser.contentWindow
        .QueryInterface(Ci.nsIInterfaceRequestor)
        .getInterface(Ci.nsIDOMWindowUtils)
      .getDocumentMetadata("content-disposition");
  }
  catch (e) {}

  autocommands.add("DownloadPost", ".*", function __fn () {
    liberator.echomsg("Autocmds before: " + autocommands._store.length);
    autocommands._store = autocommands._store.filter(function (autoCmd) {
      return autoCmd.command !== __fn;
    });
    liberator.echomsg("Autocmds left: " + autocommands._store.length);
    cb();
  });
  window.internalSave(doc.location.href, doc, null, contentDisposition,
                      doc.contentType, false, null, chosenData, doc.referrer ?
                      window.makeURI(doc.referrer) : null, doc, true);

}

function savepdf (indexFile) {
  saveDoc("/tmp/paper.pdf", function () {
    liberator.echomsg("Saving pdf:");
    var title = io.system('/usr/local/bin/pdftotext -l 1 /tmp/paper.pdf  - | awk \'BEGIN { RS="\\n\\n"; FS="\\n":} {print; exit;}\' | awk \'/(,|@|.edu)/{exit} {print}\' | paste - - - ').trim();
    saveTitle(indexFile, title, config.browser.contentDocument.location.href);
    liberator.echomsg("Saved link to '" + title  + '" in ' + indexFile);
  });
}
var fp = "~/Documents/papers.org";
commands.addUserCommand(["paperstore"], "Store paper link in " + fp, function () {
  savepdf(fp);
}, null, true);


buffer.followDocumentRelationship = function (rel, ...synonyms) {
  let regexes = options.get(rel + "pattern").values
    .map(function (re) RegExp(re, "i"));
  synonyms.unshift(rel);

  function followFrame(frame) {
    function* iter(elems) {
      for (let i = 0; i < elems.length; i++)
        for (let rel of synonyms)
          if (elems[i].rel.toLowerCase() == rel || elems[i].rev.toLowerCase() == rel)
            yield elems[i];
    }

    // <link>s have higher priority than normal <a> hrefs
    let elems = frame.document.getElementsByTagName("link");
    for (let elem of iter(elems)) {
      liberator.open(elem.href);
      return true;
    }

    // no links? ok, look for hrefs
    elems = frame.document.getElementsByTagName("a");
    for (let elem of iter(elems)) {
      buffer.followLink(elem, liberator.CURRENT_TAB);
      return true;
    }

    let res = util.evaluateXPath(options.get("hinttags").value, frame.document);
    for (let regex of regexes) {
      for (let i in util.range(res.snapshotLength, 0, -1)) {
        let elem = res.snapshotItem(i);
        if (regex.test(elem.textContent) || regex.test(elem.title) ||
            Array.some(elem.childNodes, function (child) regex.test(child.alt))) {
          if (elem.href
              && typeof history.session[history.session.index - 1] !== "undefined"
              && history.session[history.session.index - 1].URI.spec === elem.href) {
            history.stepTo(-1);
            return true;
          }
          if (elem.href
              && typeof history.session[history.session.index + 1] !== "undefined"
              && history.session[history.session.index + 1].URI.spec === elem.href) {
            history.stepTo(1);
            return true;
          }
          buffer.followLink(elem, liberator.CURRENT_TAB);
          return true;
        }
      }
    }
    return false;
  }

  let ret = followFrame(config.browser.contentWindow);
  if (!ret) {
    // only loop through frames (ordered by size) if the main content didn't match
    let frames = buffer.getAllFrames().slice(1)
      .sort( function(a, b) {
        return ((b.scrollMaxX+b.innerWidth)*(b.scrollMaxY+b.innerHeight)) - ((a.scrollMaxX+a.innerWidth)*(a.scrollMaxY+a.innerHeight))
      } );
    ret = Array.some(frames, followFrame);
  }

  if (!ret)
    liberator.beep();
}
