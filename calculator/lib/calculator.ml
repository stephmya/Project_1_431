[@@@warning "-33"]

open Owl
open Owl.Mat
open Str

(* Matrix operations based on operator *)
let matrix_operations mat1 mat2 operator =
  let is_zero_matrix mat =
    let zero_matrix = Owl.Mat.create (Owl.Mat.row_num mat) (Owl.Mat.col_num mat) 0. in
    Owl.Mat.equal mat zero_matrix
  in
  match operator with
  | "+" -> Owl.Mat.add mat1 mat2
  | "-" -> Owl.Mat.sub mat1 mat2
  | "*" -> Owl.Mat.dot mat1 mat2
  | "/" -> 
      if is_zero_matrix mat2 then failwith "Division by zero"
      else Owl.Mat.div mat1 mat2
  | _ -> failwith "Unknown operator"

(* Evaluate expression with matrices *)
let evaluate_expression expr =
  try
    let re = Str.regexp "\\([0-9.]+\\)\\([+\\-*/]\\)\\([0-9.]+\\)" in
    if Str.string_match re expr 0 then
      let operand1 = Str.matched_group 1 expr |> float_of_string in
      let operator = Str.matched_group 2 expr in
      let operand2 = Str.matched_group 3 expr |> float_of_string in
      let mat1 = Owl.Mat.of_array [|operand1|] 1 1 in
      let mat2 = Owl.Mat.of_array [|operand2|] 1 1 in
      let result = matrix_operations mat1 mat2 operator in
      Owl.Mat.to_array result
      |> Array.fold_left (fun acc x -> acc ^ " " ^ string_of_float x) ""
    else
      "Invalid expression"
  with
  | Failure msg -> msg
  | _ -> "Error"
