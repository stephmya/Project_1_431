(* Define a function that performs addition on a list of numbers *)
let add numbers =
  List.fold_left (+) 0 numbers

(* Example usage *)
let () =
  let sum = add [1; 2; 3; 4; 5] in
  Printf.printf "The sum is: %d\n" sum

  

  let multiply numbers =
  List.fold_left ( * ) 1 numbers

(* Example usage *)
let () =
  let product = multiply [1; 2; 3; 4; 5] in
  Printf.printf "The product is: %d\n" product