# Project 1 CS431: Calculator GUI with OCaml and Owl

## Contributors

- **Erik Vodanovic**
- **Stephanie Myalik**

---

## Getting Started

### Building the Docker Container

1. **For most systems:**

   ```bash
   docker build -t ocaml-project .
   ```

2. **For Apple Silicon (ARM architecture):**
   ```bash
   docker buildx build --platform linux/amd64 -t ocaml-project .
   ```

### Running the Project

Once the container is built, you can run the project with:

```bash
docker run -p 3000:3000 ocaml-project
```

This will start the server, making the GUI accessible at `http://localhost:3000`.

---

### What This Program Does
This project is a web-based calculator app built with OCaml, the Dune build system, the Owl library for numerical computations, and Opium for the web server.

The calculator supports basic arithmetic operations, trigonometric functions, and matrix operations. The GUI is styled with CSS and uses JavaScript to send expressions to the server for evaluation. The server uses Owl to compute the result and return it to the client.

The project is containerized with Docker for easy deployment and cross-platform compatibility.

### Problems Encountered

1. **Using Docker - Owl is not compatible with ARM processors** - We couldn't build the entire project locally on each of our devices due to processor differences. So we had to set up a Docker container in order for both group members to run the project. We have both used Docker containers for work (primarily for JavaScript projects), but this was our first time setting up a Docker container for an OCaml project and the configurations were a bit different and less intuitive than expected.

2. **Modules/Imports - Issues with imports and module use** - We had some issues with module imports in the project. We had to make sure that the modules were properly imported and that modules/imports were being called correctly. This was touchy and we jerry rigged a few things by disabling warnings and inserting the CSS styling directly into the layout file. 

3. **CSS Styling - CSS application issues** - We had issues importing the CSS stylesheet into the file it was to be used in. It would be recieved by the server but not applied to the page. We resolved this by placing the CSS directly into the layout file. This was not ideal but it was the only way we could get the CSS to apply correctly.

4. **JavaScript - Probably not best practice** - We used JavaScript to send the expressions to the server. This was likely not the best way to do this, but weren't able to get it to work with just OCaml. It worked for our purposes.

5. **Debugging** - Debugging this project was time consuming because there is no "hot reload" for OCaml. We had to rebuild the project every time we made a change and then restart the server. This made the process slower and more tedious than desired. 


### The project structure includes:

- bin/: Contains the main entry point of the application.
- lib/: Includes the core logic for the calculator, layout definitions, and CSS handling.
- Dockerfile: Configuration for building and running the Docker container.
- calculator.opam: OPAM package definition for managing dependencies.

The application runs an Opium server that handles HTTP requests for the calculator operations and serves CSS file for styling the GUI. The server listens on port 3000, making the calculator accessible via web browser at http://localhost:3000.
