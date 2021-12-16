# atom-config

my atom editor settings and packages


## howto

- clone this repository locally.
- use the `atom-config` command (found under [`/bin`][bin]) to sync settings and packages:
   - import settings from the local repository into atom:

         atom-config import [--skip-packages]

     `--skip-packages` will avoid installing packages found on the package list file.

   - export settings and packages from atom and save them to the local repository, so they're ready to be uploaded to github:

         atom-config export

   run `atom-config` for the help manual.



[bin]: /bin
