(* CIS-515 Project 1- OCaml Basics *)
(* hellocaml.ml *)

(* 
 * GOAL: get up to speed with OCaml --- write a simple arithmetic
 * interpreter.  Also, please feel ask a course staff member for help if
 * you get stuck - post your questions to Sakai or drop by during office
 * hours. Learning OCaml is essential for your successful completion of
 * later projects, but it is not supposed to be too onerous in itself! 
 *)

(* 
 * Files in this project:
 *
 * hellocaml.ml     -- (this file) the main project file you will need to modify 
 *
 * assert.ml        -- a unit test framework used throughout the course
 * gradedtests.ml   -- tests that we will run to assess the correctness
 *                     of your homework
 * providedtests.ml -- tests that you write to help with debugging and for
 *                     a grade (as requested below)
 * main.ml          -- the main executable for this project
 *) 



(******************************************************************************)
(*                                                                            *)
(* PART 1: OCaml Basics                                                       *)
(*                                                                            *)
(******************************************************************************)

(* OCaml comments are written using '(*' and '*)' delimiters.  They nest.     *)

(*
 * OCaml is strongly typed and provides a standard suite of base types:
 *   int  -  31 bit integers 0, 1, (-1), etc.
 *   int32 - 32 bit integers 0l, 1l, (-1l), etc.
 *   bool -  'true' and 'false'
 *   unit -  ()   a 'trivial' type that has only one member, namely ()
 *   string - "a string" or "another"
 *   float, char, etc. will also crop up occasionally
 *)
 

(* 
 * OCaml is an expression-oriented, functional language.  This mean you typically
 * don't do imperative updates to variables as you do in languages like C, Java, etc.
 *
 * Instead, you 'name' computations using the keyword 'let':
 *)

let an_int : int = 3
let another_int : int = 3 * 14

(* 
 * The  ': int' part of the 'let' bindings above is an type ascription -- these
 * are optional in OCaml programs (type inference will figure them out), but it
 * is good style to use type ascriptions on the top-level definitions you make
 * because it will improve the error messages that the OCaml typechecker 
 * generates when you make a mistake.
 *
 * For example, it is an error to add a float and an int: 
 *) 
(* Uncomment to get a type error: *)
 (*  let an_error : int = 3 + 1.0*)


(* 
 * 'let' expressions can be nested.  The scope of a let-bound
 * variable is * delimited by the 'in' keyword. See the notes and the
 * Ocaml book Introduction to Objective Caml (IOC) in sakai.  * See also
 * IOC Chapter 3: 
 *)

(* bind z to the value 39 *)
let z : int = 
  let x = 3 in
    let y = x + x in  (* x is in scope here *)
      y * y + x       (* x and y are both in scope here *)
      
(* 
 * Scoping is sometimes easier to see by writing (optional) 'begin'-'end' 
 * delimiters.  This is equivalent to the binding for z above.  
 *)
(* bind z to the value 39 *)
let z : int =
  let x = 3 in begin
    let y = x + x in begin
	y * y + x
    end
  end

(*
 * Here and elsewhere 'begin'-'end' are treated exactly the same as parentheses:
 *)
(* bind z to the value 39 *)
let z : int =
  let x = 3 in (
    let y = x + x in (
      y * y + x
    )
  )

(* Once bound by a 'let', binding between a variable (like 'z' above) and
 * its value (like 39) never changes.  Variables bindings can be shadowed, though.
 * each subsequent definition of 'z' above 'shadows' the previous one.
 *)


(* 
 * The most important type of values in OCaml is the function type.
 * Function types are written like 'int -> int', which is the type of a function
 * that takes an int argument and produces an int result.
 * See IOC Chapter 3.1
 *
 * Functions values are introduced using the 'fun' keyword and the '->' sytnax:
 *  fun (x:int) -> x + x    (* a function that takes an int and doubles it *)
 *
 * Functions are first class -- they can passed around just like integers or
 * other primitive data.
 *)

(* bind the variable 'double' of type 'int -> int' to a function: *)
let double : int -> int = fun  (x:int) -> x + x

(*
 * Functions are called or 'applied' by juxtaposition -- the space ' ' 
 * between a function name and its arguments is the function application site. 
 * Unlike Java or C, no parentheses are needed, exept for grouping and 
 * precedence:
 *)
let doubled_z : int = double z                     (* call double on z  *)
let quadrupled_z : int = double (double z)         (* parens needed for grouping *)
let sextupled_z : int = quadrupled_z + (double z)  

(*
 * Functions with more than one argument have types like:
 * 'int -> int -> int', which is the type of a function that takes an int
 * and returns a function that itself takes an int and returns an int.
 * i.e. 'int -> int -> int' is just 'int -> (int -> int)'
 *)

let mult : int -> int -> int = 
  fun (x:int) -> fun (y:int) -> x * y
let squared_z : int = mult z z   (* multiply z times z *)

