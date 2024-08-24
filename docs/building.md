# Building a XmrSigner SD card image
Assemble the XmrSigner OS along with the XmrSigner application code into an image file that can be flashed to an SD card and run in your XmrSigner.
<br/>
<br/>
<br/>
## 🔥🔥🔥🛠 Quickstart: XmrSigner Reproducible Build! 🛠🔥🔥🔥

<details><summary>macOS / Linux instructions:</summary>
<p>

### Install Dependencies
* Docker (choose one):
    * Desktop users: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
    * Or Linux command line: [Docker Engine](https://docs.docker.com/engine/install/#server)

### Launch the build
In a terminal window:

```bash
# Copy the XmrSigner OS repo to your local machine
git clone --recursive https://github.com/MoneroSigner/monerosigner-os.git

# Move into the repo directory
cd monerosigner-os

# initialize and update submodules (buildroot)
git submodule init && git submodule update
```

Force Docker to build on a container meant to run on amd64 in order to get an identical result, even if your actual cpu is different:

```bash
export DOCKER_DEFAULT_PLATFORM=linux/amd64
```

Select your board type from the [Board configs](#board-configs) list below. 

If you're unsure, most people should specify `pi0`.

```bash
export BOARD_TYPE=pi0
```

Start the build!

```bash
SS_ARGS="--$BOARD_TYPE --app-branch=0.7.0" docker compose up --force-recreate --build
```

Building can take 25min to 2.5hrs+ depending on your cpu and will require 20-30 GB of disk space.
</p>
</details>


<details><summary>Windows PowerShell instructions:</summary>
<p>
Recommend running these steps in WSL2 (Windows Subsystem for Linux) so that you can just follow the Linux steps below.

### Install Dependencies
* Docker (choose one):
    * Desktop users: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
    * Or Linux command line: [Docker Engine](https://docs.docker.com/engine/install/#server)
* Windows PowerShell users may also need to [install `git`](https://git-scm.com/download/win)

### Launch the build
In a terminal window:

```bash
# Copy the XmrSigner OS repo to your local machine
git clone --recursive https://github.com/MoneroSigner/monerosigner-os.git

# Move into the repo directory
cd monerosigner-os

# initialize and update submodules (buildroot)
git submodule init && git submodule update
```

Force Docker to build on a container meant to run on amd64 in order to get an identical result, even if your actual cpu is different:

```powershell
$env:DOCKER_DEFAULT_PLATFORM = 'linux/amd64'
```

Select your board type from the [Board configs](#board-configs) list below. 

If you're unsure, most people should specify `pi0`.

```powershell
$env:BOARD_TYPE = 'pi0'
```

Start the build!

```powershell
# TODO: INCORRECT SYNTAX FOR POWERSHELL(?)
SS_ARGS="--%BOARD_TYPE% --app-branch=0.7.0" docker compose up --force-recreate --build
```

Building can take 25min to 2.5hrs+ depending on your cpu and will require 20-30 GB of disk space.

</p>
</details>
<br>


---

## Build Results
When the build completes you'll see:
```bash
xmrsigner-os-build-images-1  | /opt/buildroot
xmrsigner-os-build-images-1  | a380cb93eb852254863718a9c000be9ec30cee14a78fc0ec90708308c17c1b8a  /opt/../images/xmrsigner_os.0.7.0.pi0.img
xmrsigner-os-build-images-1 exited with code 0
```

The second line above lists the SHA256 hash of the image file that was built. This hash should match the hash of the release image [published on the main github repo](https://github.com/MoneroSigner/monerosigner/releases/tag/0.7.0). If the hashes match, then you have successfully confirmed the reproducible build!

The completed image file will be in the `images` subdirectory.
```bash
cd images
ls -l

total 26628
-rw-r--r-- 1 root root       97 Sep 11 02:09 README.md
-rw-r--r-- 1 root root 27262976 Sep 11 18:49 xmrsigner_os-0.7.0.pi0.img
```

That image can be burned to an SD card and run in your XmrSigner.

<br/>
<br/>

---


## Board configs
| Board                 | Image Name                        | Build Script Option |
| --------------------- | --------------------------------- | ------------------- |
|Raspberry Pi Zero      |`xmrsigner_os.<tag>.pi0.img`      | --pi0               |
|Raspberry Pi Zero W    |`xmrsigner_os.<tag>.pi0.img`      | --pi0               |
|Raspberry Pi Zero 2 W  |`xmrsigner_os.<tag>.pi02w.img`    | --pi02w             |


---


## Hashes for each build target
| Build | SHA256 Hash | Image Name |
| ----- | ----------- | ---------- |
| pi0   |``|  xmrsigner_os-0.7.0.pi0.img|
| pi02w |``|  xmrsigner_os-0.7.0.pi02w.img|
