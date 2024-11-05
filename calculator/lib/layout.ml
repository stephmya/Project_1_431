open Tyxml.Html

let calculator_page display =
  html
    (head (title (txt "OCaml Calculator")) [
       link ~rel:[`Stylesheet] ~href:"/styles.css?v=1.2" ();  (* Cache-busting for CSS *)
       script (txt "
         function appendValue(value) {
           const display = document.getElementById('display');
           display.value += value;
         }

         function handleButtonClick(value) {
           const display = document.getElementById('display');
           if (value === 'C') {
             display.value = '';
           } else if (value === '=') {
             display.form.submit();
           } else {
             appendValue(value);
           }
         }
       ")
    ])
    (body [
      div ~a:[a_class ["calculator"]] [
        form ~a:[a_id "calcForm"; a_action "/calculate"; a_method `Post; a_class ["buttons"];
                 a_onsubmit "handleButtonClick('='); return false;"] [  (* Prevent default form submission *)

          input ~a:[
            a_id "display"; 
            a_class ["display"]; 
            a_name "display"; 
            a_value display;
            a_input_type `Text;
            a_autocomplete `Off;
            a_placeholder "0";
          ] ();

          button ~a:[a_button_type `Button; a_class ["clear"]; a_onclick "handleButtonClick('C')"] [txt "C"];
          button ~a:[a_button_type `Button; a_class ["operator"]; a_onclick "handleButtonClick('/')"] [Unsafe.data "&divide;"];
          button ~a:[a_button_type `Button; a_class ["operator"]; a_onclick "handleButtonClick('*')"] [Unsafe.data "&times;"];
          button ~a:[a_button_type `Button; a_class ["operator"]; a_onclick "handleButtonClick('-')"] [txt "-"];

          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('7')"] [txt "7"];
          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('8')"] [txt "8"];
          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('9')"] [txt "9"];
          button ~a:[a_button_type `Button; a_class ["operator"]; a_onclick "handleButtonClick('+')"] [txt "+"];

          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('4')"] [txt "4"];
          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('5')"] [txt "5"];
          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('6')"] [txt "6"];
          button ~a:[a_button_type `Button; a_class ["equals"]; a_onclick "handleButtonClick('=')"] [txt "="];

          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('1')"] [txt "1"];
          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('2')"] [txt "2"];
          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('3')"] [txt "3"];
          button ~a:[a_button_type `Button; a_class ["function"]; a_onclick "handleButtonClick('sin(')"] [txt "sin"];

          button ~a:[a_button_type `Button; a_class ["number"]; a_onclick "handleButtonClick('0')"] [txt "0"];
          button ~a:[a_button_type `Button; a_class ["decimal"]; a_onclick "handleButtonClick('.')"] [txt "."];
          button ~a:[a_button_type `Button; a_class ["parentheses"]; a_onclick "handleButtonClick('(')"] [txt "("];
          button ~a:[a_button_type `Button; a_class ["parentheses"]; a_onclick "handleButtonClick(')')"] [txt ")"];
          button ~a:[a_button_type `Button; a_class ["function"]; a_onclick "handleButtonClick('cos(')"] [txt "cos"];
        ]
      ]
    ])
  |> Format.asprintf "%a" (Tyxml.Html.pp ())
