#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

cwd=`pwd`
patch=$cwd/patches
dl=$cwd/downloads
build=$cwd/builds
bin=$cwd/bin
lib64=$cwd/lib64

echo -e "${GREEN}Installing dependencies${ENDCOLOR}"
sudo apt-get install libgtk2.0-dev libglew2.2 libglew-dev libdevil-dev libboost-all-dev libatlas-base-dev imagemagick libatlas3-base libcminpack-dev libgfortran5 libmetis-edf-dev libparmetis-dev freeglut3-dev libgsl-dev

################# CREATING DIRECTORIES #################
if ! [ -d $dl ]; then
  echo -e "${GREEN}Creating folder: $dl${ENDCOLOR}"
  mkdir $dl 2>/dev/null
fi

if ! [ -d $build ]; then
  echo -e "${GREEN}Creating folder: $build${ENDCOLOR}"
  mkdir $build 2>/dev/null
fi

if ! [ -d $bin ]; then
  echo -e "${GREEN}Creating folder: $bin${ENDCOLOR}"
  mkdir $bin 2>/dev/null
fi

if ! [ -d $lib64 ]; then
  echo -e "${GREEN}Creating folder: $lib64${ENDCOLOR}"
  mkdir $lib64 2>/dev/null
fi

################# DOWNLOADING FILES #################
cd $dl
if ! [ -f VisualSFM_linux_64bit.zip ]; then
  echo -e "${GREEN}Downloading VisualSFM${ENDCOLOR}"
  wget http://ccwu.me/vsfm/download/VisualSFM_linux_64bit.zip
fi

if ! [ -f SiftGPU.zip ]; then
  echo -e "${GREEN}Downloading SiftGPU${ENDCOLOR}"
  wget https://github.com/pitzer/SiftGPU/archive/refs/heads/master.zip -O SiftGPU.zip
fi

if ! [ -f pba_v1.0.5.zip ]; then
  echo -e "${GREEN}Downloading SiftGPU${ENDCOLOR}"
  wget https://grail.cs.washington.edu/projects/mcba/pba_v1.0.5.zip
fi

if ! [ -f graclus1.2.tar.gz ]; then
  echo -e "${GREEN}Downloading Graclus${ENDCOLOR}"
  wget https://www.cs.utexas.edu/~dml/Software/graclus1.2.tar.gz
fi

if ! [ -f CLAPACK.zip ]; then
  echo -e "${GREEN}Downloading CLAPACK${ENDCOLOR}"
  wget https://github.com/NIRALUser/CLAPACK/archive/refs/heads/master.zip -O CLAPACK.zip
fi

if ! [ -f cmvs-fix2.tar.gz ]; then
  echo -e "${GREEN}Downloading CMVS${ENDCOLOR}"
  wget http://www.di.ens.fr/cmvs/cmvs-fix2.tar.gz
fi

################# BUILD #################
cd $build
if ! [ -d $build/vsfm ]; then
  echo -e "${GREEN}Decompressing VisualSFM${ENDCOLOR}"
  unzip -n $dl/VisualSFM_linux_64bit.zip
fi

if ! [ -f $build/vsfm/bin/VisualSFM ]; then
  echo -e "${GREEN}Building VisualSFM${ENDCOLOR}"
  cd vsfm
  patch <$patch/vsfm.makefile.patch
  make clean
  make
  cp $build/vsfm/bin/* $bin
fi

cd $build
if ! [ -d $build/SiftGPU ]; then
  echo -e "${GREEN}Decompressing SiftGPU${ENDCOLOR}"
  unzip -n $dl/SiftGPU.zip
  mv SiftGPU-master SiftGPU
fi

if ! [ -f $build/SiftGPU/bin/libsiftgpu.so ]; then
  echo -e "${GREEN}Building SiftGPU${ENDCOLOR}"
  cd SiftGPU
  patch <$patch/SiftGPU.makefile.nocuda.patch
  make clean
  make
  cp $build/SiftGPU/bin/libsiftgpu.so $lib64
fi

cd $build
if ! [ -d $build/pba ]; then
  echo -e "${GREEN}Decompressing PBA${ENDCOLOR}"
  unzip -n $dl/pba_v1.0.5.zip
fi

if ! [ -f $build/pba/bin/libpba_no_gpu.so ]; then
  echo -e "${GREEN}Building PBA${ENDCOLOR}"
  cd pba
  make clean
  make -f makefile_no_gpu
  cp $build/pba/bin/libpba_no_gpu.so $lib64/libpba.so
fi

cd $build
if ! [ -d $build/graclus1.2 ]; then
  echo -e "${GREEN}Decompressing Graclus${ENDCOLOR}"
  tar -xvf $dl/graclus1.2.tar.gz
fi

if ! [ -f $build/graclus1.2/graclus ]; then
  echo -e "${GREEN}Building Graclus${ENDCOLOR}"
  cd graclus1.2
  patch <$patch/graclus.Makefile.in.64bits.patch
  make clean
  make
fi

cd $build
if ! [ -d $build/CLAPACK ]; then
  echo -e "${GREEN}Decompressing CLAPACK${ENDCOLOR}"
  unzip $dl/CLAPACK.zip
  mv CLAPACK-master CLAPACK
  cd CLAPACK
  ln -s INCLUDE clapack
fi

cd $build
if ! [ -d $build/cmvs ]; then
  echo -e "${GREEN}Decompressing CMVS${ENDCOLOR}"
  tar -xvf $dl/cmvs-fix2.tar.gz  
fi

if ! [ -f $build/cmvs/program/main/cmvs ]; then
  echo -e "${GREEN}Building CMVS${ENDCOLOR}"
  cd $build/cmvs/program/main
  patch <$patch/cmvs.Makefile.patch
  cd $build/cmvs/program/main
  patch <$patch/cmvs.genOption.cc.patch
  cd $build/cmvs/program/base/cmvs
  patch <$patch/cmvs.bundle.cc.patch
  cd $build/cmvs/program/base/stann
  patch <$patch/cmvs.dpoint.hpp.patch
  cd $build/cmvs/program/main
  make clean
  make
  cp $build/cmvs/program/main/cmvs $bin
  cp $build/cmvs/program/main/pmvs2 $bin
  cp $build/cmvs/program/main/genOption $bin
fi

