open Tyxml.Html

let calculator_page display =
  html
    (head (title (txt "OCaml Calculator")) [
       link ~rel:[`Stylesheet] ~href:"/styles.css" ();
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
          input ~a:[a_id "display"; a_class ["display"]; a_name "display"; a_value display; a_readonly ()] ();

          (* Add buttons here *)
          button ~a:[a_button_type `Button; a_onclick "appendValue('C')"; a_class ["clear"]] [txt "C"];
          (* More buttons in similar structure... *)
        ]
      ]
    ])
  |> Format.asprintf "%a" (Tyxml.Html.pp ())
