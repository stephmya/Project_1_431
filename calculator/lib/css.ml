open Opium
open Lwt.Infix

let handle_stylesheet _req =
  let file_path = "./lib/styles.css" in  (* Correct file path based on folder structure *)
  Lwt_io.with_file ~mode:Lwt_io.Input file_path (fun ic ->
    Lwt_io.read ic
  ) >>= fun css_content ->
  Logs.info (fun f -> f "Serving CSS content");  (* Simple log message *)
  let response = Response.of_plain_text css_content in
  Lwt.return (Response.add_header ("Content-Type", "text/css") response)
