:- dynamic board/1.

%%%% Test if a Board is a winning configuration for the player P.
initNbNeighborsToZero(0).
countNbLeftNeighbors(Board,Pos,NbLeftNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos-1,nth0(Pos1,Board,Player1),Player1==Player,Temp is Pos mod 7,Temp\==0,countNbLeftNeighbors(Board,Pos1,NbLeftNeighbors1),!,NbLeftNeighbors is NbLeftNeighbors1 + 1;initNbNeighborsToZero(NbLeftNeighbors).
countNbRightNeighbors(Board,Pos,NbRightNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos+1,nth0(Pos1,Board,Player1),Player1==Player,Temp is Pos1 mod 7,Temp\==0,countNbRightNeighbors(Board,Pos1,NbRightNeighbors1),!,NbRightNeighbors is NbRightNeighbors1 + 1;initNbNeighborsToZero(NbRightNeighbors).
countNbUpNeighbors(Board,Pos,NbUpNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos+7,nth0(Pos1,Board,Player1),Player1==Player,countNbUpNeighbors(Board,Pos1,NbUpNeighbors1),!,NbUpNeighbors is NbUpNeighbors1 + 1;initNbNeighborsToZero(NbUpNeighbors).
countNbDownNeighbors(Board,Pos,NbDownNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos-7,nth0(Pos1,Board,Player1),Player1==Player,countNbDownNeighbors(Board,Pos1,NbDownNeighbors1),!,NbDownNeighbors is NbDownNeighbors1 + 1;initNbNeighborsToZero(NbDownNeighbors).
countNbUpLeftNeighbors(Board,Pos,NbUpLeftNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos+6,nth0(Pos1,Board,Player1),Player1==Player,Temp is Pos mod 7,Temp\==0,countNbUpLeftNeighbors(Board,Pos1,NbUpLeftNeighbors1),!,NbUpLeftNeighbors is NbUpLeftNeighbors1 + 1;initNbNeighborsToZero(NbUpLeftNeighbors).
countNbUpRightNeighbors(Board,Pos,NbUpRightNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos+8,nth0(Pos1,Board,Player1),Player1==Player,Temp1 is Pos+1,Temp is Temp1 mod 7,Temp\==0,countNbUpRightNeighbors(Board,Pos1,NbUpRightNeighbors1),!,NbUpRightNeighbors is NbUpRightNeighbors1 + 1;initNbNeighborsToZero(NbUpRightNeighbors).
countNbDownLeftNeighbors(Board,Pos,NbDownLeftNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos-8,nth0(Pos1,Board,Player1),Player1==Player,Temp is Pos mod 7,Temp\==0,countNbDownLeftNeighbors(Board,Pos1,NbDownLeftNeighbors1),!,NbDownLeftNeighbors is NbDownLeftNeighbors1 + 1;initNbNeighborsToZero(NbDownLeftNeighbors).
countNbDownRightNeighbors(Board,Pos,NbDownRightNeighbors):-nth0(Pos,Board,Player),Pos1 is Pos-6,nth0(Pos1,Board,Player1),Player1==Player,Temp1 is Pos+1,Temp is Temp1 mod 7,Temp\==0,countNbDownRightNeighbors(Board,Pos1,NbDownRightNeighbors1),!,NbDownRightNeighbors is NbDownRightNeighbors1 + 1;initNbNeighborsToZero(NbDownRightNeighbors).

isInHorizontalLine(Board,Pos):-countNbLeftNeighbors(Board,Pos,NbLeftNeighbors),countNbRightNeighbors(Board,Pos,NbRightNeighbors),NbNeighbors is NbRightNeighbors+NbLeftNeighbors,NbNeighbors>2.
isInVerticalLine(Board,Pos):-countNbUpNeighbors(Board,Pos,NbUpNeighbors),countNbDownNeighbors(Board,Pos,NbDownNeighbors),NbNeighbors is NbUpNeighbors+NbDownNeighbors,NbNeighbors>2.
isInObliqueLine1(Board,Pos):-countNbUpLeftNeighbors(Board,Pos,NbUpLeftNeighbors),countNbDownRightNeighbors(Board,Pos,NbDownRightNeighbors),NbNeighbors is NbUpLeftNeighbors+NbDownRightNeighbors,NbNeighbors>2.
isInObliqueLine2(Board,Pos):-countNbUpRightNeighbors(Board,Pos,NbUpRightNeighbors),countNbDownLeftNeighbors(Board,Pos,NbDownLeftNeighbors),NbNeighbors is NbUpRightNeighbors+NbDownLeftNeighbors,NbNeighbors>2.
winner(Board,Pos):-isInHorizontalLine(Board,Pos),!;isInVerticalLine(Board,Pos),!;isInObliqueLine1(Board,Pos),!;isInObliqueLine2(Board,Pos).

%%%% Test if the game is finished
gameover(Index) :- board(Board), nth0(Index, Board, Elem), not(var(Elem)), winner(Board,Index), !.  % There exists a winning configuration: We cut!

%%%% Recursive predicate that checks if all the elements of the List (a board) 
%%%% are instanciated: true e.g. for [x,x,o,o,x,o,x,x,o] false for [x,x,o,o,_G125,o,x,x,o]
isBoardFull([]).
isBoardFull([H|T]):- nonvar(H), isBoardFull(T).

%%% Set of posibilities
/*moveSet([], Board, 0).
moveSet([Index|L], Board, Cmpt) :- board(B),
    fall(B, Move, Index),
    Cmpt1 is Cmpt-1,
    moveSet(L, Board, Cmpt1).*/


switch(X, [Val:Goal|Cases]) :-
    ( X=Val ->
        call(Goal)
    ;
        switch(X, Cases)
    ).

%%%% Artificial intelligence: choose in a Board the index to play for Player (_)
%%%% This AI plays randomly and does not care who is playing: it chooses a free position
%%%% in the Board (an element which is an free variable).
ia(Board, Move, IA, LastIndex, LastLastIndex,Player) :- repeat,    
    switch(IA, [
        1 : iaRandom(Move),
        2 : iaNaive(Move, LastLastIndex)
        3 : iaMiniMax(Player,Move)
    ]),
    nth0(Move, Board, Elem), 
    var(Elem), 
    !.

iaRandom(Move) :- Move is random(7).
iaNaive(Move, LastLastIndex) :- Temp is LastLastIndex+1,
    Move is mod(Temp, 7).

%%%% ia 
move(Board,Index):-between(0,6,Move),nth0(Move,Board,Elem),var(Elem),fall(Board,Move,Index).


evaluate_and_choose([Move|Moves],Board,Depth,Flag,Record,Best,Player):-  %%%% Depth 2
    playMove(Board,Move,NewBoard,Player),
    minimax(Depth,NewBoard,Flag,MoveX,Value,Player).
    update(Move,Value,Record,NewRecord),
    evaluate_and_choose(Moves,Board,Depth,Flag,NewRecord,Best).

evaluate_and_choose([],Board,Depth,Flag,Record,Record).


minimax(0,Board,Flag,Move,Value,Player):- value(Board,V),Value:=V*Flag.

minimax(Depth,Board,Flag,Move,Value,Player):- 
    D > 0, 
    set_of(M,move(Board,M),Moves),
    D1 := D - 1,
    Flag := -Flag, 
    evaluate_and_choose(Moves,Board,D1,Flag,(nil,-1000),(Move,Value),Player).

update(Move,Value,(Move1,Value1),(Move1,Value1)):- Value <= Value1.

update(Move,Value,(Move1,Value1),(Move,Value)):- Value > Value1.


%%%%% On part du principe que le board(Board) et fait en dehors du IA 


iaMiniMax(Player,BestMove) :- board(Board),set_of(M,move(Board,M),Moves),evaluate_and_choose(Moves,Board,Depth,Flag,Record,(BestIndex,Value),Player),BestMove is mod(BestIndex,7). %%%% A verifier si les colonne sont de 1 à 7 ou de 0 à 6

%%%%%

%%%%Ask colum
playerMove(Board, Move) :- repeat, write("Chose a column (0..6) :"), read(Move), between(0,6,Move), nth0(Move, Board, Elem), var(Elem), !.

%%%% Find the index in the board corresponding to the column
fall(Board, Move, Index):- nth0(Index, Board, X), var(X), mod(Index, 7) =:= Move, Index>34.
fall(Board, Move, Index):- nth0(Index, Board, X), var(X), mod(Index, 7) =:= Move, K is Index+7, nth0(K, Board, Y), nonvar(Y).

%%%% Recursive predicate for playing the game. 
% The game is over, we use a cut to stop the proof search, and display the winner/board. 
play(_, _, _, Index, _, _, _):- gameover(Index), !, displayBoard(0), writeln('You won !').
play(_, _, _, _, _, _, _) :- board(B), isBoardFull(B), !, displayBoard(0), writeln("Game over, you both lost.").

% Mode Jeu : 1-J VS J, 2-J VS C, 3-C VS C
% Mode IA : 1-Random, 2-Naive, 3-Heur (not done)
% The game is not over, we play the next turn
% play(game mode, current player, tour (1 ou -1), Index joué précédemment, ia1, ia2)
play(Mode, Player, Turn, LastIndex, LastLastIndex, IA1, IA2) :-
            board(Board), % instanciate the board from the knowledge base 
            displayBoard(0), % print it
            writeln(""), write('\nNew turn for:'), writeln(Player),
            %Chose the ia type
            ((Mode is 2 ; (Turn is 1, Mode is 3)) ->  IaMode is IA1 ; IaMode is IA2),
            write("IA mode :"), writeln(IaMode), 
            % Chose who plays depending on the Mode and/or the Turn
            ((Mode is 3 ; (Turn is 1, Mode is 2)) ->  ia(Board, Move, IaMode, LastIndex, LastLastIndex,Player) ; playerMove(Board, Move)),
            write("Disc played in column : "), writeln(Move),
            % Deducing the index from the move (column)
            fall(Board, Move, Index),
            playMove(Board,Index,NewBoard,Player), % Play the move and get the result in a new Board
            applyIt(Board, NewBoard), % Remove the old board from the KB and store the new one
            changePlayer(Player,NextPlayer), % Change the player before next turn
            NewTurn is Turn*(-1),
            play(Mode, NextPlayer, NewTurn, Index, LastIndex, IA1, IA2). % next turn!

%%%% Play a Move, the new Board will be the same, but one value will be instanciated with the Move
playMove(Board,Move,NewBoard,Player) :- Board=NewBoard,  nth0(Move,NewBoard,Player).

%%%% Remove old board/save new on in the knowledge base
applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).

%%%% Predicate to get the next player
changePlayer('x','o').
changePlayer('o','x').

%%%% Print the value of the board at index N:
% if its a variable, print _ and x or o otherwise.
printVal(N) :- board(B), nth0(N,B,Val), var(Val), write('_'), !.
printVal(N) :- board(B), nth0(N,B,Val), write(Val).

%%%% Display the board
displayBoard(42).
displayBoard(Val) :- printVal(Val), (lineBreak(Val) ->  writeln(" ") ; write(" ")), NextVal is Val+1, displayBoard(NextVal).
lineBreak(Val) :- NewVal is Val+1, mod(NewVal, 7) =:= 0.
    
%%%%% Start the game! 
init :- length(Board,42), assert(board(Board)), modeJeu(Mode, IA1, IA2), play(Mode, 'x', 1, 0, 0, IA1, IA2).
modeJeu(Mode, IA1, IA2) :- repeat, 
    write("Chose your game mode (1-J vs J, 2-J vs IA1, 3-IA1 vs IA2) :"), 
    read(Mode), 
    between(1,3,Mode),
    switch(Mode, [
                 1 : writeln("Here is the board :"),
                 2 : modeIA(IA1,1),
                 3 : (modeIA(IA1,1), modeIA(IA2,2))
    ]),
    !.

modeIA(IA, N) :- repeat, 
    write("Chose type of IA"),
    write(N),
    write(" : (1-Random, 2-Naive, 3-Attack) :"),                                           
    read(IA), 
    between(1,2,IA),
    !.
