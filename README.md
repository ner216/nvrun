# nvrun

**Note: This solution is Wayland only**

A lightweight power-saving tool for Linux laptops using NVIDIA Hybrid / On-Demand graphics. It keeps your dedicated GPU completely asleep until you explicitly choose to use it.

---

## Problem
On modern Linux desktops (like GNOME on Wayland), graphics libraries scan all available GPUs whenever a hardware-accelerated app launches or the UI animates. 

Because the NVIDIA driver cannot answer these queries while asleep, it forces the dGPU out of its D3cold deep sleep state and into D0 (full power). This causes a 1–3 second launch lag and can double your laptop's idle power draw during normal desktop usage.

## Fix
1. **System-Wide Blindfold:** Deploys a configuration file to systemd (`/etc/environment.d/`) that forces Vulkan and EGL loaders to ignore the NVIDIA driver registry by default. The desktop runs purely on integrated graphics, leaving the dGPU in a 0-watt sleep state.
2. **Explicit Launcher:** The `nvrun` CLI tool temporarily lifts this blindfold and injects standard NVIDIA Prime offload variables to run specific applications on the dGPU.

---

## Usage

Launch any application or game on the NVIDIA GPU from your terminal by prefixing the command with `nvrun`:

```bash
nvrun <program> [arguments...]
```

---

### Install
Install the latest package from the releases section.

---

### Notes
Applications that explicitly access the GPU by means other than scanning for hardware through OpenGL and Vulkan
will still wake the GPU.

This means that Switcheroo-control(right-click menu 'Launch using discrete graphics card') will still work. It also means that resource monitor apps like Gnome Resources or nvtop will still wake the GPU while running.
