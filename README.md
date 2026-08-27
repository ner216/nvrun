# nvrun

**Note: This solution is Wayland only**

A lightweight power-saving tool for Linux laptops using NVIDIA Hybrid / On-Demand graphics. It keeps your dedicated GPU completely asleep until you explicitly choose to use it.

---

## Problem
On modern Linux desktops (like GNOME on Wayland), graphics libraries scan all available GPUs whenever a hardware-accelerated app launches or the UI animates. 

Because the NVIDIA driver cannot answer these queries while asleep, it forces the dGPU out of its D3cold deep sleep state and into D0 (full power). This causes a 1–3 second launch lag and can double your laptop's idle power draw during normal desktop usage.

## Fix
1. **User Session Blindfold:** Enables a user-level configuration (`~/.config/environment.d/hide-nvidia.conf`) that forces Vulkan and EGL loaders to ignore the NVIDIA driver registry by default. The desktop runs purely on integrated graphics, leaving the dGPU in a 0-watt sleep state.
2. **Explicit Launcher:** The `nvrun` CLI tool temporarily lifts this blindfold and injects standard NVIDIA Prime offload variables to run specific applications on the dGPU.

---

### Requirements:

- Must have the proprietary Nvidia driver installed
- The Ubuntu graphics mode must be set to "on-demand". You can check this with the following command:
```bash
prime-select query

on-demand
```

### Usage:

- Enable power-saving mode (creates ~/.config/environment.d/hide-nvidia.conf)
```bash
nvrun --enable
```

- Disable power-saving mode (deletes ~/.config/environment.d/hide-nvidia.conf)
```bash
nvrun --disable
```