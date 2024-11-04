open Opium
open Lwt.Infix

let handle_stylesheet _ =
  let file_path = "css/styles.css" in
  Lwt_io.with_file ~mode:Lwt_io.Input file_path Lwt_io.read
  >|= fun css_content ->
  Response.of_plain_text css_content
  |> Response.add_header ("Content-Type", "text/css")
