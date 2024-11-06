open Opium
module Calculator = Calculator_lib.Calculator
module Layout = Calculator_lib.Layout
module Css = Calculator_lib.Css

(* Handler for the index page *)
let handle_index _ =
  let display = "" in
  let response_html = Layout.calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

(* Handler for the calculation form submission *)
let handle_calculation req =
  let open Lwt.Syntax in
  (* Extract form data from the request *)
  let* form = Request.to_urlencoded req in
  (* Evaluate the expression from the form data *)
  let display =
    match List.assoc_opt "display" form with
    | Some [current_expr] -> Calculator.evaluate_expression current_expr
    | _ -> "Error: Invalid input"
  in
  (* Generate the response HTML with the evaluated result *)
  let response_html = Layout.calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

(* Main entry point of the application *)
let () =
  App.empty
  |> App.get "/" handle_index  (* Route for the index page *)
  |> App.post "/calculate" handle_calculation  (* Route for form submission *)
  |> App.get "../styles.css" Css.handle_stylesheet  (* Route for CSS stylesheet *)
  |> App.port 3000  (* Set the port to 3000 *)
  |> App.run_command  (* Run the application *)
