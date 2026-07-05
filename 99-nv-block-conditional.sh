#!/bin/sh
# Pure POSIX sh environment generator for systemd --user

for vendor_file in /sys/bus/pci/devices/*/vendor; do
    # Handle cases where no files match the glob pattern safely
    [ -e "$vendor_file" ] || continue

    # Use shell built-in read instead of external 'cat'
    read -r pci_vendor < "$vendor_file"

    if [ "$pci_vendor" = "0x8086" ]; then
        # Use native parameter expansion instead of external 'dirname'
        device_dir="${vendor_file%/vendor}"

        if [ -f "$device_dir/class" ]; then
            read -r pci_class < "$device_dir/class"
            
            # Match standard VGA (0x0300) or 3D controller (0x0302) classes
            case "$pci_class" in
                0x0300*|0x0302*)
                    echo "VK_LOADER_DRIVERS_DISABLE=nvidia_icd.json"
                    echo "__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json"
                    break
                    ;;
            esac
        fi
    fi
done
