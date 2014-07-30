rch
===

CLI tool to replace characters on a set of files

Replace character(s) with another one character(s)
in a set of files given on a directory

## Using it

    rch -o 'i am sad' -n 'I AM GREAT!' -d /home/lucio/Development/bash/target -b new_maybe -v

This will remove any appearence of the string `i am sad` on every file that is on the directory `/home/lucio/Development/bash/target` making a backup of each file on the directory `new_maybe` (creating the dir if not exist) and also print what is it doing (verbosing). A coffee? Sure..

## LICENSE

GNU General Public License, Version 3. See the `LICENSE` file.
