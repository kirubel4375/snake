import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class Snake extends StatefulWidget{

  @override
  _SnakeState createState()=>_SnakeState();
}
class _SnakeState extends State<Snake>{

  List<int> snake = [45, 65, 85, 105, 125];
  int squareNumber = 760;
  int counter = 0;
  int highScore = 0;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(760);
  void generateFood(){
    food = randomNumber.nextInt(760);
  }

  void startGame(){
    counter = 0;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      updateSnake();
      if(gameOver()){
        timer.cancel();
        if(highScore < counter) highScore = counter;
        snake = [45, 65, 85, 105, 125];
      }
    });
  }

  late Directions _directions = Directions.down;
  void updateSnake(){
    setState(() {
      switch(_directions){
      case Directions.up:
        if(snake.last<20){
          snake.add(snake.last +740);
        }else{
          snake.add(snake.last -20);
        }
        break;
      case Directions.down:
        if(snake.last>739){
          snake.add(snake.last -740);
        }else{
          snake.add(snake.last +20);
        }
        break;
      case Directions.left:
        if(snake.last % 20 == 0){
          snake.add(snake.last -1 + 20);
        }else{
          snake.add(snake.last-1);
        }
        break;
      case Directions.right:
      if((snake.last+1) % 20 ==0){
        snake.add(snake.last + 1 -20);
      }else{
        snake.add(snake.last+1);
      }
        break;
    }

    if(snake.last==food){
      counter++;
      generateFood();
    }else{
      snake.removeAt(0);
    }
    });
    
  }

  bool gameOver(){
    for(int value in snake){
      int valueCount = 0;
      for(int otherValue in snake){
        if(value == otherValue) valueCount++;
      }
      if(valueCount==2){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(_directions!=Directions.up && details.delta.dy>0){
                    _directions = Directions.down;
                  }else if(_directions != Directions.down && details.delta.dy<0){
                    _directions = Directions.up;
                  }
                },
                onHorizontalDragUpdate: (details){
                  if(_directions != Directions.left && details.delta.dx>0){
                    _directions = Directions.right;
                  }else if(_directions != Directions.right && details.delta.dx<0){
                    _directions = Directions.left;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: GridView.builder(
                    itemCount: squareNumber,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20), 
                    itemBuilder: (BuildContext context, int index){
                      if(snake.contains(index)){
                        if(index==snake.last) return Container(
                          decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                          ),
                        );
                        else return Container(
                          decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                          ),
                        );
                      }else if(food == index){
                        return Container(
                          decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                          ),
                        );
                      }else return Container(
                          decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(3),
                          ),
                        );
                    },
                    ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: ()=>startGame(), child: Text("Start",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                )),
                Text("Score: $counter",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                ),
                Text("high Score: $highScore",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}



enum Directions{
  up,
  down,
  left,
  right
}