(*
 * Because functions like 'mult' above return functions, they can be
 * partially applied: 
 *)
let mult_by_3 : int -> int = mult 3      (* partially apply mult to 3 *)
let mult_by_4 : int -> int = mult 4      (* partially apply mult to 4 *)
let meaning_of_life : int = mult_by_3 14 (* call the partially applied function *)
let excellent_score : int = mult_by_4 25 (* compute 100 *)


(* 
 * The let-fun syntax above is a bit heavy, so OCaml provides syntactic sugar 
 * for abbreviating function definitions, avoiding the need for 'fun' and 
 * redundant-type annotations. 
 *
 * For example, we can write double like this:  
 *)
let double (x:int) : int = x + x      (* this definition shadows the earlier one *)

(* and mult like this: *)
let mult (x:int) (y:int) : int = x * y

(*
 * We still call them in the same way as before:
 *)
let quadrupled_z : int = double (double z)     (* parens needed for grouping *)
let mult_by_3 : int -> int = mult 3            (* partially apply mult to 3 *) 


(* 
 * Note the use of type annotations
 *    let f (arg1:t1) (arg2:t2) ... (argN:tN) : retT = ... 
 * Defines f, a function of type t1 -> t2 -> ... -> tN -> retT
 *)

(*
 * Functions are first-class values, they can be passed to other functions:
 *)
let twice (f:int -> int) (x:int) : int =
  (* f is a function from ints to ints *)
  f (f x)
  
let quadrupled_z_again : int = twice double z  (* pass double to twice *)

(* 
 * OCaml's top-level-loop
 *
 * You can play around with OCaml programs in the 'top-level-loop'.  This is an
 * interactive OCaml session that accepts OCaml expressions on the command line,
 * compiles them, runs the resulting bytecode, and then prints out the result.
 * The top-level-loop is hard to use once programs get big (and are distributed
 * into many source files), but it is a great way to learn the OCaml basics, and 
 * for trying out one-file programs like 'hellocaml.ml'.
 *
 * To start the toplevel loop, just run the 'ocaml' command from the command line.
 * Whether your run it from the command line, you should see:
 *         Objective Caml version 3.12.0
 * #
 *
 * # is the prompt 
 *
 * You can type ocaml expressions at the prompt like this:
 *
 * # 3 + 4;;
 * -: int = 7
 *
 * To quit, use the '#quit' directive:
 *
 * # #quit;;
 *
 * Note that, in the top-level-loop (unlike in a source file) top-level definitions and
 * expressions to be evaluated must be terminated by ';;'.  OCaml will compile 
 * and run the result (in this case computing the int 7).
 *
 * You can load .ml files into the top-level loop via the '#use' directive:
 *
 * # #use "hellocaml.ml";;
 * ...
 *
 * In this case, OCaml behaves as though you entered in all of the contents of 
 * the .ml file at the command prompt (except that ';;' is not needed).  If you
 * try #use "hellocaml.ml";;  you should see output for all of the bindings above
 * and more for the ones later in this file.
 * 
 * Once you '#use' a file, you can then interact with the functions and other 
 * values it defines at the top-level.  This can be very useful when playing around
 * with your programs, debugging, or testing functions.  Note that you have to 
 * either start ocaml from the directory containing the file you want to load, or
 * use the #cd "dirname";; directive to change directories to the right location.
 *
 * Try it now -- load this "hellocaml.ml" file into the OCaml top level.
 * If you succeed, you should see a long list of definitions that this file makes.
 *) 


(* 
 * You can also run your project using the test harness and the 'main.ml' file.
 * Follow the instructions in instructions.txt in the project.
 *
 * The test harness is a useful way to determine how much of the assignment you
 * have completed.  We will be using (a variant of) this test harness to 
 * partially automate grading of your project code.  We will also do some 
 * manual grading of your code, and we may withhold some of the tests cases
 * we run -- you should definitely test your projects thoroughly on your own.
 * Later in the course we will encourage you (and may even require you) to 
 * submit test cases to the class mailing list so that you can help each 
 * other test your implementations.
 *
 * Hint: examining the test cases in gradedtests.ml can help you figure out 
 * the specifications of the code you are supposed to implement.
 *) 


(*******************)
(* Part 1 Problems *)
(*******************)
(* 
 * Complete the following definitions as directed -- you can tell when you get
 * them right because the unit tests specified in part1_tests of the gradedtests.ml
 * file will succeed when you run main with the '--test' flag. 
 *
 * Note that (fun _ -> failwith "unimplemented") is a function that takes any 
 * argument and raises a Failure exception -- you will have to replace these
 * definitions with other function definitions to pass the tests.  
 *)

(* Problem 1-1 *)
(* 
 * The 'pieces' variable below is bound to the wrong value.  Bind it to one that
 * makes the first case of part1_tests "Problem 1" succeed. See the 
 * gradedtests.ml file.  
 *)   
let pieces : int = 10

