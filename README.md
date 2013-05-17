# Speeddev

Speeddev is a small tool to allow you to easily compile or minify files, no matter what type of file you are using.

## Installation

    $ gem install speeddev

## Usage

    Usage: speeddev OPERATION [options] file1 file2 ...
    
    Operations:
        -c, --compile                    Compile to CSS (default)
    
    Compile Operation options:
        -o, --compress                   Compress output
    
    Common options:
        -h, --help                       Show this message
            --version                    Show version

## Supported Tech

It can currently compile and compress the following:

* [LESS](http://lesscss.org/)
* [Sass](http://sass-lang.com/) (and scss)
* [Stylus](http://learnboost.github.io/stylus/)

It can compile, but not compress, the following:

* [Markdown](http://daringfireball.net/projects/markdown/)