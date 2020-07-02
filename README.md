# GitHub Actions Bulid Metricbeat
Test GitHub Actions：Success
1. Use Docker Multi-Stage Builds  
2. Use binfmt_misc / qemu-user-static (Docker Images Setup)
3. Use Docker Buildx  
4. Use GitHub Actions (Workflows)  
5. Build Multi Architecture Docker Image (amd64 / arm64)  
6. Auto Push DockerHub  
  
# GitHub Actions Hosted Runners (Build system information)
# Cloud Instance
    Microsoft Azure VMs

# Custom Operating System and Version：Yes
    runs-on: ubuntu-latest (ubuntu-18.04) [Build：Success]
    runs-on: ubuntu-20.04 [Build：Success]
    runs-on: ubuntu-16.04 [Build：Success]

    ubuntu-20.04 (focal)
    ubuntu-16.04 (xenial)

# lsb_release -a
    Distributor ID:	Ubuntu
    Description:	Ubuntu 20.04 LTS
    Release:	20.04
    Codename:	focal

    Distributor ID:	Ubuntu
    Description:	Ubuntu 16.04.6 LTS
    Release:	16.04
    Codename:	xenial

# uname -r
    Ubuntu 20.04 LTS
    5.4.0-1019-azure

    Ubuntu 16.04.6 LTS
    4.15.0-1089-azure

# docker version  
    Client: Docker Engine - Community
     Version:           19.03.12
     API version:       1.40
     Go version:        go1.13.10
     Git commit:        48a66213fe
     Built:             Mon Jun 22 15:45:36 2020
     OS/Arch:           linux/amd64
     Experimental:      true

    Server: Docker Engine - Community
     Engine:
      Version:          19.03.12
      API version:      1.40 (minimum version 1.12)
      Go version:       go1.13.10
      Git commit:       48a66213fe
      Built:            Mon Jun 22 15:44:07 2020
      OS/Arch:          linux/amd64
      Experimental:     false
     containerd:
      Version:          1.2.13
      GitCommit:        7ad184331fa3e55e52b890ea95e65ba581ae3429
     runc:
      Version:          1.0.0-rc10
      GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
     docker-init:
      Version:          0.18.0
      GitCommit:        fec3683

# docker buildx version
    github.com/docker/buildx v0.4.1 bda4882a65349ca359216b135896bddc1d92461c
