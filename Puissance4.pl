:- dynamic board/1. pouet

%%%% Test if the game is finished
gameover(Winner) :- board(Board), winner(Board,Winner), !.  % There exists a winning configuration: We cut!
gameover('Draw') :- board(Board), isBoardFull(Board). % the Board is fully instanciated (no free variable): Draw.

%%%% Test if a Board is a winning configuration for the player P.


%%%% Recursive predicate that checks if all the elements of the List (a board) 
%%%% are instanciated: true e.g. for [x,x,o,o,x,o,x,x,o] false for [x,x,o,o,_G125,o,x,x,o]
isBoardFull([]).
isBoardFull([H|T]):- nonvar(H), isBoardFull(T).


%%%% Artificial intelligence: choose in a Board the index to play for Player (_)
%%%% This AI plays randomly and does not care who is playing: it chooses a free position
%%%% in the Board (an element which is an free variable).
%%%% ia(Board, Index, _) :- repeat, Index is random(7), nth0(Index, Board, Elem), var(Elem), !.





move(Move,Position,NewPosition) :- fall(Board, Move, Index),playMove(Postion,Index,NewPosition,_).

evaluate_and_choose([Move|Moves],Position,Record,Best):- 
    move(Move,Position,NewPosition),
    value(NewPosition,Value),
    update(Move,Value,Record,NewRecord),
    evaluate_and_choose(Moves,Position,NewRecord,Best).
    
evaluate_and_choose([],Position,(Move,Value),Move).

update(Move,Value,(Move1,Value1),(Move1,Value1)):- Value <= Value1.

update(Move,Value,(Move1,Value1),(Move,Value)):- Value > Value1.

column_is_empty(X) :- nth0(X,[0|1,2,3,4,5,6],Elem),var(Elem).

possible_move([H|Q],[]) :- column_is_empty(H),possible_move(Q,[H|_]).
 
ia(Board,Index,_) :- possible_move([0|1,2,3,4,5,6],Moves),evaluate_and_choose(Moves,Board,Record Best).






fall(Board, Move, Index):- nth0(Index, Board, X), var(X), mod(Index, 7) =:= Move, Index>34.
fall(Board, Move, Index):- nth0(Index, Board, X), var(X), mod(Index, 7) =:= Move, K is Index+7, nth0(K, Board, Y), nonvar(Y).

%%%% Recursive predicate for playing the game. 
% The game is over, we use a cut to stop the proof search, and display the winner/board. 
play(_):- gameover(Winner), !, write('Game is Over. Winner: '), writeln(Winner), displayBoard.
% The game is not over, we play the next turn
play(Player):-  write('New turn for:'), writeln(Player),
    		board(Board), % instanciate the board from the knowledge base 
       	    displayBoard, % print it
            ia(Board, Move,Player), % Move is the column
    		write(Move),
    		%(fall(Board, Move, Index) -> write(Index) ; Index is (Move+5*7)), % Deducing the index from the move (column)
    	    fall(Board, Move, Index),
    		playMove(Board,Index,NewBoard,Player), % Play the move and get the result in a new Board
		    applyIt(Board, NewBoard), % Remove the old board from the KB and store the new one
    	    changePlayer(Player,NextPlayer), % Change the player before next turn
            play(NextPlayer). % next turn!

%%%% Play a Move, the new Board will be the same, but one value will be instanciated with the Move
playMove(Board,Move,NewBoard,Player) :- Board=NewBoard,  nth0(Move,NewBoard,Player).

%%%% Remove old board/save new on in the knowledge base
applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).

%%%% Predicate to get the next player
changePlayer('x','o').
changePlayer('o','x').

%%%% Print the value of the board at index N:
% if its a variable, print ? and x or o otherwise.
printVal(N) :- board(B), nth0(N,B,Val), var(Val), write('?'), !.
printVal(N) :- board(B), nth0(N,B,Val), write(Val).

%%%% Display the board
displayBoard:-
    writeln('*----------*'),
    printVal(0), printVal(1), printVal(2), printVal(3), printVal(4), printVal(5), printVal(6), writeln(''),
    printVal(7), printVal(8), printVal(9), printVal(10), printVal(11), printVal(12), printVal(13), writeln(''),
    printVal(14), printVal(15), printVal(16), printVal(17), printVal(18), printVal(19), printVal(20), writeln(''),
    printVal(21), printVal(22), printVal(23), printVal(24), printVal(25), printVal(26), printVal(27), writeln(''),
    printVal(28), printVal(29), printVal(30), printVal(31), printVal(32), printVal(33), printVal(34), writeln(''),
    printVal(35), printVal(36), printVal(37), printVal(38), printVal(39), printVal(40), printVal(41), writeln(''),
    writeln('*----------*').
    
%%%%% Start the game! 
init :- length(Board,42), assert(board(Board)), play('x').