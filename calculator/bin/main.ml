open Opium
module Calculator = Calculator_lib.Calculator
module Layout = Calculator_lib.Layout
module Css = Calculator_lib.Css

let handle_index _ =
  let display = "" in
  let response_html = Layout.calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

let handle_calculation req =
  let open Lwt.Syntax in
  let* form = Request.to_urlencoded req in
  let display =
    match List.assoc_opt "display" form with
    | Some [current_expr] -> Calculator.evaluate_expression current_expr
    | _ -> "Error: Invalid input"
  in
  let response_html = Layout.calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

let () =
  App.empty
  |> App.get "/" handle_index
  |> App.post "/calculate" handle_calculation
  |> App.get "/styles.css" Css.handle_stylesheet
  |> App.port 3000
  |> App.run_command
