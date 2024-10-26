# VisualSM on Ubuntu 24.04
## Links
- http://ccwu.me/vsfm/
- http://www.10flow.com/2012/08/15/building-visualsfm-on-ubuntu-12-04-precise-pangolin-desktop-64-bit/
- https://github.com/pitzer/SiftGPU
- https://grail.cs.washington.edu/projects/mcba/pba_v1.0.5.zip
- http://www.di.ens.fr/pmvs/pmvs-2.tar.gz
- http://www.di.ens.fr/cmvs/cmvs-fix2.tar.gz
- https://www.cs.utexas.edu/~dml/Software/graclus1.2.tar.gz

## Dependecies
``` 
sudo apt-get install libgtk2.0-dev libglew2.2 libglew-dev libdevil-dev libboost-all-dev libatlas-base-dev imagemagick libatlas3-base libcminpack-dev libgfortran5 libmetis-edf-dev libparmetis-dev freeglut3-dev libgsl-dev
```

## Build VisualSFM

```
unzip VisualSFM_linux_64bit.zip 
cd vsfm
cd build
ar -x ../lib/VisualSFM.a;
cd ..
g++ -w -o bin/VisualSFM build/*.* -pthread -lGL -lGLU -lX11 -ldl -lgtk-x11-2.0 -lgdk-x11-2.0 -lpangocairo-1.0 -latk-1.0 -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0 -lharfbuzz -lfontconfig -lfreetype -lgthread-2.0 -pthread -lglib-2.0  lib/lapack.a lib/blas.a lib/libf2c.a lib/libjpeg.a -no-pie
```

## Build SiftGPU

```
cd SiftGPU
```
Modify the makefile to enable/disable CUDA
```
siftgpu_enable_cuda = 0
```
Build
```
$ make
```

Move the library
```
cp bin/libsiftgpu.so  ../vsfm/bin/
```

## pba
```
make -f makefile_no_gpu
cp libpba_no_gpu.so ../../vsfm/bin/libpba.so
```

## PMVS2
```
tar -xvf pmvs-2.tar.gz
cd pmvs-2/program/main/
cp mylapack.o mylapack.o.backup
make clean
cp mylapack.o.backup mylapack.o
make depend
make -no-pie
```

## Graclus 1.2
Modify `Makefile.in` to set 
```
-DNUMBITS=64
```
Build
```
make
```

## CLAPACK
```
git clone https://github.com/NIRALUser/CLAPACK.git
cp make.inc.example make.inc
make f2clib
ln -s INCLUDE clapack
```

## CMVS


cp pmvs-2/program/main/mylapack.o cmvs/program/main/

cmvs/program/base/cmvs/bundle.cc

cmvs/program/main/genOption.cc

Makefile:

```
#Your INCLUDE path (e.g., -I/usr/include)
YOUR_INCLUDE_PATH = -I/home/seb/Dev/external/VisualSFM/CLAPACK

#Your metis directory (contains header files under graclus1.2/metisLib/)
YOUR_INCLUDE_METIS_PATH = -I/home/seb/Dev/external/VisualSFM/graclus1.2/metisLib

#Your LDLIBRARY path (e.g., -L/usr/lib)
YOUR_LDLIB_PATH = -L/home/seb/Dev/external/VisualSFM/graclus1.2
```

../base/cmvs/../stann/dpoint.hpp
```
                           std::cerr << "Error Reading Point:" 
                                     //<< is
                                     << std::endl;
                                exit(1);

```

```
cp cmvs ../../../vsfm/bin/
cp pmvs2 ../../../vsfm/bin/
cp genOption ../../../vsfm/bin/
```

