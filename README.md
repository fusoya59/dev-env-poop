# 💻 Dev Environment - Podman Outside of Podman

This project sets up a full-featured development container using **Podman** with a Docker Compose-style workflow. It's built for working with:

- 🐍 Python (`pipx`, `debugpy`, `pyright`, `mypy`, `pytest`, `uv`)
- 🐙 Git & Lazygit
- 🪵 AWS CLI + your credentials/config
- ☸️ Kubernetes tools (`kubectl`, `k9s`)
- 🧠 Node.js (via NVM)
- 🐳 Podman itself from inside the container (Podman-outside-of-Podman™️)
- ✨ Neovim with plugin support (no Snap required)

---

## 🚀 Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/fusoya59/dev-env-poop.git
cd dev-env-poop
```

### 2. Ensure you have Podman + `podman compose`

On Ubuntu 24.04:

```bash
sudo apt update
sudo apt install -y podman pipx
pipx install podman-compose  # Optional fallback
```

Enable Podman’s REST API socket:

```bash
systemctl --user enable --now podman.socket
```

### 3. Mount AWS and Kube config (adjust paths as needed)

```bash
podman-compose build && podman-compose up -d
```

---

## 📁 What’s Inside the Container?

### Tools preinstalled:

| Tool              | Use                                 |
| ----------------- | ----------------------------------- |
| `pipx`            | Python tool isolation               |
| `debugpy`         | Debugging support                   |
| `pyright`         | Fast static type checker            |
| `pytest`          | Python testing                      |
| `mypy`            | Static typing enforcement           |
| `uv`              | Fast package management             |
| `nvm`             | Node.js version manager             |
| `lazygit`         | TUI git client                      |
| `aws`             | AWS CLI v2                          |
| `kubectl`         | Kubernetes CLI                      |
| `k9s`             | TUI Kubernetes dashboard            |
| `nvim`            | Neovim (GitHub release)             |
| `podman`          | Manage containers                   |
| `build-essential` | C compiler tools for Neovim plugins |

---

## 🔐 Credentials & Config

| Tool   | Mount Path          | Notes                                |
| ------ | ------------------- | ------------------------------------ |
| AWS    | `~/.aws/`           | Read-only by default                 |
| Kube   | `~/.kube/`          | Ensure config is readable            |
| SSH    | `~/.ssh/`           | Read-only ssh keys                   |
| Podman | Podman socket mount | Enables host-level container control |

Make sure the following files have these permissions on host:

```bash
chmod 700 ~/.aws ~/.kube
chmod 600 ~/.aws/config ~/.aws/credentials ~/.kube/config

```

---

## 🎨 Bonus

The container includes a custom `.bashrc` with:

- Colored prompt
- Useful aliases (`ll`, `la`, etc.)
- `nvm` auto-loading

---

## 🧹 Cleanup

To stop and remove the container:

```bash
podman-compose down
```

Or:

```bash
podman stop dev-poop && podman rm dev-poop
```

---

## 🐾 Footnote

This project is proudly **Poop™️-powered** (Podman Outside Of Podman).  
Clean. Isolated. Dev-friendly.
