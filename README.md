# ☁️ Cloudy

An [Armbian][armbian]-based firmware image that uses cloud-init for configuration. So far the following boards are supported:

- [`nanopi-r5s`][nanopi-r5s]
- `uefi-x86`
- `rpi4b`

## 🚀 Quickstart

Make sure to have a recent version of [Docker][docker], [Git][git] and `build-essential` installed, then run the following commands:

```bash
# Build the image for the NanoPi R5S.
make build
```

After flashing the image to an SD card, you should be able to connect to it via SSH using the username `nicklasfrahm` and the `id_ed25519` private key with the comment `nicklasfrahm@gl552vw`. Alternatively, you may log in locally using the username `root` and the password `cloudy1234`.

## 💡 Known issues

### 🪄 Can't use `armbian-install` on `uefi-x86`

The `armbian-install` script does not create the right partition layout when using the `uefi-x86` images. My best guess is that it does not cater for the EFI partition. As a workaround, you can perform the following steps:

1. Flash the `.img` to a USB as you would with any other image
1. Mount the USB's root partition and copy the `.img` to `/uefi-x86.img`
1. Unmount the USB and insert it into the new device
1. Boot the device and wait for it to come online
1. SSH into the device and run the following command:

   ```bash
   # Install pv to get a progress bar.
   sudo apt install -y pv
   # DANGER! This will overwrite the first disk on the host.
   export TARGET_DISK=/dev/sdX
   sudo dd if=/uefi-x86.img bs=4M |
     pv -tpreb -s $(sudo stat -c "%s" /uefi-x86.img) |
     sudo dd of="$TARGET_DISK" bs=4M
   ```

1. Reboot the device.

## 📜 License

The whole project is licensed under the [GPL-2.0 license][license].

[armbian]: https://github.com/armbian/build
[nanopi-r5s]: https://www.friendlyelec.com/index.php?route=product/product&product_id=287
[docker]: https://www.docker.com/
[git]: https://git-scm.com/
[license]: LICENSE.md
