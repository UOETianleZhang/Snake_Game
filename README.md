# Snake Game
This project is a set of small games written in Verilog based on FPGA. It includes two games: the famous snake game and a "Break the Bricks" game. At the very beginning, there is a big "GO" displayed on the screen, which is in "idle" state.

If any button is pressed, the procedure will go to "play" state, i.e., the first level: snake game. In the snake game, you can change the direction of the snake by pressing buttons. To be noticed, the snake can just turn 90 degrees, i.e., it can only go to left or right direction when in up or down direction, and vice versa. After the snake eating the food, the length of snake and the score displayed on 7-segments will individually increase by one, and the speed of the snake will also increase. But if the snake has eaten a poison, the opposite thing will occur. Apart from that, you can accelerate the snake by switching on the very left switch, and you can even "cheat" by switching on the very right switch to get scores quickly. if your snake hit itself, the procedure will go to "fail" state, with some letters appearing.

If you get the aim score (20 here), the procedure will go to "win" state, with the second level: "Break the Bricks" game starting. In this game, you will control a board by buttons to protect the bottom line from hitting. The ball will reflect when encountering walls and the front of the board.

Take it easy, there is no any punishment at this procedure, please have fun! :)

**More details can be found in "Snake Game User's Manual.pdf"**
