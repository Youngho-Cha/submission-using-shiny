# Submission Using Shiny

This project provides a Shiny application for automated performance metric calculation in clinical evaluations of in vitro diagnostic (IVD) medical devices. The app is containerized using Docker for easy deployment.

---

## 🚀 How to Run the Shiny App Using Docker

### 1. ✅ Verify Docker Installation

After installing [Docker Desktop](https://www.docker.com/products/docker-desktop/), open a terminal and run the following command to check if Docker is working:

```bash
docker --version

You should see the installed Docker version

### 2. 📂 Clone the Repository and Move into the Directory

Use the following commands to clone the repository and move into the project folder:

```bash
git clone https://github.com/Youngho-Cha/submission-using-shiny.git
cd submission-using-shiny

This will download the source code and set your working directory to the project folder.

### 3. 🛠️ Build the Docker Image

Build the Docker image using the following command:

```bash
docker build --no-cache -t submission-app .

### 4. 🧱 Run the Shiny App Inside the Docker Container

Launch the Shiny app by running:

```bash
docker run -p 3838:3838 submission-app

This command runs the app inside a container and maps port 3838 to your local machine.

### 5. 🌐 Access the Shiny App in Your Browser

After the container starts, open your browser and visit:

```arduino
http://localhost:3838

You should see the Shiny app running and ready to use.
