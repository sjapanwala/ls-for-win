```txt
Listing Your Files Inside Your Terminal
Lists files inside the current directory by default

Usage: ls [OPTION]... [FILE]... [CODE]...

OPTIONS: Options are required for a customized view, else will show basic ls listing.
   -ex, --expand                expandable  info, shows brief information about the file (listed)
                                (format for -ex: rootdirname filename filesize(B,MB,GB) editdate rootpath), (HS)

   -nt, --neat                  neat, neatly organizes all the files in a horizontal list

   -tr,  --legacy               legacy, miniature file tree/legacy (better alternative is windows "tree" command)

   -sbf, --searchbyfile         search by file, shows only files with the specific file extention.
                                REQUIRES FILETYPE ARG IN PLACE OF FILE ARG (.txt, .cmd, .json, etc...)

   -bd, --breakdown             file breakdown, shows a whole lot of information about a specific file.
                                REQUIRES FILE ARG IN PLACE OF FILE ARG (please include file ext to reduce ambiguity), (HS)

   -pk, --peek                  lists inside a dir, without being inside.
                                REQUIRES DIR NAME IN FILE

   -r, --recursive              recursively lists everything from current dir, down.
                                larger files may take longer to process.

OTHER: Other commands that are for management, and other cases.
   -?, -h, --help   shows help menu, Usage: ls --help [OTHER]
                    -> with no args, will shows general help
                    -> [-a]    help about everything
                    -> Specific Command Help (ls --help [-command])

   -R, --readme    redirects you to the readme file on www.github.com/sjapanwala

   -l, --legal     shows all legal information about this program.

   -sec            shows the error code once the program has finished execution
                   (input into CODE section)

   --logs           recent update logs

   --update         apply updates

Notes,
   -> (HS) - Help Supported (-ex, -bd, -ls)
```
