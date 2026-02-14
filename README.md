# calcure-RE-sonarqube

**Software Re‑Engineering Assignment**
**Date:** 14 February 2026

**Written by:**
Anna Zubair
& Muhammad Basim

---

## Project Overview

This project demonstrates the **containerization** and **static code analysis** of *Calcure* — a modern TUI (Terminal User Interface) calendar and task manager.

* **Repository:** [https://github.com/anufrievroman/calcure](https://github.com/anufrievroman/calcure)
* **Language:** Python
* **License:** MIT

### Description

A minimal, customizable terminal‑based calendar and task manager supporting:

* Cloud‑synced `.ics` files
* Todo lists with subtasks
* Persian calendar support
* Weather display
* Vim‑style navigation

---

# Docker Execution Steps

This section explains how the Calcure application was containerized and executed using Docker.

## 1️⃣ Create a Dockerfile

Create a file named `Dockerfile` in the root directory with the following content:

```dockerfile
# Use Python runtime
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir .

# Create config directory manually
RUN mkdir -p /root/.config/calcure

# Run the application
CMD ["python", "-m", "calcure"]
```

### Why These Steps?

* **FROM python:3.9-slim** → Lightweight base image with Python pre‑installed
* **WORKDIR /app** → Sets working directory inside container
* **COPY . /app** → Copies project files into container
* **RUN pip install --no-cache-dir .** → Installs project dependencies
* **CMD** → Runs Calcure when the container starts

---

## 2️⃣ Build the Docker Image

Run the following command in the project directory:

```bash
docker build -t calcure-assignment .
```

This compiles the Dockerfile into a reusable image.

---

## 3️⃣ Run the Container

```bash
docker run -it --rm calcure-assignment
```

**Flags explanation:**

* `-it` → Interactive terminal mode
* `--rm` → Automatically removes container after exit

If successful, Calcure launches inside the container.

---

# SonarQube Analysis Steps

Static code analysis was performed using SonarQube deployed via Docker.

## 1️⃣ Deploy SonarQube Server

Pull and run the official image:

```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube:community
```

**Explanation:**

* `-d` → Detached mode
* `-p 9000:9000` → Maps container port to localhost

Access the dashboard at:

```
http://localhost:9000
```

**Login credentials:**

* Username: `admin`
* Password: `admin`

Update the password when prompted.

---

## 2️⃣ Create a New Project

Inside the SonarQube dashboard:

* **Project Name:** re1
* **Project Key:** re1
* **Branch:** Main

---

## 3️⃣ Generate Authentication Token

Generate an analysis token from:

```
My Account → Security → Generate Token
```

This token allows the scanner to securely communicate with the server.

---

## 4️⃣ Run SonarScanner via Docker

Instead of installing SonarScanner locally, run it as a container:

```bash
docker run --rm \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=re1 \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://host.docker.internal:9000 \
  -Dsonar.token=YOUR_GENERATED_TOKEN
```

### Configuration Parameters

* `-Dsonar.projectKey=re1` → Links scan to created project
* `-Dsonar.sources=.` → Analyzes current directory
* `-Dsonar.host.url` → Points scanner to local server
* `-Dsonar.token` → Authenticates scan

After execution, results appear on the SonarQube dashboard.

---

# Analysis Summary

The static analysis of Calcure revealed:

* **Total Code Smells:** 84
* **High Cognitive Complexity** in multiple files
* **Wildcard Imports** (`from module import *`)
* **PEP‑8 Convention Violations**
* **Code Duplication:** 1.8%
* **Maintainability Rating:** A

### Most Critical Issues

* Extremely complex functions (Cognitive Complexity up to 139)
* Namespace pollution due to wildcard imports
* Use of string slicing instead of `.startswith()`

---

# Conclusion

The containerization of Calcure ensured a **reproducible** and **isolated** deployment environment. Deploying SonarQube via Docker enabled efficient static code analysis without local installation complexity.

### Key Takeaways

* Docker simplifies environment consistency
* SonarQube quantifies technical debt
* CI/CD integration can prevent maintainability degradation
* Refactoring high‑complexity functions will significantly improve long‑term sustainability

---
