# VisualSM on Ubuntu 24.04 (64 bits)

Installation script for [VisualSFM](http://ccwu.me/vsfm/) on Ubuntu 24.04.

The script is based on this [article](http://www.10flow.com/2012/08/15/building-visualsfm-on-ubuntu-12-04-precise-pangolin-desktop-64-bit/).

## 1. Download the instllation script
```
git clone https://github.com/colas-sebastien/VisualSFM.git
```

## 2. Build VisualSFM (without CUDA)
```
cd VisualSFM
./install.sh
```

## 3. Enjoy VisualSFM on Ubuntu 24.04
```
./VisualSFM.sh
```

## Cleaning temporary directories (optionnal)
```
./clean.sh
```

## Test
- File / Open Multiple Images
- SfM / Pairwize Matching / Compute Missing Match
- SfM / Reconstruct parse
- SfM / Reconstruct dense

