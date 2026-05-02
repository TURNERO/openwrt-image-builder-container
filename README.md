# OpenWrt Mesh Builder for Zyxel WSM20 (mesh11sd)

This project provides a Dockerized environment to build custom OpenWrt images for an **OpenWRT router** in this case the **Zyxel WSM20** (ramips/mt7621) with **mesh11sd** pre-installed and custom startup configurations.

It should be very easy to update the platform and other information to target a different router. Eventually I'll parameterize it, but for now this does what I need. I used Gemini to create this and had to make a few of my own changes.

## 📂 Project Structure
Ensure your local directory looks like this before building:
```text
.
├── Dockerfile
├── build.sh
├── README.md
└── files/
    └── etc/
        └── uci-defaults/
            └── 99-mesh-setup  <-- Your custom startup script
```

## 🛠️ Usage Instructions

### 1. Build the Docker Image
This step installs the necessary tools (`zstd`, `build-essential`, etc.) and downloads the OpenWrt 25.12.2 Image Builder.
```bash
docker build -t openwrt-mesh-builder .
```

### 2. Generate the Firmware
Run the container. We mount a local `bin` folder to the container so the finished firmware is saved to your computer.
```bash
# Create the output directory
mkdir -p bin

# Run the build
docker run --rm -v $(pwd)/bin:/build/bin openwrt-mesh-builder
```

## 🔧 Customization

### Startup Scripts
Any script placed in `files/etc/uci-defaults/` will execute **once** during the very first boot of the device. This is ideal for:
* Setting default WiFi SSIDs.
* Configuring `mesh11sd` parameters via UCI.
* Setting the root password.

### Package List
To change which packages are included, edit the `PACKAGES` variable inside `build.sh`. 
* **Note:** For the Zyxel WSM20, the build includes `wpad-mbedtls`, `kmod-nft-bridge`, and `mesh11sd`.
* **Space Saving:** If the image is too large, add `-luci` to the package list to remove the web interface.

## 📝 Troubleshooting
* **zstd Errors:** Ensure you are using the updated Dockerfile that includes the `zstd` package.
* **Extraction Failures:** If `tar` fails, verify that the `RELEASE`, `TARGET`, and `SUBTARGET` arguments in the Dockerfile match the official OpenWrt download paths.

---
*Created for automated mesh11sd deployments.*
