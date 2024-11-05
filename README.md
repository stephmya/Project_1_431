# Project 1: Calculator GUI with OCaml and Owl

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
