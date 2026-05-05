FROM nginx:alpine
    COPY index.html /usr/share/nginx/html/index.html
    EXPOSE 80
    ```
4.  **Test Locally:** Open your terminal in that folder and run:
    `docker build -t my-web-app .`
    `docker run -d -p 8080:80 my-web-app`
    Check `localhost:8080` in your browser.

---

## **Step 2: Git Flow (GitHub)**
1.  **Initialize Git:** Run `git init` in your folder.
2.  **The "Main" Branch:**
    *   `git add .`
    *   `git commit -m "Initial commit: Base app and Dockerfile"`
3.  **The "Feature" Branch:**
    *   `git checkout -b feature/update-ui`
    *   Modify `index.html` (e.g., add a background color).
    *   `git add .`
    *   `git commit -m "Updated UI on feature branch"`
4.  **Push to GitHub:** Create a new repository on GitHub and link it:
    *   `git remote add origin <your-github-repo-url>`
    *   `git push -u origin main`
    *   `git push origin feature/update-ui`

---

## **Step 3: Setup Azure App Service**
1.  Go to the **Azure Portal**.
2.  **Create a Resource:** Select "Web App".
3.  **Configuration:**
    *   **Publish:** Select "Docker Container".
    *   **Operating System:** Linux.
    *   **Region:** Choose the one closest to you.
4.  **Docker Tab:** For now, select "Docker Hub" and "Hello World" just to get the service running. We will overwrite this with GitHub Actions in the next step.

---

## **Step 4: CI/CD Workflow (GitHub Actions)**
In your GitHub repository, click the **"Actions"** tab and select "New Workflow" -> "Set up a workflow yourself." Name it `main.yml`.

This file will automate the build and deploy:
```yaml
name: Build and Deploy to Azure

on:
  push:
    branches: [ "main" ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: 'Checkout Github Action'
      uses: actions/checkout@v3

    - name: 'Login to Azure'
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: 'Build and push image'
      run: |
        docker build . -t ${{ secrets.AZURE_REGISTRY_SERVER }}/webapp:${{ github.sha }}
        # Add commands here to push to your Azure Container Registry