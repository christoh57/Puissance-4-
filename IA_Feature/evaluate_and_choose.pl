evaluate_and_choose([Move|Moves],Position,Depth,Flag,Record,Best):- 
    move(Move,Position,NewPosition),
    minimax(Depth,NewPosition,Flag,MoveX,Value).
    update(Move,Value,Record,NewRecord),
    evaluate_and_choose(Moves,Position,Depth,Flag,NewRecord,Best).

evaluate_and_choose([],Position,Depth,Flag,Record,Record).

minimax(0,Position,Flag,Move,Value):- value(Position,V),Value:=V*Flag.

minimax(Depth,Position,Flag,Move,Value):- 
    D > 0, 
    set_of(M,move(Position,M),Moves),
    D1 := D - 1,
    Flag := -Flag, 
    evaluate_and_choose(Moves,Position,D1,Flag,(nil,-1000),(Move,Value)).

update(Move,Value,Record,NewRecord)

