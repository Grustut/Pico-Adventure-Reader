# Pico-Adventure-Reader
A small text interpreter for Text-Based games in Haskell
--------------------------------------------------------

This project is intended as a exercice for Haskell.
It is a small project that is intended to grow as time goes by and my understanding and abalities with the language groes.

First instance had these goals :
Create a program that can :
  Read a text file
  Interpret its content based on simple markers
  Return the playable game in the console

# How does it work ?
  Create a game file
  
  Game files are simple .txt files in which :
    The marker '#' followed by a number represent a Situation
    The marker '@' is followed by the current situations offered choices and their coreesponding actions
        After an '@' marker, you can define :
        input > action : input is what the player is suppose to type in and action is what the program should do next
        When multiple choices are available separate the input > action with a comma
        input and action cannot contains blank spaces and all should be on the same line
        For the moment the only way to end the game is by using the hardcoded Enter>End pair
   The marker '$' shows the end of the program. The interpreter would not go further than this point.
   
   Here is an example of a very simple Game :
   
   #1
   You are in a room with two doors in front of you.
   You go through the door on the (left) or on the (right) ?
   @left > 2, right > 3
   #2
   You went left. Yay !
   @Enter > End
   #3
   You went right. Youhou !
   @Enter > End
   $
