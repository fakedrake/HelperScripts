#!/usr/bin/env python
import matplotlib.pyplot as plt
import numpy as np


DEFAULT_DEGREE = 3
DEFAULT_ESTIMATE = 27
PLOT_RESOLUTION = 100

def fit(data, deg=DEFAULT_DEGREE, xaxis=None):
    print xaxis
    print data

    if xaxis is not None:
        x = np.array(xaxis)
    else:
        x = np.arange(len(data))

    y = data
    deg = min(deg, len(x)-1)

    poly = np.polyfit(x, y, deg)

    return np.poly1d(poly)

def plot_fit(data, project=None, deg=DEFAULT_DEGREE, xaxis=None):
    if xaxis is not None:
        x = np.array(xaxis)
    else:
        x = np.arange(len(data))

    fig = plt.figure()
    p = fig.add_subplot(111)

    fit_end = project or x[-1]*2
    print "Projecting to:", fit_end, "project:", project
    p.set_xlim([0, fit_end])


    x_fit = np.linspace(0, fit_end, PLOT_RESOLUTION)
    y_fit = fit(data, deg, xaxis)(x_fit)

    p.plot(xaxis or np.arange(len(data)), data, 'yo', x_fit, y_fit, '-r' )
    return fig

def _at(lst, index, default=None):
    return next(iter(lst[index:]), default)

def _main():
    """
    usage

    script_name {plot [image_file_name [projection_max]] | estimate [estimate length]} [degree]
    """

    import sys
    sys.argv.pop(0)

    _tmp = zip(*[map(float, l.split()) for l in sys.stdin.readlines()])
    if len(_tmp) > 1:
        data = _at(_tmp, 1)
        xdata = _at(_tmp, 0)
    else:
        data = _at(_tmp, 0)
        xdata = None

    cmd = _at(sys.argv, 0, 'estimate')
    deg = _at(sys.argv, 3, DEFAULT_DEGREE)

    if not data:
        sys.stderr.write("No data provided\n")
        exit(1)

    if cmd == 'plot':
        fimg = _at(sys.argv, 1)
        prj_max = _at(sys.argv, 2)
        if prj_max:
            prj_max = int(prj_max)

        print "Image file:", fimg, "projection:", prj_max

        if fimg and fimg != '-':
            plot_fit(data, project=prj_max, xaxis=xdata, deg=deg).savefig(fimg)
        else:
            plot_fit(data, project=prj_max, deg=deg, xaxis=xdata).show()
            import signal; signal.pause()

    elif cmd == 'estimate':
        x = _at(sys.argv, 1, DEFAULT_ESTIMATE)
        sys.stdout.write("%f\n" % fit(data, xaxis=xdata, deg=deg)(int(x)))
    else:
        sys.stderr.write("Unknown command %s" % cmd)

if __name__ == "__main__":
    _main()
