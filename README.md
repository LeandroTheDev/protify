# Protify
Tired of using Steam to open your favorite games? your cpu is too old and steam consumes a lot of cpu process? you hate the numbers in compatdata and getting lost everytime you need to change something in the prefix? heres the solution protify is a simply and light-weight software builded in flutter to make a minimalist launcher for opening your favorite games in linux using proton.

This software is builded thinking in easily open your games and configure prefixes for you using the proton, and you can make a lot of tricks to run your games such adding arguments installing libraries, dlls and easily find the prefixes folder to make changes in there, the software comes with a easily gui to install libraries, dlls for prefixes and .exe/iso for games.

### Features
- Launch games with proton
- Install .exe games or .iso games
- Install libraries .exe drivers and runtimes in the game prefix folder
- Install dlls easily into game prefix folder
- Non proton games compatibility
- Preferences page
- Category system to organize your library

### Future Features
- Playtime
- Add game images
- Friends List
- Download Games

https://github.com/LeandroTheDev/protify/assets/106118473/b177c297-b642-4af4-baef-d2f6b5c9ecb4

https://github.com/LeandroTheDev/protify/assets/106118473/970d2a94-3671-4a52-8145-ae6bba9ff891

### Dependencies
- Install games with iso: sudo, mount
- Run games with sniper runtime: openssl-1.1
- Run/install windows games: proton or wine

### First steps
- Download protify from [releases](https://github.com/LeandroTheDev/protify/releases)
- Download the proton you want to use, normally in the steam
- Place the proton on ``protify/protons`` folder if you not changed in preferences
- See the more in [showcase](https://github.com/LeandroTheDev/protify/blob/main/SHOWCASE.md)

### FAQ
> Editing the game name will change the prefix folder?
- No, the folder prefix is generated on add game page or editing in edit page
> When i launch the game its crash and says c++ error
- Download vcruntime in official microsoft sites, click in the game and use the libs button, select the vcruntime, proceed to installation.
> When i launch the game its says is missing some random dll
- Download the dll and in game preview click in dll and install the dll.
> What types of data it will erase in clear button in preferences?
- All types of data that is managed by the protify: Games and Preferences.
- Prefixes and protons are not included.
> My steam is installed on a different location and i need to use steam compatibility how can i change?
- In the preferences page click in ``Steam Compatibility Directory`` and select your steam folder
> What happens if i remove the default prefix directory in my file manager and change it in preferences to another directory?
- All games will need to be reconfigured, if not reconfigured the games will still find the old folder and recreate the prefixes there
> Where is the best location to keep the protify in my device?
- In your home directory anywhere you want, the protify will automatically setup everthing for you in the first launch, if you change the location remember to clear the data

### Building
To build this project is very simple, all you need is to download the [flutter](https://docs.flutter.dev/get-started/install) framework and his dependencies to build, then create a project using ``flutter create protify``, paste all the files from this project in there, build using the ``flutter build linux --release``, the release will be stored in ``build/linux/x64/release/bundle/``.

If you are trying to debug the application dont forget to add the lib/protify_finder.txt!!! in project folder or the application will not work propertly.

Take a look in [Protify Server](https://github.com/LeandroTheDev/protify_server) to view more information about the store/friends features to make your own customizations.

FTM License.