(* let () = print_endline "Hello, World!" *)
let () =
  let matrix = Owl.Mat.eye 3 in
  Owl.Mat.print matrix;
  print_endline "Hello, Owl!"