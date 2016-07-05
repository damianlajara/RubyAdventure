# Welcome to RubyAdventure

# Overall Gameplay
The Game is kind of like a hybrid between a board game and a text-based RPG game (or at least that's the plan).

### Customization
As soon as you run the game, you will be prompted to enter some basic information such as name and gender. You will also be asked to create your own custom hero from a wide variety of jobs and classes. After all the customization is done, it's officially time to start playing the game!

### Main Menu
The game officially starts off with a main menu, where you can choose to either enter the dungeon (this is where all the fun begins), go visit the shop and stock up on supplies like weapons, armor and potions, or open the options menu where you can change your name, gender, class and even toggle the the verbose battle output on/off.

### Dungeon
Once you enter the dungeon, you will be given the option to roll two dice, visit conquered dungeon levels, check your stats and progress in the dungeon and of course go back to the main menu if you wish.

If you choose to roll the dice (this is the board-game like aspect of it), you will be able to either take a random number of steps (according to the number you rolled) if the roll comes out even or battle monsters if it's odd. The difficulty of the monsters will increase as you go deeper and deeper into the dungeon.

If you roll a double, you will get a hint. If you collect all 3 hints, you will then get a key (bronze, silver, or gold) with the rarity and chance of receiving one in that same order. If you receive three keys of either bronze or silver you can forge them into a silver and gold key, respectively.

You can then use the key to unlock various treasures laying around in the dungeon.

Every dungeon also has a specified number of steps. Once you clear all the steps you will awaken the dungeon gate keeper. Once you defeat him you will conquer the dungeon and can move on to the next level. You can still choose to go back and visit all conquered levels in order to defeat weaker monsters in order to level up.

# TO-DO list / ideas for the future
* Make a way to save progress in the game with text files. Or turn it into a web app with a database.
* Add abilities. Also add mana to every hero class, since the abilities depend on mana consumption
* Add extra attributes such as dodge/evade, chance of hits, luck and mobility to make use of archer classes and stuff for strategic play

# Pre-requisites
* Must be running Ruby version 2.2.0 or greater.
* Must have the gem 'bundler' installed. Simple run `gem install bundler` if you don't.
* Run `bundle install` to make sure the dependencies are all good to go.

#Play
### In order to run the game, simply `cd` into this directory and run `./main.rb`. You can also type `ruby main.rb`.
