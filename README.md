# Atlantis & Terraform Spotify Playlist Automation

This repository aims to automate the deployment of a Spotify playlist using **Terraform** and **Atlantis**, alongside **Spotify Auth Proxy** for secure API authentication. The goal is to automate the process of running `terraform plan` and `terraform apply` via Atlantis when changes are pushed to GitHub.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setting Up GitHub](#setting-up-github)
3. [Docker Setup](#docker-setup)
4. [Environment Setup](#environment-setup)
5. [Starting the Project](#starting-the-project)

---

## Prerequisites

Before you begin, make sure you have the following tools installed:

- Docker & Docker Compose
- Spotify developer account (for `SPOTIFY_CLIENT_ID` and `SPOTIFY_CLIENT_SECRET`)
- Terraform

## Setting Up GitHub

1. **Create a GitHub App**:

   - Go to your GitHub account and navigate to **Settings > Developer Settings > GitHub Apps**.
   - Click **New GitHub App** and follow the setup wizard.
   - **Set permissions** for the app:
     - Set **Repository permissions** to `Read & write` for **Contents** and **Pull requests**.
     - Set **Organization permissions** to `Read` for **Members**, if applicable.
   - Once the app is created, save the **App ID** and **Private Key** file (download the `.pem` file, you will use this for authentication).

2. **Generate GitHub OAuth Token** (Note: In this case, the `.pem` file is used for authentication instead of a GitHub token).

---

# Configuring GitHub for Atlantis

Atlantis requires a webhook in your repository to trigger `terraform plan` whenever someone opens a pull request (PR).

## Steps in GitHub

1. Go to **Settings** → **Webhooks** in your GitHub repository.
2. Click **Add Webhook**.
3. Configure the webhook with the following:
   - **Payload URL**: `http://your_server:4141/events`
   - **Content type**: `application/json`
   - **Secret**: Leave this blank.
   - **Which events?** → Select **Pull requests** and **Pushes**.
4. Enable the webhook by clicking **Add Webhook**.

This ensures that Atlantis will listen for events in the repository and execute `terraform plan` and `terraform apply` when a PR is opened or pushed.

---

## Docker Setup

### Docker Compose Configuration

This repository uses **Docker** to spin up Atlantis and the Spotify Auth Proxy. The `docker-compose.yml` file includes two services:

1. **Atlantis**: Automates Terraform commands like `plan` and `apply`.
2. **Spotify Auth Proxy**: A proxy that handles Spotify API authentication and provides an API key.

### Networks Configuration

Both services are on the same Docker network (`atlantis_default`), allowing communication between them. You can customize the network by modifying the `docker-compose.yml`.

---

## Environment Setup

1. **Create a `.env` file** inside the `Atlantis` directory with the following variables:

```env
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
GH_APP_ID=your_github_app_id
```

2. Place the GitHub App Key (the .pem file you downloaded earlier) inside the Atlantis directory, and update the docker-compose.yml to point to this file.

---

# Starting the project

To start the project and automate the setup:

1. Ensure your `.env` file is set up correctly with the necessary Spotify credentials and GitHub App ID.
2. Run the `start.sh` script from the Atlantis directory:

   ```bash
   ./start.sh
   ```

## The script will automatically:

- Start the containers using docker compose up.
- Fetch the API Key and add it to terraform.tfvars.
- Open the Spotify Auth URL in your default browser for authentication.
- Once authenticated, Terraform is ready to be used with Atlantis.
