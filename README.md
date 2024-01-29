# Mercury
All Vivado project configuration for recreating Petalinux and HDL build for Zynq7000

### Hardware
Using MicroZed 7z020 RevH with custom carrier board

## Recreating Vivado Project
1. Install Vivado 2023.2 (Version might not matter but that's what I'm using)
2. (On Ubuntu, execuatble paths may vary) Run `/tools/Xilinx/Vivado/2023.2/bin/vivado -mode tcl -source mercury_proj.tcl`
3. Run `exit` in the TCL console
4. Open project in Vivado!

## Recreating Petalinux Build
1. Pull `nwdepatie/mercury-build` from DockerHub (`docker pull nwdepatie/mercury-build`, note that this is around 14GB)
2. Run `docker run docker run -it -v "$PWD":"$PWD" -w "$PWD" --rm -u petalinux mercury-build

#### Rebuilding the Docker Image
> The Docker container is GINORMOUS and I found the base here: https://github.com/carlesfernandez/docker-petalinux2. This should only be done periodically and should not be the main method of building

1. Download Petalinux installer and move to `mercury/installers/petalinuxwhatever.run`
2. In another terminal, run `python3 -m "http.server"` to start an FTP server
3. Run `docker build --build-arg PETA_VERSION="2023.2" --build-arg PETA_RUN_FILE="petalinux-v2023.2-10121855-installer.run" -t mercury-build .` (Build takes a longish time)
4. Run container like normal with whatever tag you passed (might be `mercury build`)
