# 🎮 MCPE Versions

> 📦 A simple, automatically updated list of **Minecraft Bedrock / MCPE** versions.

Version data is collected from [MCPELIFE](https://mcpelife.com/download/) and stored in [`versions.json`](https://github.com/FaiBah/MCPE-Versions/blob/main/versions.json).

## 📄 JSON

```json
{
  "stable": "<latest-stable>",
  "preview": "<latest-preview>",
  "versions": [
    "<stable-version>",
    "<stable-version>",
    "<stable-version>"
  ],
  "preview_versions": [
    "<preview-version>",
    "<preview-version>",
    "<preview-version>"
  ]
}
```

## 🧩 Fields

| Field                 | Description             |
| --------------------- | ----------------------- |
| 🟢 `stable`           | Latest stable version   |
| 🔵 `preview`          | Latest preview version  |
| 📦 `versions`         | Stable version history  |
| 🧪 `preview_versions` | Preview version history |

> ℹ️ Version lists are ordered from **newest to oldest**.

## 🚀 Usage

### 🟢 Latest Stable

```bash
curl -s https://raw.githubusercontent.com/FaiBah/MCPE-Versions/main/versions.json | jq -r '.stable'
```

### 🔵 Latest Preview

```bash
curl -s https://raw.githubusercontent.com/FaiBah/MCPE-Versions/main/versions.json | jq -r '.preview'
```

### 📦 All Stable Versions

```bash
curl -s https://raw.githubusercontent.com/FaiBah/MCPE-Versions/main/versions.json | jq -r '.versions[]'
```

### 🧪 All Preview Versions

```bash
curl -s https://raw.githubusercontent.com/FaiBah/MCPE-Versions/main/versions.json | jq -r '.preview_versions[]'
```

## 🌐 Source

* 🔗 [MCPELIFE](https://mcpelife.com/download/)

## ⚠️ Disclaimer

This is an unofficial community project and is not affiliated with Mojang or Microsoft.
