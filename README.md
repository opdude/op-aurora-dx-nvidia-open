# op-aurora-dx-nvidia-open &nbsp; [![bluebuild build badge](https://github.com/opdude/op-aurora-dx-nvidia-open/actions/workflows/build.yml/badge.svg)](https://github.com/opdude/op-aurora-dx-nvidia-open/actions/workflows/build.yml)

A custom Aurora DX image with DisplayLink EVDI support for enhanced multi-monitor setups.

## Features

- **DisplayLink Support**: Includes the EVDI (Extensible Virtual Display Interface) kernel module for DisplayLink devices
- **Secure Boot Compatible**: EVDI module is properly signed for Secure Boot systems
- **Automated Builds**: Daily builds with automatic stable tagging on main branch pushes

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

### Using Latest Build
To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/opdude/op-aurora-dx-nvidia-open:latest
  ```

### Using Stable Tag
For production use, you can use the stable tag which is updated when changes are pushed to the main branch:

- Rebase to the stable image:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/opdude/op-aurora-dx-nvidia-open:stable
  ```

- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/opdude/op-aurora-dx-nvidia-open:latest
  ```
  or for the stable tag:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/opdude/op-aurora-dx-nvidia-open:stable
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

## DisplayLink Setup

### Secureboot

After the first boot, if you have secureboot enabled, you will need to enroll the DisplayLink EVDI module signing key. This is necessary for the evdi module to load correctly.

To do this, run the following command:

```bash
sudo mokutil --import /etc/pki/DisplayLink/evdi-signing-key.der
```

You will be prompted to set a password for MOK enrollment. After setting the password, reboot the system. During boot, you will see the MOK Manager screen. Select "Enroll MOK" and follow the prompts. Enter the password you set earlier to enroll the key. After this, the evdi module should load correctly.

## Development

### Building Locally

You can build the image locally using the provided scripts:

```bash
# Or build using Docker (no kernel headers needed)
./scripts/build-evdi-docker.sh

# Then build the image
bluebuild build recipes/recipe.yml
```

### Prebuilt Modules

Note: The following is only needed for local development as the github actions will automatically build the prebuilt modules.

The image supports prebuilt EVDI modules. Place them in `files/prebuilt-modules/` with the naming convention:
```
evdi-<kernel-version>-<arch>.ko
```

For example: `evdi-6.11.0-68.fc40.x86_64-x86_64.ko`

#### Building Prebuilt Modules

First, we need to switch to the latest aurora-dx-nvidia-open image to get the latest kernel headers:

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/aurora-dx-nvidia-open:stable
```

Then, build the prebuilt modules using the provided script:

```bash
./scripts/build-evdi-docker.sh
```

Add the package to the `files/prebuilt-modules/` directory, and then build the image with the following command to check it works:

```bash
bluebuild build recipes/recipe.yml
```

## Contributing

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for more information about customizing and contributing to this image.


The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/opdude/op-aurora-dx-nvidia-open
```
