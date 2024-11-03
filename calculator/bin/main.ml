(* main.ml *)
open Opium
open Lwt.Infix  (* Include Lwt.Infix to access the >|= operator *)

let calculator_page display =
  (* HTML for the calculator interface *)
  let open Tyxml.Html in
  html
    (head (title (txt "OCaml Calculator")) [link ~rel:[`Stylesheet] ~href:"/styles.css" ()])
    (body [
      div ~a:[a_class ["calculator"]] [
        input ~a:[a_class ["display"]; a_value display; a_readonly ()] ();
        form ~a:[a_action "/calculate"; a_method `Post; a_class ["buttons"]] [
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["clear"]] [txt "C"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["operator"]] [Unsafe.data "&divide;"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["operator"]] [Unsafe.data "&times;"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["operator"]] [txt "-"];

          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "7"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "8"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "9"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["operator"]] [txt "+"];

          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "4"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "5"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "6"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["equals"]] [txt "="];

          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "1"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "2"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "3"];
          button ~a:[a_button_type `Submit; a_name "input"; a_class ["number"]] [txt "0"];

          button ~a:[a_button_type `Submit; a_name "input"; a_class ["decimal"]] [txt "."];
        ]
      ]
    ])
  |> Format.asprintf "%a" (Tyxml.Html.pp ())

let handle_index _ =
  let display = "0" in
  let response_html = calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

(* Function to handle calculations *)
let handle_calculation req =
  let open Lwt.Syntax in
  let* form = Request.to_urlencoded req in
  let display =
    match List.assoc_opt "input" form with
    | Some ["C"] -> "0"
    | Some (value :: _) -> value
    | _ -> "Error"
  in
  let response_html = calculator_page display in
  Response.of_plain_text response_html
  |> Response.add_header ("Content-Type", "text/html")
  |> Lwt.return

(* Custom route to serve the styles.css file *)
let handle_stylesheet _ =
  let file_path = "styles.css" in
  Lwt_io.with_file ~mode:Lwt_io.Input file_path Lwt_io.read
  >|= fun css_content ->
  Response.of_plain_text css_content
  |> Response.add_header ("Content-Type", "text/css")

(* Main application setup *)
let () =
  App.empty
  |> App.get "/" handle_index
  |> App.post "/calculate" handle_calculation
  |> App.get "/styles.css" handle_stylesheet
  |> App.port 3000
  |> App.run_command
