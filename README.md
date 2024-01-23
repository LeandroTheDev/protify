# Protify
Tired of using Steam to open your favorite games? heres the solution protify is a simply and light-weight software builded in flutter to make a minimalist launcher for opening you favorite games in linux using proton.

This software is builded thinking in easily open your games and configure prefixes for you.

[``Demonstration``](https://github.com/LeandroTheDev/protify/assets/106118473/890667c5-4fd9-430c-b834-fddf0520b645)

### First steps
- Disclaimer: Using steam compatibility you need to have a steam installed in ~/.local/share/Steam
- Download Steam from your favorite way
- Download the proton you want to use throught the steam
- Go to ``.local/share/Steam/steamapps/common/`` and copy your Proton
- Place the proton in ``protify/protons`` folder
-

- Now in protify add your new game

> ![image](https://github.com/LeandroTheDev/protify/assets/106118473/4327b31a-9351-4360-9576-3ca12282d650)

- Fill all the labels and select your proton

> ![image](https://github.com/LeandroTheDev/protify/assets/106118473/12c7cad8-8af2-402d-bb48-2b76eb7179f8)
> 
> Launch/Arguments is not obrigatory.
> 
> Prefix is not obrigatory.
>
> Launch Commands comes before the executable and Arguments Commands comes after executable like this: "LaunchCommands MyGame.exe ArgumentsCommands"

- Now click in the game card to launch the game, and a console will pop up showing the logs from terminal, after that the game will pop up and you will be able to play, you can close the launcher after game start.

> ![image](https://github.com/LeandroTheDev/protify/assets/106118473/901c4a9d-673c-40d5-b785-d765f590ce89)

- You also can delete the game by right clicking with mouse in the card

> ![image](https://github.com/LeandroTheDev/protify/assets/106118473/6971c040-b78f-4987-bd1f-64afdc33416a)

### Building
To build this project is very simple, you need to download the [flutter](https://docs.flutter.dev/get-started/install) framework, after that create a project using ``flutter create protify``, paste all the files from this project in there, build using the ``flutter build linux --release`` and the release will be stored in ``build/linux/x64/release/bundle/``