# atomic-sync

syncs 🔄 atom ⚛ config/packages to the cloud ☁️


## howto

- clone this repository locally.

- optional: if you want a clean slate, delete the contents of the [`/etc`][etc] directory.

- use the `atomic-sync` command (found under [`/bin`][bin]) to sync settings and packages:
   - export settings and packages from atom and save them to the local repository, so they're ready to be uploaded to github:

         atomic-sync export

   - import settings from the local repository into atom:

         atomic-sync import [--skip-packages]

     `--skip-packages` will avoid installing packages found on the package list file.


   run `atomic-sync` for the help manual.



[bin]: /bin
[etc]: /etc
