# Overview

The idea of this small project is to create a set of utilities for cmake based projects to easily create projects using this templates.

# Dependencies

For testing we are using gtest:

```bash
# go to a folder to download google test and:
git clone https://github.com/google/googletest 
cd googletest 
cmake -DBUILD_SHARED_LIBS=ON . 
make 
sudo make install
sudo ldconfig
```

# Configuration

- Downlad the repo somewhere wherever you want `cmake-project-utils-folder`
- Add the following entry in your bash source file
```
# replace the cmake-project-utils-folder with the real path
source <cmake-project-utils-folder>/scripts/setup.bash
```