(*
 * Implement a function cube that takes an int value and produces its cube.
 *)

(*let cube : int -> int = 
	fun(x:int) -> x * x * x
let fourthpower : int -> int = 
   fun (x:int)-> cube x * x;;
*)

let fourthpower : int -> int =
		fun(x:int) -> x*x*x*x;;



(* Problem 1-2 *)
(* Write a function "cents_of" that takes 
 * q - a number of quarters
 * d - a number of dimes
 * n - a number of nickels
 * p - a number of pennies
 * and computes the total value of the coins in cents: *)
let cents_of : int -> int -> int -> int -> int = 
  (*fun (q:int) -> fun(d:int) -> fun(n:int) -> fun(p:int) ->25*q+10*d + 5*n + p;;*)
	fun (q:int) (d:int) (n:int) (p:int) ->25*q+10*d + 5*n + p;;

(* Problem 1-3 *)
(* 
 * Edit the function argument of the "Student-Provided Problem 3" 
 * test in providedtests.ml so that "case1" passes, given the
 * definition below.  You will need to remove the 
 * function body starting with failwith and replace it with something else.
 *)
let prob3_ans : int  = 42

(*
 * Edit the function argument of the "Student-Provided Problem 3"
 * test in providedtests.ml so that "case2" passes, given the
 * definition below: 42 -x
 *)
let prob3_case2 (x:int) : int  = prob3_ans - x

(*
 * Replace 0 with a literal integer argument in the 
 * "Student-Provided Problem 3" test in providedtest.ml so that 
 * "case3" passes, given the definition below: 64
 *)
let prob3_case3 : int =
  let aux = prob3_case2 10 in
  double aux


(******************************************************************************)
(*                                                                            *)
(* PART 2: Tuples, Generics, Pattern Matching                          *)
(*                                                                            *)
(******************************************************************************)


(* See IOC 5.2
 * Tuples are a built-in aggregate datatype that generalizes
 * pairs, triples, etc.   Tuples have types like:
 *     int * bool * string
 * At the value level, tuples are written using ',':
 *)

let triple : int * bool * string = (3, true, "some string")

(* Tuples can nest *)
let pair_of_triples: (int * bool * string) * (int * bool * string) =
  (triple, triple)   

(* 
 * IMPORTANT!!  Be sure to learn this!
 *
 * You can destruct tuples and most other kinds of data by "pattern-matching".
 *
 * Pattern matching is a fundamental concept in OCaml: most
 * non-trivial OCaml types are usually "destructed" or "taken apart" by 
 * pattern matching using the 'match-with' notation.  See IOC Chapter 4.
 *
 * A "pattern" looks like a value, except that it can have 'holes' 
 * marked by _ that indicate irrelevant parts of the pattern, and
 * binders, indicated by variables.  
 *
 * Consider:
 * 
 * begin match exp with
 *   | pat1 -> case1
 *   | pat2 -> case2
 *   ...
 * end
 *
 * This evaluates exp until it reaches a value.  Then, that value is
 * 'matched' against the patterns pat1, pat2, etc. until a match is
 * found.  When the first match is found, the variables appearing in
 * the pattern are bound to the corresponding parts of the value and
 * the case associated with the pattern is executed.  
 *
 * If no match is found, OCaml will raise a Match_failure exception.  
 * If your patterns are not exhaustive -- i.e. they do not cover
 * all of the possible cases, the compiler will issue a (usually very
 * helpful) warning. 
 *
 *)


(*
 * Tuples are "generic" or "polymorphic" -- you can create tuples of any 
 * datatypes.  See IOC 5.1
 *
 * The generic parts of types in OCaml are written using tick ' notation:
 * as shown in the examples below.  What you might write in Java as
 *  List<A>  you would write in OCaml as 'a list -- type parameters
 * are written in prefix.
 * Similarly, Map<A,B> would be written as ('a,'b) map -- multiple
 * type parameters use a 'tuple' notation.
 *)

(* 
 * Note:  
 * 'a is pronounced "tick a" or "alpha". 
 * 'b is pronounced "tick b" or "beta".
 * 'c is pronounced "tick c" or "gamma".
 &
 * Generic types are typically written in texts using Greek letters -- this is
 * an ML tradition that dates back to its use for developing formal logics 
 * and proof systems.
 *)

