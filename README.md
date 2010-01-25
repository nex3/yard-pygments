# yard-pygments

This is a plugin for the [YARD](http://yardoc.org) documentation system
that adds syntax highlighting for a wide variety of languages
using the [Pygments](http://pygments.org) syntax highlighter.

## Usage

Once the gem is installed, YARD should automatically load it.
Then any block of code beginning with `!!!lang` that YARD doesn't recognize
will be highlighted using Pygments if possible.
Unless another highlighter is installed, in which case it might take precedence.

By default, YARD itself only recognizes Ruby.
The full list of languages recognized by Pygments is available [here](http://pygments.org/docs/lexers/).
The names that will be recognized for these languages are listed under "short names".

## Requirements

yard-pygments requires, unsurprisingly, YARD and Pygments.
YARD will be installed along with the gem,
but since Pygments is written in Python,
it needs to be installed manually.
If you've got [`easy_install`](http://peak.telecommunity.com/DevCenter/EasyInstall), you can do

    !!!sh
    easy_install Pygments

Otherwise, it can be downloaded [here](http://pypi.python.org/pypi/Pygments).
