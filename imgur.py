#!/usr/bin/env python2
import Tkinter as tk
from PIL import Image, ImageTk
import json

from pprint import pprint

import os
import pyimgur

CLIENT_ID = "3646d99ff2928d0"
UPLOADED_FILES_JSON = "/home/fakedrake/bin/imgur.json"
HELP = ""

class MyImg(object):
    link = "a link"
    def upload_image(self, *ar, **kw):
        return MyImg()

def upload_image(path, title, jsondb=UPLOADED_FILES_JSON):
    if os.path.isfile(jsondb):
        imgs = json.load(open(jsondb))
    else:
        imgs = dict()           # path->link

    if path in imgs:
        link = imgs[path]
    else:
        im = pyimgur.Imgur(CLIENT_ID)
        img = im.upload_image(path, title=title)
        imgs[path] = img.link
        open(jsondb, "w+").write(json.dumps(imgs))

        link = img.link

    return link

def isimage(fname):
    for ext in [".png", ".jpg", ".gif"]:
        if fname.endswith(ext):
            return True

    return False

def images_in(rootdir="/home/fakedrake/Pictures/"):
    flist = []

    for root, subfolders, files in os.walk(rootdir):
        flist += [os.path.join(root, f) for f in files
                  if isimage(f)]

    return sorted(flist, reverse=True, key=lambda f: os.path.getctime(f))

def show_image(path):
    root = tk.Tk()
    root.title('background image')

    # pick an image file you have .bmp  .jpg  .gif.  .png
    # load the file and covert it to a Tkinter image object
    imageFile = path
    image1 = ImageTk.PhotoImage(Image.open(imageFile))

    # get the image size
    w = image1.width()
    h = image1.height()

    # position coordinates of root 'upper left corner'
    x = 0
    y = 0

    # make the root window the size of the image
    root.geometry("%dx%d+%d+%d" % (w, h, x, y))

    # root has no image argument, so use a label as a panel
    panel1 = tk.Label(root, image=image1)
    panel1.pack(side='top', fill='both', expand='yes')

    # save the panel's image from 'garbage collection'
    panel1.image = image1

    # start the event loop
    root.mainloop()


if __name__ == "__main__":
    print "Usage: imgur [<title> [image number]]"
    import sys
    a = sys.argv

    imgsf = images_in()
    title = a[1] if len(a) > 1  else "<Untitled>"
    upc = int(a[2]) if len(a) > 2 else 0

    print "Uploading image (kill script to cancel)"
    print "\tTile:", title
    print "\tFname (%dth newest):", imgsf[upc]
    print ""
    print "Recet images:"
    for i, im in enumerate(imgsf[:10]):
        print "\t%d: %s" % (i, im)

    print "To upload close window, to cancel kill script..."
    show_image(imgsf[upc])
    print "Uploading...",
    url = upload_image(imgsf[upc], title)
    print "Done"
    print "URL:", url