(* Example pattern matching against tuples: *)
let first_of_three (t:'a * 'b * 'c) : 'a =  (* t is a generic triple *)
  begin match t with
    | (x, _, _) -> x
  end
  
let t1 : int = first_of_three triple    (* binds t1 to 3 *)  
  
let second_of_three (t:'a * 'b * 'c) : 'b =
  begin match t with
    | (_, x, _) -> x
  end 
  
let t2 : bool = second_of_three triple  (* binds t2 to true *)
 

(* 
 * This generic function takes an arbitrary input, x, and 
 * returns a pair both of whose components are the given input:
 *)
let pair_up (x:'a) : ('a * 'a) = (x, x)


(*******************)
(* Part 2 Problems *)
(*******************)

(* 
 * Problem 2-1 
 *
 * Complete the definition of third_of_three; be sure to give it 
 * the correct type signature (we will grade that part manually):
 *)
let third_of_three (t:'a * 'b *'c) : 'c =
 begin match t with
    | (_, _, x) -> x
  end 

(*
 * Problem 2-2
 *
 * Implement a function compose_pair of the given type that takes 
 * a pair of functions and composes them in sequence.  Note that
 * you must return a function.  See the test cases in gradedtests.ml
 * for examples of its use.
 *)


let compose_pair (p:(('b -> 'c) * ('a -> 'b))) : 'a -> 'c =
		begin match p with
			| (bc, ab) -> (fun(final) -> bc ( ab final)) (** final is the input parameter ('a) for the final function. ab final means that ab takes final as it's first param and resolves to 'b (from it's function). bc means it takes the b' from the previously resolved entry and then plugs it in for IT's first param and solves for 'c. That is what is outputted *)
			|_ -> failwith "Unable to compose pair. Check your inputs and see if the types correspond correctly please."
		end


(*
 * Problem 2-3
 *
 * Implement a function apply_pair of the given type that takes 
 * a pair of functions and applies them according to the types.  Note that
 * you must return a function.  
 *)
(* so what to do:*)
(* 1) nee sdfd to break down (deconstruct the tuple) *)
(* 2) reconstruct the tuple backwards*)
(* 3) use compose pair *)

let apply_pair (p:(('a -> 'b) * ('b -> 'c))) : 'a -> 'c = 
 begin match p with 
  | (ab, bc) -> compose_pair (bc, ab)
  |_ -> failwith "Unable to apply pair. Check your inputs and see if the types correspond correctly"
 end


(******************************************************************************)
(*                                                                            *)
(* PART 3: Lists and Recursion                                                *)
(*                                                                            *)
(******************************************************************************)

(*
 * OCaml has a build-in datatype of generic lists: See IOC 5.3
 *
 * [] is the nil list
 * if  
 *   h   is a head-value of type t
 *   tl  is a list of elements of type t
 * then
 *  h::tl  is a list with h as the head and tl as the tail
 *)

let list1 : int list = 3::2::1::[]

(*
 * Lists can also be written using the [v1;v2;v3] notation:
 *)

let list1' = [3;2;1]     (* this is equivalent to list1 *)

(*
 * Lists are homogeneous -- they hold values of only one type:
 *)
(* Uncomment to get a type error; recomment to compile:
let bad_list = [1;"hello";true]
*)


(*
 * As usual in OCaml, we use pattern matching to destruct lists.
 * For example, to determine whether a list has length 0 we need to 
 * do a case-analysis (via pattern matching) to see whether it is nil
 * or is non-empty.  The following function takes a list l and
 * determines whether l is empty: 
 *)
let is_empty (l:'a list) : bool =
  begin match l with
    | []    -> true         (* nil case -- return true *)
    | h::tl -> false        (* non-nil case -- return false *)
  end
  
let ans1: bool = is_empty []     (* evaluates to true *)
let ans2: bool = is_empty list1  (* evaluates to false *)


(*
 * Lists are an example of a "disjoint union" data type -- they are either
 * empty [] or have some head value consed on to a tail h::tl.  
 * OCaml provides 
 * programmers with mechanisms to define their own generic disjoint union
 * and potentially recursive types using the 'type' keyword.
 *)

(*
 * A user-defined generic type ('a mylist) can be defined within OCaml by:
 *)

type 'a mylist =
  | Nil                         (* equivalent to [] *)
  | Cons of 'a * ('a mylist)    (* Cons(h,tl) is equivalent to h::tl *) 

(* 
 * We build a mylist by using its 'constructors' (specified in the branches)
 * For example, compare mylist1 below to list1 defined by built-in lists
 * above:
 *)
let mylist1 : int mylist = Cons (3, Cons (2, Cons (1, Nil)))  

(* 
 * Pattern matching against a user-defined datatype works the same as for
 * a built-in type.  The cases we need to consider in a pattern are given by
 * the cases of the type definition.  For example, to write the is_empty
 * function for mylist we do the following.  Compare it with is_empty:
 *)
let is_mylist_empty (l:'a mylist) : bool =
  begin match l with
    | Nil          -> true
    | Cons (h, tl) -> false
  end


(* 
 * Recursion:  The built in list type and the mylist type we defined above
 * are recursive -- they are defined in terms of themselves.  To implement
 * useful functions over such datatypes, we often need to use recursion.
 * 
 * Recursive functions in OCaml use the 'rec' keyword -- inside the body
 * of a recursive function, you can call the function being defined.  As usual
 * you must be careful not to introduce infinite loops.
 *
 * Recursion plus pattern matching is a very powerful combination.  Here is
 * a recursive function that sums the elements of an integer list:
 *)

let rec sum (l:int list) : int =  (* note the 'rec' keyword! *)
  begin match l with
    | []      -> 0
    | (x::xs) -> x + (sum xs)   (* note the recursive call to sum *)
  end
  
let sum_ans1 : int = sum [1;2;3]     (* evaluates to 6 *)


(*
 * Here is a function that takes a list and determines whether it is 
 * sorted and contains no duplicates according to the built-in 
 * generic inequality test <
 *
 * Note that it uses nested pattern matching to name the
 * first two elements of the list in the third case of the match:
 *)
let rec is_sorted (l:'a list) : bool =
  begin match l with
    | []    -> true    
    | _::[] -> true    
    | h1::h2::tl ->    
        h1 < h2 && (is_sorted (h2::tl))  
  end 

let is_sorted_ans1 : bool = is_sorted [1;2;3]    (* true *)
let is_sorted_ans2 : bool = is_sorted [1;3;2]    (* false *)


(* 
 * The List library
 * (see http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html)
 * implements many useful functions for list maniuplation.  You will
 * recreate some of them in the exercises below.
 * 
 * Here is map, one of the most useful:
 *)
let rec map (f:'a -> 'b) (l:'a list) : 'b list =
  begin match l with
    | [] -> []
    | (h::tl) -> (f h)::(map f tl)
  end
  
let map_ans1 : int list  = map double [1;2;3]    (* evaluates to [2;4;6]  *)     
let map_ans2 : (int * int) list = 
  map pair_up [1;2;3]    (* evaluates to [(1,1);(2,2);(3,3)] *) 

(* 
 * The mylist type is isomorphic to the built-in lists.  
 * The recursive function below converts a mylist to a built-in list.  
 *)

let rec mylist_to_list (l:'a mylist) : 'a list =
  begin match l with
    | Nil -> []
    | Cons(h,tl) -> h :: (mylist_to_list tl)
  end

  
    
(*******************)
(* Part 3 Problems *)
(*******************)
  
(*
 * Problem 3-1
 *
 * Implement list_to_mylist with the type signature below; this is 
 * the inverse of the mylist_to_list function given above.
 *)
let rec list_to_mylist (l:'a list) : 'a mylist =
	  begin match l with
    | [] -> Nil
    | h::tl -> Cons(h, list_to_mylist tl)
  end


(*
 * Problem 3-2
 * 
 * Implement the library function append, which takes two lists
 * (of the same times) and concatenates them.  Do not use
 * the library function or the built-in short-hand '@'.
 *
 * (append [1;2;3] [4;5]) should evaluate to [1;2;3;4;5]
 * (append [] []) should evaluate to []
 *
 * Note that OCaml provides the infix fuction @ as an alternate
 * way of writing append.  So   (List.append [1;2] [3]) is the same as
 * ([1;2] @ [3]).
 *) 
let rec append (l1:'a list) (l2:'a list) : 'a list =
	begin match l1 with
	| [] -> l2
	| h::tl -> h::(append tl l2)
	end
  
(*
 * Problem 3-3
 * 
 * Implement the library function rev, which reverses a list. In 
 * this solution, you might want to call append.  Do not use
 * the library function.
 *)
let rec rev (l:'a list) : 'a list =
	begin match l with
	| [] -> []
	| h::tl -> append (rev tl) (h::[])
 	end

(*
 * Problem 3-4
 *
 * Read IOC 5.4 about "tail recursion" and implement a tail recursive
 * version of rev.  Note that you will need a helper function that
 * takes an extra parameter -- it should be defined using a local
 * let definition.  The rev_t function itself should not be recursive.
 *
 * Tail recursion is imporant to efficiency -- OCaml will compile
 * a tail recursive function to a simple loop.
 *)
let rec loop (accum: 'a list) (l: 'a list) =
	begin match l with
		| [] -> accum
		| h::tl -> loop (h::accum) tl
	end

let rev_t (l: 'a list) : 'a list =
	loop [] l


(*
 * Problem 3-5
 *
 * Implement insert, a function that, given an element x
 * and a sorted list l  (i.e. one for which is_sorted returns true)
 * returns the list obtained by inserting x into the list l at
 * the proper location.  Note that if x is already in the list
 * then insert should just return the original list.
 *
 * You will need to use the if-then-else expression (see IOC 2.2).
 * Remember that OCaml is expression-oriented; "if t then e1 else e2" evaluates
 * to either the value computed by e1 or the value computed by e2
 * depending on whether t evaluates to true or false.
 *)

let rec insert (x:'a) (l:'a list) : 'a list =
	begin match l with 
	| [] -> [x]
	| h::tl -> 
			if x = h then h::tl
			else
				if x < h then x::h::tl
				else h::insert x tl
	end
  
  
(*
 * Problem 3-6
 *
 * Implement union, a function that takes two sorted lists and
 * returns the sorted list containing all of the elements from
 * both of the two input lists.  Hint: you might want to use the 
 * insert function that you just defined.
 *)
let rec union (l1:'a list) (l2:'a list) : 'a list =
 begin match l1 with
	|	[] -> l2
	| h::tl -> union tl (insert h l2)
 end

(*
 * Problem 3-7
 *
 * Implement merge sort, a function that takes a single list 
 * and returns a sorted list. You may want to use the union function
 * defined above. You may want to define  auxillary functions 
 * to obtain the first half of the list and second half of the list.
 * You may also want to pay attention to case where there is only
 * one element while dividing it into two lists.
 *
 *)
let rec msort (l: 'a list): 'a list  = 
  failwith "msort unimplemented"
                              
                                                  
(******************************************************************************)
(*                                                                            *)
(* PART 3: Expression Trees and Interpreters                                  *)
(*                                                                            *)
(******************************************************************************)

(* Terminology: "Object" level vs. "Meta" level
 *
 * When we implement a compiler, we use code in one programming language to 
 * implement the features of another language.  The language we are implementing
 * is called the "object language" -- it is the "object of study".  In contrast,
 * the language we use to implement the object language in is called the
 * "meta language" -- it is used to "talk about" the object language.  In this 
 * course OCaml will usually be the "meta language" (indeed the 'm' and 'l' in
 * OCaml come from ML - meta language).
 *
 * We will implement several different object languages in this course.  Within
 * the metalanguage, we use ordinary datatypes: lists, tuples, trees, unions, etc.
 * to represent the features of the object language.  A compiler is just a 
 * function that translates one representation of an object language into 
 * another (usually while preserving some notion of a program's 'behavior').
 *
 * The representation of a language is often best done using an "abstract syntax
 * tree" -- a representation that hides concrete details about parsing, 
 * infix syntax, syntactic sugar, etc.
 *)

(*
 * In this course we will be working with many kinds of abstract syntax trees.
 * Such trees are a convenient way of representing the syntax of a programming
 * language.  In OCaml, we build such datatypes using the technology we have
 * already seen above.  
 *
 * Here is a simple datatype of arithemetic expressions.  To make things slightly
 * more interesting, and to familiarize you with another important library, these
 * expressions trees denote 32-bit integers.  See the Int32 module of the OCaml
 * standard library.  We have to use Int32.add to work with these kinds of numbers.
 * (The OCaml notation Int32.add accesses the 'add' function defined in the Int32
 * library -- you can use similar notation for List.map, etc.
 *) 


(* An object language: a simple datatype of 32-bit integer expressions *)
type exp =
  | Var of string         (* a string representing an object-language variable *)
  | Const of int32        (* a constant int32 value -- use the 'l' suffix *)
  | Add of exp * exp      (* sum of two expressions *)
  | Mult of exp * exp     (* product of two expressions *)
  | Neg of exp            (* neGation of an expression *)


(* 
 * An object-language arithmetic expression whose concrete (ASCII) syntax is
 * "2 * 3" could be represented like this: 
 *)
let e1 : exp = Mult(Const 2l, Const 3l)   (* "2 * 3" *)

(*
 * If the object-level expression contains variables, we represent them as
 * strings, like this:
 *)
let e2 : exp = Add(Var "x", Const 1l)    (* "x + 1" *)

(*
 * Here is a more complex expression that involves multiple variables:
 *)
let e3 : exp = Mult(Var "y", Mult(e2, Neg e2))     (* "y * ((x+1) * -(x+1))" *)

(*
 *  Problem 4-1
 *
 * Implement vars_of -- a function that, given en expression e returns
 * a list containing exactly the strings representing variables appearing
 * in the expression.  The result should be a set -- that is, it should
 * contain no duplicates and be sorted (according to is_sorted). 
 * 
 * For example:
 *   vars_of e1 should produce []
 *   vars_of e2 should produce ["x"]
 *   vars_of e3 should produce ["x";"y"]
 *
 * Hint: you need to pattern match on the exp e.
 * Hint: you probably want to use the 'union' function you wrote for Problem 3-5.
 *)
let rec vars_of (e:exp) : string list =
failwith "vars_of unimplemented"


(*
 * How should we interpret (i.e. give meaning to) an expression?
 *
 *  Some examples:
 *    Add(Const 3l, Const 5l)    should have the interpretation 8l
 *    Mult(Const 2l, (Add(Const 3l, Const 5l)))   denotes 16l
 *
 * What about Add(Var "x", Const 1l)?
 * What should we do with (Var "x")?  
 *
 * Each expression denotes an int32 value, but since it can contain 
 * variables, we need an "evaluation context" that maps variable 
 * names to int32 values.  One (not particularly efficient) simple
 * way to represent a context is as an "association list" that
 * is just a list of (string * int32) pairs: 
 *)
                    
type ctxt = (string * int32) list

(*
 * Here are some example evalution contexts:
 *)
let ctxt1 : ctxt = [("x", 3l)]             (* maps "x" to 3l *)
let ctxt2 : ctxt = [("x", 2l); ("y", 7l)]  (* maps "x" to 2l, "y" to 7l *)

(*
 * When interpreting an expression, we need to look up the value
 * associated with a variable in an evaluation context.  
 *  For example:
 *     lookup "x" ctxt1    should yield 3l
 *     lookup "x" ctxt2    should yield 2l
 *     lookup "y" cxtx2    should yield 7l
 *
 * What if we lookup a variable that doesn't appear in the 
 * context?  In that case we raise an exception.  OCaml provides
 * user-defined and some pre-defined exceptions.  For container-like
 * structures (like ctxt), the Not_found exception is appropriate.
 * 
 * See IOC 9.2.1  (and 9.2 about exception handlers)
 * To throw an exception Exception just use:
 *         raise Exception
 * For example:
 *     lookup "y" ctxt1    should raise Not_found
 *
 * There is one other case to consider -- if the context has two
 * bindings for a variable, the one closer to the head of the 
 * list should take precedence.  
 *  For example:
 *  lookup "x" [("x", 1l);("x", 2l)]    should yield 1l (not 2l)
 *)

(*
 * Problem 4-2
 *
 * Implement the lookup function with the signature given below.
 * It should find the int32 value associated with a given string
 * in the ctxt c.  If there is not such value, it should 
 * raise the Not_found exception 
 *)
let rec lookup (x:string) (c:ctxt) : int32 =
failwith "unimplemented"



(* 
 * Problem 4-3
 *
 * Finally we can write an interpreter for exp's.  This is just
 * a function 'interpret' that, given an evaluation context c
 * and an expression e, computes an int32 value corresponding
 * to the expression.  If the expression mentions a variable
 * that does not appear in the context, interpret should
 * throw the Not_found exception (note that this amounts to 
 * trying to lookup the variable and *not* catching any resulting
 * Not_found exception.)
 *
 * For example:
 *    interpret ctxt1 e1    should yield 6l
 *    interpret ctxt1 e2    should yield 4l
 *    interpret ctxt1 e3    should raise a Not_found exception
 *
 * Note that the interpreter should recursively call itself to 
 * obtain the int32 values of subexpressions.  You will need to use
 * the Int32 library to implement addition and multiplication.
 *
 * You should test your interpeter on more examples than just 
 * those provided in gradedtests.ml.
 *)        

let rec interpret (c:ctxt) (e:exp) : int32 =
  failwith "unimplemented"


(*
 * Problem 4-4
 *
 * Now, write an optimizer for expressions.  An optimizer is 
 * just a function that tries to reduce the number of operations by doing some
 * work "at compile time" rather than at "run time".    
 *
 * For example:
 *    optimize (Add(Const 3l, Const 4l))     might produce (Const 7l)
 *    optimize (Mult(Const 0l, Var "x"))     might produce (Const 0l)
 *
 * No matter what optimizations your function performs, it should 
 * not change the value computed by the expression.  That is, for 
 * every context c and exp e, it should be the case that:
 *     (interpret c e)  =  (interpret c (optimize e))
 *
 * Note that it is not always possible to reduce the size of an
 * expression (i.e. (Var "x")  is already "optimal"). You will also have
 * optimize sub-expressions before applying further optimizations -- this
 * means that you will need to use nested match expressions.
 *
 * Here is a (slightly) more complex example:
 *  optimize (Add(Const 3l, Mult(Const 0l, Var "x")))    yields (Const 3l)
 *
 * Note that your optimizer won't be complete (unless you work *very* hard)
 *   for example, 
 *   Add(Var "x", Neg(Add(Var "x", Neg(Const 1l))))      "x - (x - 1)"
 * is equivalent to Const 1l, but we do not expect your optimizer to
 * discover that.
 *
 * You can get full credit for this Problem if your optimizer 
 *   (1) doesn't change the meaning of an expression in any context
 *       that provides bindings for all of the expression's variables
 *   (2) recursively reduces the size of the expression in "obvious" cases 
 *         -- adding 0, multiplying by 0 or 1, constants, etc.
 *)   

let rec optimize (e:exp) : exp =
failwith "optimize unimplemented"  
  

(*
 * The interpreter for the expression language above is simple, but
 * the language itself is fairly high-level in the sense that we
 * are using many meta-language (OCaml) features to define the behavior 
 * of the object language.  For example, the natural way of defining
 * the 'interpret' function as a recursive OCaml function means that
 * we rely on OCaml's function calls and its order of evaluation.
 *
 * Let's look at a closely-related but "lower-level" language for
 * defining arithmetic expressions.  
 *
 * Unlike the language 'exp' defined above, which has nested sub
 * expressions, a program in the new language will simply be a list 
 * of instructions that specify a sequence of actions to carry out.
 * Also unlike the 'exp' language, which uses OCaml's recursive functions
 * and hence a (meta-level) call stack to keep track of the order
 * in which subexpressions are processed, the new language will 
 * explicitly manipulate a stack of Int32 values.
 *
 * (ASIDE: historically, several companies actually built calculators 
 *  that used this "reverse polish notation" programming language to
 *  express their computations.  Google for it to find out more...)
 *)

(* 
 * The instructions of the new language are defined as follows. 
 * Note that the instructions IMul, IAdd, and INeg pop their
 * input values from the stack and push their results onto the
 * stack.
 *)
type insn =
  | IPushC of int32   (* push an int32 constant onto the stack *)
  | IPushV of string  (* push (lookup string ctxt)  onto the stack *)
  | IMul              (* multiply the top two values on the stack *)
  | IAdd              (* add the top two values on the stack *)
  | INeg              (* negate the top value on the stack *)

(*
 * A program is just a list of instructions.
 *)
type program = insn list

(*
 * The stack is represented as a list of int32 values, where the
 * head of the list is the top of the stack.
 *)
type stack = int32 list

(*
 * The operational semantics (i.e. behavior) of this new language
 * can easily be specified by saying how one instruction step is
 * performed.  Each step takes a stack and returns the new stack
 * resulting from carrying out the computation.
 *
 * Note that this function is not recursive, and also that it might
 * raise an exception if the stack doesn't have enough entries.  As
 * with the 'exp' language interpreter, we use a context to lookup the
 * value of variables.  
 *)
 
let step (c:ctxt) (s:stack) (i:insn) : stack =
  begin match (i, s) with
    | (IPushC n, _) -> n::s             (* push n onto the stack *)
    | (IPushV x, _) -> (lookup x c)::s  (* lookup x, push it *)
    | (IMul, v1::v2::s) -> (Int32.mul v1 v2)::s
    | (IAdd, v1::v2::s) -> (Int32.add v1 v2)::s
    | (INeg, v1::s)     -> (Int32.neg v1)::s
    | _ -> failwith "Stack had too few values"
  end

(* 
 * To define how a program executes, we simply iterate over the
 * instructions, threading the stack through.
 *)
let rec execute (c:ctxt) (s:stack) (p:program) : stack =
  begin match p with
    | []      -> s  (* no more instructions to execute *)
    | i::cont -> execute c (step c s i) cont 
  end
 
(* 
 * If you want to be slick, you can write the above equivalently 
 * using List.fold_left
 *)
let execute' (c:ctxt) = List.fold_left (step c)

(*
 * Let us define 'answer' to mean the sole value of a stack
 * containing only one element.  This makes sense since, if
 * a program left the stack empty, there wouldn't be any 
 * int32 value computed and if there is more than one value
 * on the stack, that means that the program 'stopped' too
 * early.
 *)
let answer (s:stack) : int32 =
  begin match s with
    | [n] -> n
    | _ -> failwith "no answer"
  end

(*
 * Finally, we can 'run' a program in a given context
 * by executing it starting from the empty stack and 
 * returning the answer that the program computes. 
 *
 *)
let run (c:ctxt) (p:program) : int32 = answer (execute c [] p)

(*
 * As an example program in this stack language, consider the 
 * following program that runs to produce the answer 6.
 *
 * Compare this program to the 'exp' program called e1 above.
 * They both compute the value 2 * 3.
 *)
let p1 = [IPushC 2l; IPushC 3l; IMul]
let ans1 = run [] p1


(*
 * Problem 5
 *
 * Implement a function 'compile' that takes a program in the 
 * 'exp' language and translates it to an equivalent program in
 * the 'stack' language.  
 *
 * For example, (compile e1) should yield the program p1 given
 * above.
 *  
 * Correctness means that: 
 * For all expressions e and contexts c and int32 values v
 *    (interpret c e) = v      if and only if
 *    (run c (compile e)) = v
 *
 * Hints: 
 *  - Think about how to define your compiler compositionally so
 *    that you build up the sequence of instructions for a 
 *    compound expression like Add(e1, e2) from the programs that
 *    compute e1 and e2.
 *
 *  - You may want to use the append function (or the built in @)
 *    function to glue together two programs.
 *)
let rec compile (e:exp) : program =
 failwith "compile unimplemented"  



(************)
(* Epilogue *)
(************)

(* 
 * Whew!  That was a whirl-wind tour of OCaml.  There are still quite a few
 * features we haven't seen -- we'll mention them in the next project and
 * later as needed.  However, even with this little bit of OCaml and a few
 * basic ideas you've probably seen in other languages, you can already go
 * quite far.  
 *
 * Take a quick read through assert.ml -- this is a small libary for 
 * writing unit tests that we'll use for grading throughout this course.
 * It makes extensive use of unions, lists, strings, ints, and a few
 * List and Printf library functions, but otherwise it should be fairly 
 * readable to you already...
 *)  

