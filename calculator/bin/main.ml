(* main.ml *)
open Opium
open Owl.Maths  (* Import Owl for mathematical functions *)

(* Inline CSS as a string *)
let inline_css = "
body {
  font-family: Arial, sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  margin: 0;
  background-color: #f0f0f0;
}

.calculator {
  display: grid;
  grid-template-columns: repeat(4, 80px); /* 4 columns */
  grid-template-rows: 100px repeat(5, 80px); /* Display + 5 rows for buttons */
  gap: 10px;
  padding: 20px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
}

.display {
  grid-column: span 4;
  padding: 15px;
  font-size: 24px;
  text-align: right;
  border: 2px solid #ddd;
  border-radius: 5px;
  background-color: #eaeaea;
}

button {
  font-size: 20px;
  cursor: pointer;
  border: 1px solid #ddd;
  border-radius: 5px;
  background-color: #f9f9f9;
  transition: background-color 0.2s;
}

button:hover {
  background-color: #e0e0e0;
}

.clear {
  background-color: #ff6666;
  color: white;
}

.operator {
  background-color: #4CAF50;
  color: white;
}

.equals {
  background-color: #2196F3;
  color: white;
  grid-column: span 2;
}

.function {
  background-color: #FFA500;
  color: white;
}
"


(* Function to evaluate expressions *)
let evaluate_expression expr =
  try
    let re = Str.regexp "\\([0-9.]+\\)\\([+\\-*/]\\)\\([0-9.]+\\)" in
    if Str.string_match re expr 0 then
      let operand1 = Str.matched_group 1 expr |> float_of_string in
      let operator = Str.matched_group 2 expr in
      let operand2 = Str.matched_group 3 expr |> float_of_string in
      let result =
        match operator with
        | "+" -> operand1 +. operand2
        | "-" -> operand1 -. operand2
        | "*" -> operand1 *. operand2
        | "/" -> if operand2 = 0. then failwith "Division by zero" else operand1 /. operand2
        | _ -> failwith "Unknown operator"
      in
      Printf.sprintf "%.2f" result
    else if String.sub expr 0 4 = "sin(" then
      let operand = String.sub expr 4 (String.length expr - 5) |> float_of_string in
      Printf.sprintf "%.2f" (sin operand)
    else if String.sub expr 0 4 = "cos(" then
      let operand = String.sub expr 4 (String.length expr - 5) |> float_of_string in
      Printf.sprintf "%.2f" (cos operand)
    else if String.sub expr 0 4 = "exp(" then
      let operand = String.sub expr 4 (String.length expr - 5) |> float_of_string in
      Printf.sprintf "%.2f" (exp operand)
    else if String.sub expr 0 4 = "log(" then
      let operand = String.sub expr 4 (String.length expr - 5) |> float_of_string in
      if operand <= 0. then "Error: Logarithm undefined" else Printf.sprintf "%.2f" (log operand)
    else
      "Error: Unsupported expression format"
  with
  | Failure _ -> "Error: Invalid input"

  let calculator_page display =
    let open Tyxml.Html in
    html
      (head (title (txt "OCaml Calculator")) [
         style [txt inline_css];
         script (txt "
           function appendValue(value) {
             const display = document.getElementById('display');
             if (value === 'C') {
               display.value = '';
             } else if (value === '=') {
               document.getElementById('calcForm').submit();
             } else {
               display.value += value;
             }
           }
         ")
      ])
      (body [
        div ~a:[a_class ["calculator"]] [
          form ~a:[a_id "calcForm"; a_action "/calculate"; a_method `Post; a_class ["buttons"]] [
            
            (* Display *)
            input ~a:[a_id "display"; a_class ["display"]; a_name "display"; a_value display; a_readonly ()] ();
  
            (* Buttons in grid order *)
            button ~a:[a_button_type `Button; a_onclick "appendValue('C')"; a_class ["clear"]] [txt "C"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('/')"; a_class ["operator"]] [Unsafe.data "&divide;"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('*')"; a_class ["operator"]] [Unsafe.data "&times;"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('-')"; a_class ["operator"]] [txt "-"];
  
            button ~a:[a_button_type `Button; a_onclick "appendValue('7')"; a_class ["number"]] [txt "7"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('8')"; a_class ["number"]] [txt "8"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('9')"; a_class ["number"]] [txt "9"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('+')"; a_class ["operator"]] [txt "+"];
  
            button ~a:[a_button_type `Button; a_onclick "appendValue('4')"; a_class ["number"]] [txt "4"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('5')"; a_class ["number"]] [txt "5"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('6')"; a_class ["number"]] [txt "6"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('=')"; a_class ["equals"]] [txt "="];
  
            button ~a:[a_button_type `Button; a_onclick "appendValue('1')"; a_class ["number"]] [txt "1"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('2')"; a_class ["number"]] [txt "2"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('3')"; a_class ["number"]] [txt "3"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('sin(')"; a_class ["function"]] [txt "sin"];
  
            button ~a:[a_button_type `Button; a_onclick "appendValue('0')"; a_class ["number"]] [txt "0"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('.')"; a_class ["decimal"]] [txt "."];
            button ~a:[a_button_type `Button; a_onclick "appendValue('(')"; a_class ["parentheses"]] [txt "("];
            button ~a:[a_button_type `Button; a_onclick "appendValue(')')"; a_class ["parentheses"]] [txt ")"];
            button ~a:[a_button_type `Button; a_onclick "appendValue('cos(')"; a_class ["function"]] [txt "cos"];
          ]
        ]
      ])
    |> Format.asprintf "%a" (Tyxml.Html.pp ())
  
  
let handle_index _ =
  let display = "" in
  let response_html = calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

let handle_calculation req =
  let open Lwt.Syntax in
  let* form = Request.to_urlencoded req in
  let display =
    match List.assoc_opt "display" form with
    | Some [current_expr] -> evaluate_expression current_expr
    | _ -> "Error: Invalid input"
  in
  let response_html = calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

let () =
  App.empty
  |> App.get "/" handle_index
  |> App.post "/calculate" handle_calculation
  |> App.port 3000
  |> App.run_command
