rch
===

CLI tool to replace characters on a set of files

Replace character(s) with another one character(s)
in a set of files given on a directory

## Using it

    rch -o 'i am sad' -n 'I AM GREAT!' -d /home/lucio/happy/docs

This will replace `i am sad` with `I AM GREAT` on every file's content that is inside the directory `/home/lucio/happy/docs/`.

    rch -o 'i am scary' -n 'I AM SAFE!' -p /home/lucio/advanced/*.txt -b new_maybe -v

This will replace any appearence of the string `i am scary` with `I AM SAFE!` on every `.txt` file that is on the directory `/home/lucio/advanced/` making a backup of each file on the directory `new_maybe` (creating the dir if not exist) and also print what is it doing (verbosing). A coffee? Sure..

## Deployment

I'm far from it, but at the moment you can move it to the `/usr/bin` folder to use it from any place 

 1. [Download the script](https://github.com/lucio-martinez/rch/releases)

 2. Move it to the binaries folder with 

  `sudo mv /path/to/the/downloaded/script/rch.sh /usr/bin/rch`

 3. Done!

Now you may type `rch` on the terminal at anytime! You can reboot the machine and the script will be there. Enjoy it :)

## Wishlist

 - The target directory has to be full path. You should be able to enter relative paths too. I promese to change it quickly!

 - It doesn't like special characters. For instance, entering `/` would break it. That's sad :(  
   If you have a cool idea that may fix this, please share it!

## LICENSE

GNU General Public License, Version 3. See the `LICENSE` file.
