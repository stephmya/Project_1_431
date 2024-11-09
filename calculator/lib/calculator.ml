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

(* Evaluate expression using Owl Matrices, supporting sin cos tan functions *)
let evaluate_expression expr =
  try
    (* Check for sin and cos functions *)
    let func_re = Str.regexp "\\(sin\\|cos\\|tan\\)(\\([0-9.]+\\))" in
    if Str.string_match func_re expr 0 then (
      let func = Str.matched_group 1 expr in
      let angle = Str.matched_group 2 expr |> float_of_string in
      Printf.printf "Matched function: %s, angle: %f\n" func angle;
      let radians = Owl.Mat.of_array [|angle *. (Float.pi /. 180.)|] 1 1 in (* Convert to radians *)

      (* Calculate sine or cosine *)
      let result =
        match func with
        | "sin" -> Owl.Mat.sin radians
        | "cos" -> Owl.Mat.cos radians
        | "tan" -> Owl.Mat.tan radians
        | _ -> failwith "Unknown trigonometric function"
      in

      (* Extract and return the result as a string *)
      let result_value = Owl.Mat.get result 0 0 in
      Printf.printf "Calculated result: %f\n" result_value;
      string_of_float result_value
    )
    (* Check for basic arithmetic expressions *)
    else
      let re = Str.regexp "\\([0-9]+\\)\\([-+*/]\\)\\([0-9]+\\)" in
      if Str.string_match re expr 0 then (
        let operand1 = Str.matched_group 1 expr |> float_of_string in
        let operator = Str.matched_group 2 expr in
        let operand2 = Str.matched_group 3 expr |> float_of_string in
        Printf.printf "Parsed operand1: %f, operator: %s, operand2: %f\n" operand1 operator operand2;

        (* Convert scalars to 1x1 matrices *)
        let mat1 = Owl.Mat.of_array [|operand1|] 1 1 in
        let mat2 = Owl.Mat.of_array [|operand2|] 1 1 in

        (* Perform matrix operation *)
        let result = matrix_operations mat1 mat2 operator in
        let result_value = Owl.Mat.get result 0 0 in
        Printf.printf "Calculated result: %f\n" result_value;
        string_of_float result_value
      )
      else
        "Invalid expression: Unable to parse the input expression."
  with
  | Failure msg -> "Error: " ^ msg
  | _ -> "An unknown error occurred"
