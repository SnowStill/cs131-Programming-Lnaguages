(*problem 1*)
let rec subset a b = match a with
  |[] -> true
  |head::tail -> if (List.mem head b) then (subset tail b) else false;;

(*problem 2*)
let equal_sets a b = 
  subset a b && subset b a;;

(*problem 3*)
let rec set_union a b = match a with
  |[] -> b
  |head::tail -> if(List.mem head b) then (set_union tail b)else (set_union tail (head::b));;

(*problem 4*)
 
let rec helper a b = match a with
  |[] -> []
  |head::tail -> if(List.mem head b) then (helper tail b)else (head::(helper tail b));;
   
let set_symdiff a b = (helper b a) @ (helper a b)

(*problem 5*)
(*It is impossible to write such a function since there is a restriction of types to avoid Russell's Paradox. Assume A is an int list, if A contains itself, then the type of A will be an int, but at the sametime, A is an int list. It just conflicts. *)

(*problem 6*)
let rec computed_fixed_point eq f x = 
  if eq (f x) x then x else computed_fixed_point eq f (f x);;

(*problem 7*)

type ('nonterminal, 'terminal) symbol =
  |N of 'nonterminal
  |T of 'terminal

let isN symbol = match symbol with
  |N nonterminal -> true
  |T terminal -> false;;

let rec getNs rhs = match rhs with
  |[] -> []
  |head::tail -> if (isN head) then
    head::(getNs tail)
  else getNs tail;;

let rec addReachable rules newlist = match rules with
  |[] -> newlist
  |head::tail -> if List.mem (N(fst head)) newlist  then 
    let newNs = getNs (snd head) in
    let newlist = set_union newlist newNs in
    addReachable tail newlist
  else addReachable tail newlist;;

let rec allReachable rules list = 
  computed_fixed_point equal_sets (fun x -> (addReachable rules x)) list;;

let rec finalList rules reachableN = match rules with
  |[] -> []
  |head::tail -> if List.mem (N (fst head)) reachableN then
    head::(finalList tail reachableN)
  else finalList tail reachableN;;

let filter_reachable g = 
  let start = fst g in
  let rules = snd g in
  let reachableN = allReachable rules [N start] in
  (start, finalList rules reachableN);;
