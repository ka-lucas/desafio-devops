# Contributing to desavio-devops

Thank you for considering contributing to **desavio-devops**! We welcome contributions to improve the project.

## 1️⃣ Repository Structure
The project is organized in the following way:
- `src/`: Source code of the project
- `tests/`: Unit and integration tests
- `docs/`: Documentation
- `scripts/`: Auxiliary scripts (deploy, setup, etc.)
- `data/`: Example or mock data

### Main Files:
- `README.md`: Instructions for using the project
- `pyproject.toml`: Configuration for dependencies and tools
- `requirements.txt`: Project dependencies
- `.gitignore`: Files and folders ignored by version control
- `LICENSE`: Project license
- `CONTRIBUTING.md`: Guidelines for contributing to the project

## 2️⃣ Git Flow (Branching Model)
We follow a branching model based on Git Flow:
- **main**: Contains the stable production version.
- **develop**: Contains features under development and prepared for the next release.
- **feature/***: Feature branches for new functionalities (e.g., `feature/new-feature`).
- **bugfix/***: Branches for bug fixes.
- **hotfix/***: Critical fixes directly for production.
- **release/***: Preparing a new version, including final adjustments.

## 3️⃣ Commit and Pull Request Guidelines
### Commit Message Format:
- `feat`: Adding a new feature
- `fix`: Bug fix
- `docs`: Documentation update
- `style`: Formatting or style changes (spaces, indentation)
- `refactor`: Code refactoring
- `test`: Adding or fixing tests
- `chore`: Changes to build or configuration

#### Example of a commit message:
```bash
feat: Add user authentication feature
```

## Pull Request Rules
- Each PR should be related to an issue.
- Ensure all tests pass before opening a PR.
- At least one team member should review the PR before merging.

## 4️⃣ Continuous Integration (CI/CD)
We use CI/CD pipelines to:
- Run automated tests (`pytest` with `pytest-cov`).
- Check code quality (Linting).
- Automatically build and deploy to staging and production environments.
- Generate coverage reports.

## 5️⃣ Semantic Versioning
We follow Semantic Versioning (`MAJOR.MINOR.PATCH`):
- **MAJOR**: Incompatible changes with previous versions.
- **MINOR**: New features added in a backward-compatible manner.
- **PATCH**: Backward-compatible bug fixes.

## 6️⃣ Documentation and Quality Control
- **Documentation**: The main documentation is in `README.md`.
- **Code Documentation**: All methods and classes should have docstrings.
- **Automatic Documentation**: We use tools like `Sphinx` for automatic generation.
- **Code Quality**: We use static analysis tools like `flake8`, `pylint`, `bandit` and `mypy`.

## 7️⃣ Code Review Policy
- Every PR should be reviewed by at least one team member.
- The review should focus on clarity, performance, and adherence to the project standards.
- Suggestions for improvement and detection of potential issues are encouraged.

## 8️⃣ How to Contribute
1. Fork the repository.
2. Clone your fork:
    ```bash
    git clone https://github.com/ka-lucas/desafio-devops
    ```
3. Create a new branch for your feature or fix:
    ```bash
    git checkout -b feature/your-feature-name
    ```
4. Make your changes and commit them following the commit message guidelines.
5. Push your changes and create a pull request.
6. Make sure your PR passes all tests and is reviewed by a team member before merging.

For any questions or suggestions, please reach out to us at [katarinelucas1@gmail.com].

We look forward to your contributions!

## 9️⃣ Generating `requirements.txt` with Poetry
If you need to generate a `requirements.txt` for compatibility with other tools (e.g., when deploying or using CI/CD systems that require `pip`), you can do so using Poetry:

```bash
poetry export --without-hashes -f requirements.txt > requirements.txt
```

---

## 🔄 10️⃣ Pre-commit Hooks

We use *Pre-commit* to automate code checks before each commit.

### 🚀 Installation
```bash
pre-commit install
```

### ⚙️ Usage
The hooks will automatically:
- Run `flake8` for style checks.
- Run `black` for formatting.
- Run `pylint` for static analysis.
- Run `bandit` for security checks.
- Run `mypy` for type checking.

### 🔍 Manual Execution
```bash
pre-commit run --all-files
```

Pre-commit hooks ensure code quality and consistency before changes are committed, preventing issues from reaching the main branch.

---

## 🔁 11️⃣ CI/CD and Deployment Process

We use **GitHub Actions** for automated testing and deployment.

### 📦 Docker & GCR
- The application is containerized using **Docker**.
- Docker images are automatically built and pushed to **Google Container Registry (GCR)**.

### ☁️ Google Cloud Run
- The app is deployed to **Google Cloud Run** using **Terraform**.
- Deployments are split into two environments:
  - `develop` → **Homologation**
  - `main` → **Production**

### ⚙️ CI/CD Workflow
On every push or pull request to `develop` or `main`, the following steps are executed:

1. ✅ **Code Quality Checks**: `flake8`, `black`, `pylint`, `bandit`, `mypy`
2. 🧪 **Test Execution**: Using `pytest` and coverage report (`codecov`)
3. 🐳 **Docker Build & Push**: Builds the container and pushes to `gcr.io`
4. 🌍 **Terraform Deploy**: Applies infrastructure changes via Terraform for Cloud Run

### 🔐 GitHub Secrets Required
You must configure the following **GitHub Secrets** in your repository:

- `GCP_PROJECT_ID`: Your Google Cloud project ID
- `GCP_CREDENTIALS_JSON_BASE64`: Base64-encoded contents of the service account JSON key

To encode your credentials:
```bash
base64 -w 0 path/to/service-account.json
```
Then paste the result in your GitHub repository secrets.

---

## 🧪 12️⃣ Running the Application Locally

You can test the application locally before pushing:

### ▶️ Using Flask (simple mode)
```bash
export NAME=YourName
poetry run python src/app.py
```

### ▶️ Using Gunicorn (production-like mode)
```bash
export NAME=YourName
poetry run gunicorn wsgi:app --bind 0.0.0.0:8080
```

### 🐳 Using Docker
1. Build the image:
```bash
docker build -t desafio-api .
```

2. Run it:
```bash
docker run -p 8080:8080 -e NAME=YourName desafio-api
```

The application will be accessible at: [http://localhost:8080](http://localhost:8080)
