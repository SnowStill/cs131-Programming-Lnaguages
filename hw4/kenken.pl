%tower 

%transpose, from https://stackoverflow.com/questions/4280986/how-to-transpose-a-matrix-in-prolog

transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).


unique_list(_, []).
unique_list(N, [H|T]) :-
    length(H, N),
    fd_domain(H, 1, N),%Define all values in List to be between 1 and N
    fd_all_different(H),%Define all values in List to be different
    unique_list(N, T).


get_num([Row|Col], T, Num) :-
  nth(Row, T, List), 
  nth(Col, List, Num).

add(0, [], T).
add(Sum, [Head | Tail], T) :-
  get_num(Head, T, Num),
  add(S, Tail, T),
  Sum #= Num + S.

subt(Diff, Head1, Head2, T) :-
  get_num(Head1, T, Num1),
  get_num(Head2, T, Num2),
  (Diff #= Num1 - Num2; Diff #= Num2 - Num1).

mul(1, [], T).
mul(Prod, [Head | Tail], T) :-
  get_num(Head, T, Num),
  mul(P, Tail, T),
  Prod #= Num * P.

div(Res, Head1, Head2, T) :-
  get_num(Head1, T, Num1),
  get_num(Head2, T, Num2),
  (Res #= Num1 / Num2; Res #= Num2 / Num1).

constraints([], T).
constraints([+(Sum, Head) | Tail], T) :-
  add(Sum, Head, T),
  constraints(Tail, T).

constraints([-(Diff, Head1, Head2) | Tail], T) :-
  subt(Diff, Head1, Head2, T),
  constraints(Tail, T).

constraints([*(Prod, Head) | Tail], T) :-
  mul(Prod, Head, T),
  constraints(Tail, T).

constraints([/(Res, Head1, Head2) | Tail], T) :-
  div(Res, Head1, Head2, T),
  constraints(Tail, T).

check_row_len([], _).
check_row_len([H|T], N)
    :-length(H, N),check_row_len(T, N).

kenken(N, C, T) :-
    N >= 0,
    length(T,N),
    check_row_len(T,N),
    unique_list(N,T),
    transpose(T, Ttrans),
    unique_list(N, Ttrans),
    constraints(C, T),
    maplist(fd_labeling, T).
    


%plain_kenken

plain_add(0, [], T).
plain_add(Sum, [Head | Tail], T) :-
  get_num(Head, T, Num),
  plain_add(S, Tail, T),
  Sum is Num + S.

plain_subt(Diff, Head1, Head2, T) :-
  get_num(Head1, T, Num1),
  get_num(Head2, T, Num2),
  (Diff is Num1 - Num2; Diff is Num2 - Num1).

plain_mul(1, [], T).
plain_mul(Prod, [Head | Tail], T) :-
  get_num(Head, T, Num),
  plain_mul(P, Tail, T),
  Prod is Num * P.

plain_div(Res, Head1, Head2, T) :-
  get_num(Head1, T, Num1),
  get_num(Head2, T, Num2),
  (Res is Num1 / Num2; Res is Num2 / Num1).

plain_constraints([], T).
plain_constraints([+(Sum, Head) | Tail], T) :-
  plain_add(Sum, Head, T),
  plain_constraints(Tail, T).
plain_constraints([-(Diff, Head1, Head2) | Tail], T) :-
  plain_subt(Diff, Head1, Head2, T),
  plain_constraints(Tail, T).

plain_constraints([*(Prod, Head) | Tail], T) :-
  plain_mul(Prod, Head, T),
  plain_constraints(Tail, T).

plain_constraints([/(Res, Head1, Head2) | Tail], T) :-
  plain_div(Res, Head1, Head2, T),
  plain_constraints(Tail, T).

unique_list2(N, []).
unique_list2(N, [H | T]) :-
  length(H, N), 
  findall(Num, between(1, N, Num), Domain), 
  permutation(H, Domain),
  unique_list2(N, T).

plain_kenken(N, C, T) :-
  N >= 0,
  length(T,N),
  check_row_len(T,N),
  unique_list2(N, T),
  transpose(T, Ttrans),
  unique_list2(N, Ttrans),
  plain_constraints(C, T).

kenken_testcase(
  6,
  [
   +(11, [[1|1], [2|1]]),
   /(2, [1|2], [1|3]),
   *(20, [[1|4], [2|4]]),
   *(6, [[1|5], [1|6], [2|6], [3|6]]),
   -(3, [2|2], [2|3]),
   /(3, [2|5], [3|5]),
   *(240, [[3|1], [3|2], [4|1], [4|2]]),
   *(6, [[3|3], [3|4]]),
   *(6, [[4|3], [5|3]]),
   +(7, [[4|4], [5|4], [5|5]]),
   *(30, [[4|5], [4|6]]),
   *(6, [[5|1], [5|2]]),
   +(9, [[5|6], [6|6]]),
   +(8, [[6|1], [6|2], [6|3]]),
   /(2, [6|4], [6|5])
  ]
).

kenken_testcase2(
  4,
  [
   +(6, [[1|1], [1|2], [2|1]]),
   *(96, [[1|3], [1|4], [2|2], [2|3], [2|4]]),
   -(1, [3|1], [3|2]),
   -(1, [4|1], [4|2]),
   +(8, [[3|3], [4|3], [4|4]]),
   *(2, [[3|4]])
  ]
).

kenken_testcase3(
  4,
  [
   -(2, [1|1], [2|1]),
   /(2, [1|2], [1|3]),
   -(1, [1|4], [2|4]),
   *(4, [[2|2]]),
   +(6, [[2|3], [3|3], [4|3]]),
   -(3, [3|1],[3|2]),
   *(12,[[3|4],[4|4]])
   +(5,[[4|1],[4|2]])
  ]
).


kenken_time(Ttime) :-
    statistics(cpu_time,[Start|_]),
    kenken_testcase2(N,C), kenken(N,C,T),
    statistics(cpu_time,[End|_]),
    Ttime is End - Start.

plain_kenken_time(Ptime) :-
    statistics(cpu_time,[Start|_]),
    kenken_testcase2(N,C), plain_kenken(N,C,T),
    statistics(cpu_time,[End|_]),
    Ptime is End - Start.

speedup(Ratio) :-
    kenken_time(Ttime),
    plain_kenken_time(Ptime),
    Ratio is Ptime / Ttime.

