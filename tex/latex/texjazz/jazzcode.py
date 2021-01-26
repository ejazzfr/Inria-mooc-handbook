# -*- coding: utf-8 -*-
"""
    pygments.styles.tango
    ~~~~~~~~~~~~~~~~~~~~~

    The Jazzcode Style is inspired from the color palette from
    the Radiant Ubuntu MATE Theme Guidelines.

    http://tango.freedesktop.org/Tango_Icon_Theme_Guidelines

    Butter:     #fce94f     #edd400     #c4a000
    Orange:     #fcaf3e     #f57900     #ce5c00
    Chocolate:  #e9b96e     #c17d11     #8f5902
    Chameleon:  #8ae234     #73d216     #4e9a06
    Sky Blue:   #729fcf     #3465a4     #204a87
    Plum:       #ad7fa8     #75507b     #5c35cc
    Scarlet Red:#ef2929     #cc0000     #a40000
    Aluminium:  #eeeeec     #d3d7cf     #babdb6
                #888a85     #555753     #2e3436

    Not all of the above colors are used; other colors added:
        very light grey: #f8f8f8  (for background)

    This style can be used as a template as it includes all the known
    Token types, unlike most (if not all) of the styles included in the
    Pygments distribution.

    :copyright: Copyright 2006-2017 by the Pygments team, see AUTHORS.
    :license: BSD, see LICENSE for details.
"""

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Number, Operator, Generic, Whitespace, Punctuation, Other, Literal


class JazzcodeStyle(Style):
    """
    The Jazzcode Style inspired from the color palette from
    the Radiant Ubuntu MATE Theme Guidelines.
    """

    # work in progress...

    #background_color = "#f8f8f8"
    default_style = ""

    styles = {
        # No corresponding class for the following:
        #Text:                     "", # class:  ''
        Whitespace:                "underline #f8f8f8",      # class: 'w'
        Error:                     "#a40000 border:#ef2929", # class: 'err'
        Other:                     "#000000",                # class 'x'

        Comment:                   "#765e2f", # class: 'c'  Original: italic #8f5902 #408080
        Comment.Multiline:         "#765e2f", # class: 'cm' Original: italic #8f5902 #408080
        Comment.Preproc:           "#765e2f", # class: 'cp' Original: italic #8f5902 #408080
        Comment.Single:            "#765e2f", # class: 'c1' Original: italic #8f5902 #408080
        Comment.Special:           "#765e2f", # class: 'cs' Original: italic #8f5902 #408080

        Keyword:                   "bold #772953",   # class: 'k'  Original: bold #204a87 #750000
        Keyword.Constant:          "bold #772953",   # class: 'kc' Original: bold #204a87 #750000
        Keyword.Declaration:       "bold #772953",   # class: 'kd' Original: bold #204a87 #750000
        Keyword.Namespace:         "bold #772953",   # class: 'kn' Original: bold #204a87 #750000
        Keyword.Pseudo:            "bold #772953",   # class: 'kp' Original: bold #204a87 #750000
        Keyword.Reserved:          "bold #772953",   # class: 'kr' Original: bold #204a87 #750000
        Keyword.Type:              "bold #772953",   # class: 'kt' Original: bold #204a87 #750000

        Operator:                  "#750000",        # class: 'o'  Original: bold #ce5c00 like a prompt
        Operator.Word:             "#204a87",        # class: 'ow' - like keywords Original: bold #204a87

        Punctuation:               "bold #000000",   # class: 'p'

        # because special names such as Name.Class, Name.Function, etc.
        # are not recognized as such later in the parsing, we choose them
        # to look the same as ordinary variables.
        Name:                      "#000000",        # class: 'n'  Original: #000000
        Name.Attribute:            "#c4a000",        # class: 'na' - to be revised
        Name.Builtin:              "#900090",        # class: 'nb' Original: #204a87
        Name.Builtin.Pseudo:       "#900090",        # class: 'bp' Original: #3465a4
        Name.Class:                "#808000",        # class: 'nc' - to be revised Original: #000000 #005875
        Name.Constant:             "#000000",        # class: 'no' - to be revised
        Name.Decorator:            "bold #5c35cc",   # class: 'nd' - to be revised
        Name.Entity:               "#750000",        # class: 'ni' Original: #ce5c00 like a prompt
        Name.Exception:            "bold #cc0000",   # class: 'ne'
        Name.Function:             "#005875",        # class: 'nf' Original: #000000
        Name.Property:             "#000000",        # class: 'py' Original: #000000
        Name.Label:                "#f57900",        # class: 'nl' Original: #f57900
        Name.Namespace:            "#000000",        # class: 'nn' - to be revised
        Name.Other:                "#000000",        # class: 'nx'
        Name.Tag:                  "bold #204a87",   # class: 'nt' - like a keyword #204a87
        Name.Variable:             "#000000",        # class: 'nv' - to be revised
        Name.Variable.Class:       "#000000",        # class: 'vc' - to be revised
        Name.Variable.Global:      "#000000",        # class: 'vg' - to be revised
        Name.Variable.Instance:    "#000000",        # class: 'vi' - to be revised

        # since the tango light blue does not show up well in text, we choose
        # a pure blue instead.
        Number:                    "#000000",        # class: 'm'  Original: bold #0000cf
        Number.Float:              "#000000",        # class: 'mf' Original: bold #0000cf
        Number.Hex:                "#000000",        # class: 'mh' Original: bold #0000cf
        Number.Integer:            "#000000",        # class: 'mi' Original: bold #0000cf
        Number.Integer.Long:       "#000000",        # class: 'il' Original: bold #0000cf
        Number.Oct:                "#000000",        # class: 'mo' Original: bold #0000cf

        Literal:                   "#000000",        # class: 'l'
        Literal.Date:              "#000000",        # class: 'ld'

        String:                    "#7d9029",        # class: 's'  Original: bold #4e9a06
        String.Backtick:           "#7d9029",        # class: 'sb' Original: bold #4e9a06
        String.Char:               "#7d9029",        # class: 'sc' Original: bold #4e9a06
        String.Doc:                "italic #8f5902", # class: 'sd' - like a comment
        String.Double:             "#7d9029",        # class: 's2' Original: bold #4e9a06
        String.Escape:             "#7d9029",        # class: 'se' Original: bold #4e9a06
        String.Heredoc:            "#7d9029",        # class: 'sh' Original: bold #4e9a06
        String.Interpol:           "#7d9029",        # class: 'si' Original: bold #4e9a06
        String.Other:              "#7d9029",        # class: 'sx' Original: bold #4e9a06
        String.Regex:              "#7d9029",        # class: 'sr' Original: bold #4e9a06
        String.Single:             "#7d9029",        # class: 's1' Original: bold #4e9a06
        String.Symbol:             "#7d9029",        # class: 'ss' Original: bold #4e9a06

        Generic:                   "#000000",        # class: 'g'
        Generic.Deleted:           "#a40000",        # class: 'gd'
        Generic.Emph:              "italic #000000", # class: 'ge'
        Generic.Error:             "#ef2929",        # class: 'gr'
        Generic.Heading:           "bold #000080",   # class: 'gh' Original: "bold #000080"
        Generic.Inserted:          "#00A000",        # class: 'gi'
        Generic.Output:            "#0000cf",        # class: 'go' Original: italic #000000
        Generic.Prompt:            "#770000",        # class: 'gp' Original: #8f5902
        Generic.Strong:            "bold #000000",   # class: 'gs'
        Generic.Subheading:        "bold #800080",   # class: 'gu'
        Generic.Traceback:         "bold #a40000",   # class: 'gt'
    }
