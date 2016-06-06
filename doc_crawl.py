from bs4 import BeautifulSoup as BS
import urllib2

def crawl(url, link_path, article_path, toc_path=None, skip=None):
    toc = BS(urllib2.urlopen(url).read()).select(toc_path or article_path).pop()

    pages = [toc]
    for h in pages[0].select(link_path):
        link = h.attrs["href"]
        html = urllib2.urlopen(link).read()

        if skip and not skip(link, html):
            print "Read %d characters from %s" % (len(html), link)
            pages.append(BS(html).select(article_path).pop())

    return pages

# pgs = crawl("http://thehipperelement.com/post/75476711614/ux-crash-course-31-fundamentals", "a", ".articleBody", skip=lambda l,_: "twitter" in l)
# open("./ux.html", "w+").write(body)
# pandoc -s ux.html --normalize ux.pdf
