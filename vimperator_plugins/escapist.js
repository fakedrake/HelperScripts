Components.utils.import("resource://gre/modules/FileUtils.jsm");
Components.utils.import("resource://gre/modules/osfile.jsm");

function videoLinks (win) {
  return [].slice.call(win.document.querySelectorAll('.filmstrip_video > a'))
    .map(function (a) {return a.href;});
}

function pagesNumber (win) {
  var lastPage = [].slice.call(win.document.querySelectorAll('.pagination_pages > a')).map(function (a) {return a.href;}).pop();

  return Number(lastPage.split('=').pop());
}

function pageVideoLinks (pageNum, cb) {
  var url = "http://www.escapistmagazine.com/videos/view/zero-punctuation?page="
        + String(pageNum);

  var iframe = document.createElement('iframe');
  function returnMe () {
    cb(videoLinks(iframe));
  }

  iframe.onload = returnMe;
  iframe.height = 0;
  iframe.width = 0;
  iframe.src = url;
  document.body.appendChild(iframe);
}

function allVideoLinks (cb) {
  var ret = [], pages = pagesNumber(content), j = 1;
  for (var i = 1; i <= pages; i++) {
    pageVideoLinks(i, function (links) {
      ret.concat(links);
      liberator.echomsg("Page " + i + " has " + links.length + " links");
      if (j++ == pages) {
        cb(ret.sort());
      }
    });
  }
}

function oldestVideos (cb) {
  var historical = history
        .get("http://www.escapistmagazine.com/videos/view/zero-punctuation/")
        .filter(function (x) {return (x.url.indexOf("http://www.escapist") == 0);})
        .reverse()
        .map(function(x) {return x.url;});
  allVideoLinks(function (links) {
    cb(links.sort(function (l1, l2) {
      return historical.indexOf(l1) < historical.indexOf(l2);
    }));
  });
}

commands.addUserCommand(
  ['oldestzeropunction'],
  'Open the oldes zero punctuation video in history.',
  function () {oldestVideos(function (links) {
    liberator.open(links[0]);
  });}
);
