evaluate_and_choose([Move|Moves],Position,Record,Best):- 
    move(Move,Position,NewPosition),
    value(NewPosition,Value),
    update(Move,Value,Record,NewRecord),
    evaluate_and_choose(Moves,Position,NewRecord,Best).

evaluate_and_choose([],Position,(Move,Value),Move).

update(Move,Value,(Move1,Value1),(Move1,Value1)):- Value <= Value1.

update(Move,Value,(Move1,Value1),(Move,Value)):- Value > Value1.

