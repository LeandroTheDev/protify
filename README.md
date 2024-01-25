# Protify
Tired of using Steam to open your favorite games? you hate the numbers in compatdata and getting lost evertime you need to change something in the prefix? heres the solution protify is a simply and light-weight software builded in flutter to make a minimalist launcher for opening you favorite games in linux using proton.

This software is builded thinking in easily open your games and configure prefixes for you using the proton, and you can make a lot of tricks to run your games such adding arguments intalling libraries and easily find the prefixes folder to make changes in there, the software comes with a easily gui to install libraries for you prefix.

### Features
- Launch games with all proton versions
- Install .exe drivers and runtimes in the game prefix folder
- Non proton games compatibility
- Flexible prefixes folder
- Preferences Page

### Future Features
- Add dlls to prefix
- Playtime
- Add game images
- Category

[``Demonstration``](https://github.com/LeandroTheDev/protify/assets/106118473/890667c5-4fd9-430c-b834-fddf0520b645)

[``Library Demonstration``](https://github.com/LeandroTheDev/protify/assets/106118473/51c81b4f-5a9d-46de-91a6-c3edef9a668c)

### First steps
- Download protify from [releases](https://github.com/LeandroTheDev/protify/releases)
- Download the proton you want to use, normally in the steam
- Place the proton in ``protify/protons`` folder
- See the [showcase](https://github.com/LeandroTheDev/protify/blob/main/SHOWCASE.md) for using the launcher

### FAQ
- Editing the name will change the prefix folder name?
> No, the folder prefix is generated in add game section or editing in edit section
- When i launch the game its crash and says c++ error
> Download vcruntime in official microsoft sites, click in the game and use the libs button, select the vcruntime, proceed to installation.
- What types of data it will erase in clear button in preferences?
> All types of data that is managed by the protify: Games and Preferences.
- > prefixes and protons is not included.

### Building
To build this project is very simple, you need is to download the [flutter](https://docs.flutter.dev/get-started/install) framework, after that create a project using ``flutter create protify``, paste all the files from this project in there, build using the ``flutter build linux --release`` and the release will be stored in ``build/linux/x64/release/bundle/``
