# Rails Demo Application

This README documents the setup, configuration, and deployment of the Rails Demo application.

## 🚀 Project Overview

- **Framework**: Ruby on Rails 8.1.2
- **Language**: Ruby 3.4.5
- **Database**: PostgreSQL (v16)
- **Styling**: Tailwind CSS
- **Containerization**: Docker (multi-stage builds)
- **CI/CD**: GitHub Actions

## 🐳 Docker Configuration

The application uses a multi-stage `Dockerfile` to optimize for different environments:

1.  **base**: Minimal runtime dependencies (Debian bookworm slim, jemalloc, libvips).
2.  **build**: Includes build tools (gcc, make) for compiling gems and advantages.
3.  **devcontainer**: Optimized for local development with VS Code (includes zsh, sudo, git).
4.  **tests**: Configured for running the test suite in CI.
5.  **release**: The final production-ready image.

## 💻 Local Development Setup

We highly recommend developing within the **Dev Container** to ensure a consistent environment.

### Prerequisites
- Docker Desktop or Docker Engine
- VS Code with "Dev Containers" extension

### Getting Started
1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd rails-demo
    ```
2.  **Open in VS Code**:
    ```bash
    code .
    ```
3.  **Reopen in Container**:
    When prompted by VS Code, click "Reopen in Container". This triggers the `.devcontainer/docker-compose.yml` configuration which:
    - Builds the `devcontainer` stage of the Dockerfile.
    - Spins up a `postgres:16` database service.
    - Mounts the workspace.

4.  **Database Setup**:
    Once inside the container terminal:
    ```bash
    bin/rails db:prepare
    ```

5.  **Start the Server**:
    ```bash
    bin/dev
    ```
    This starts the Rails server along with the Tailwind CSS watcher (via `procfile.dev`).

## 🔑 Credentials Management

The application uses Rails Encrypted Credentials with **two separate master keys**:

1.  **Development/Default**:
    - File: `config/credentials.yml.enc`
    - Key: `config/master.key` (Do not commit this file)
    - Used for local development and general configuration.

2.  **Production**:
    - File: `config/credentials/production.yml.enc`
    - Key: `config/credentials/production.key` (Do not commit this file)
    - Used for production secrets (AWS keys, DB passwords).

To edit credentials:
```bash
# Default
EDITOR="code --wait" bin/rails credentials:edit

# Production
EDITOR="code --wait" bin/rails credentials:edit --environment production
```

## 📡 API Endpoints

The application exposes both web and API endpoints.

### Web Interface
- `GET /` - Home page
- `GET /user` - User profile page
- `GET /up` - Health check (returns 200 OK)
- **Tasks**: `GET /tasks`, `POST /tasks`, etc. (Standard CRUD)
- **Contacts**: `GET /contacts`, `POST /contacts`, etc. (Standard CRUD)
- **Authentication**: Handled via Devise (`/users/sign_in`, `/users/sign_up`, etc.)

### JSON API (`/api` namespace)
**Base URL**: `/api`

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/contacts` | List all contacts |
| `POST` | `/api/contacts` | Create a contact |
| `GET` | `/api/contacts/:id` | Show specific contact |
| `PUT/PATCH` | `/api/contacts/:id` | Update contact |
| `DELETE` | `/api/contacts/:id` | Delete contact |
| `GET` | `/api/tasks` | List tasks (Index only) |
| `GET` | `/api/user` | Show current user details |
| `GET` | `/api/test` | Test endpoint |

## 🔄 CI/CD Pipeline

Continuous Integration and Deployment are handled via **GitHub Actions** (`.github/workflows/ci.yml`).

### Workflow Stages
1.  **Security Scans**:
    - Ruby: `brakeman` analysis.
    - JavaScript: `importmap audit` for dependency vulnerabilities.
2.  **Linting**:
    - Ruby: `rubocop` for code style enforcement.
3.  **Testing**:
    - Builds a dedicated test container (`docker-compose build tests`).
    - Runs unit and system tests (`bin/rails test`, `bin/rails test:system`).
4.  **Build & Push**:
    - Builds the production Docker image.
    - Tags the image: `lexdrel/rails-demo:<branch>-<ddmmyy>-<uuid>`.
    - Pushes to Docker Hub.

## ☁️ Deployment

The application runs on **AWS** within an **Auto Scaling Group**.

### Current Process
- **Infrastructure**: AWS EC2 instances managed by an Auto Scaling Group.
- **Database**: AWS RDS (PostgreSQL).
- **Deployment Method**: **Manual**.
    - The new Docker image is pulled from the registry.
    - The deployment script/process updates the running instances in the ASG.
