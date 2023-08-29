# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys

sys.path.insert(0, os.path.abspath('..'))

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'CloudVision Advanced Query Language'
copyright = '2023, Arista Networks'
author = 'Arista Networks'
release = "4"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon',
    'sphinx.ext.githubpages',
    'sphinx_toolbox.collapse',
    'sphinxcontrib.jquery',
]
templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
html_css_files = [
    'custom.css'
]
html_baseurl = 'https://aql.arista.com'
autosectionlabel_prefix_document = True
# Uncomment to disable all clickable images
# html_scaled_image_link = False

# -- Lexer for AQL Syntax Highlighting----------------------------------------

from pygments.lexer import RegexLexer
from pygments import token
from sphinx.highlighting import lexers

stdAQLTokens = [
    (r'\blet\b', token.Keyword),
    (r'\bif\b', token.Keyword),
    (r'\belse\b', token.Keyword),
    (r'\bfor\b', token.Keyword),
    (r'\bwhile\b', token.Keyword),
    (r'\bbool\b', token.Keyword),
    (r'\bstr\b', token.Keyword),
    (r'\bnum\b', token.Keyword),
    (r'\btype\b', token.Keyword),
    (r'\bduration\b', token.Keyword),
    (r'\bdict\b', token.Keyword),
    (r'\btimeseries\b', token.Keyword),
    (r'\btime\b', token.Keyword),
    (r'\bunknown\b', token.Keyword),
    (r'\bfalse\b', token.Keyword),
    (r'\btrue\b', token.Keyword),
    (r'\bin\b', token.Keyword),
    (r'[]{}:(),;?[]', token.Punctuation),
    (r'`.*`', token.Literal),
    (r'"[^"\\]*(?:\\.[^"\\]*)*"', token.String),
    (r'#.*$', token.Comment),
    (r'[a-zA-Z_]\w*', token.Name),
    (r'[0-9]+(\.[0-9]+)?(ns|us|µs|ms|s|m|h)', token.String),
    (r'[0-9]+(\.[0-9]+)?', token.Number),
    (r'\s', token.Whitespace),
    (r'!=|==|&&|\|\||[-+/*%=<>^!|]', token.Operator),
]

class AQLLexer(RegexLexer):
    name = 'aql'
    tokens = {
        'root': stdAQLTokens
    }

class AQLPromptLexer(AQLLexer):
    name: "aqlp"
    tokens = {
        'root': [
            (r'^[^(>>>|...)].*$', token.Text),
            (r'(^>>>)|(^...)', token.Escape),
        ] + stdAQLTokens
    }

lexers['aql'] = AQLLexer(startinline=True)
lexers['aqlp'] = AQLPromptLexer(startinline=True)

