open Tyxml.Html
let stylesheet = "
/* styles.css */
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
.buttons button {
  font-size: 18px;
  padding: 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.2s;
}
.buttons .number {
  background-color: #e0e0e0;
}
.buttons .operator {
  background-color: #f9a825;
  color: white;
}
.buttons .equals {
  background-color: #4caf50;
  color: white;
  grid-column: span 2;
}
.buttons .clear {
  background-color: #f44336;
  color: white;
}
.buttons .function {
  background-color: #9c27b0;
  color: white;
}
.buttons .decimal, .buttons .parentheses {
  background-color: #e0e0e0;
}
.buttons button:hover {
  background-color: #d0d0d0;
}
"

let calculator_page display =
  html
    (head (title (txt "OCaml Calculator")) [
       style [txt stylesheet];
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
                 a_onsubmit "handleButtonClick('='); return false;"] [ 
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
