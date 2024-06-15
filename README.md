# MCtoolsInstaller
Holds basic instructions for installing the most common MC tools in a Ubuntu OS

Currently the following tools can be installed:

  * [Delphes](https://cp3.irmp.ucl.ac.be/projects/delphes)
  * [Pythia8](https://pythia.org/)
  * [HepMC](http://hepmc.web.cern.ch/hepmc/)
  * [MadGraph5](https://launchpad.net/mg5amcnlo/)
  * [MadAnalysis5](https://launchpad.net/madanalysis5/)
  * [CheckMATE](https://github.com/CheckMATE2/checkmate2)
  * [FastJet](http://fastjet.fr/)
  * [YODA](https://gitlab.com/hepcedar/yoda/)
  * [Rivet](https://gitlab.com/hepcedar/rivet/)
  * [Contur](https://gitlab.com/hepcedar/contur/)
  * [MatchMaker](https://gitlab.com/m4103/matchmaker-eft)

Running:

```
./installer_tools.sh <path to installation folder>
```

Will try to fetch the required files and install the tools.

## Dependencies

The following packages/tools must already be installed in the system:

 * autoconf
 * libtool
 * gzip
 * bzr
 * sqlite3
 * cython3
 * form
 * [ROOT](https://root.cern/) 
 
In addition the variable $ROOTSYS must be properly defined.
 
For installing ROOT the following steps can be taken:

 1. Download the tarball from [ROOT releases](https://root.cern/install/all_releases/)
 2. Install all the required dependencies (see [ROOT dependencies](https://root.cern/install/dependencies/))
 3. Extract the tarball to root-src
 4. Make the build and installation dirs (mkdir root-build root-<version>)
 5. In the buld folder run:

```
cmake ../root-src -DCMAKE_INSTALL_PREFIX=$homeDIR/root-<version> -Dall=ON -Dmemstat=OFF
make
make install
```
