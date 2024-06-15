#!/bin/bash

currentDIR="$( pwd )"

[ ! -d "$1" ] && echo "Directory $1 DOES NOT exists.\n Please, pass a valid folder path as the first argument of the installer" && exit


homeDIR="$(cd "$(dirname "$1")" >/dev/null; pwd -P)/$(basename "$1")"
echo "Installation will take place in $homeDIR"

echo "[Checking system dependencies]"
PKG_OK=$(dpkg-query -W -f='${Status}' autoconf 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "autoconf not found. Install it with sudo apt-get install autoconf."
  exit
fi
PKG_OK=$(dpkg-query -W -f='${Status}' libtool 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "libtool not found. Install it with sudo apt-get install libtool."
  exit
fi
PKG_OK=$(dpkg-query -W -f='${Status}' gzip 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "gzip not found. Install it with sudo apt-get install gzip."
  exit
fi
PKG_OK=$(dpkg-query -W -f='${Status}' bzr 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "bzr not found. Install it with sudo apt-get install bzr."
  exit
fi
PKG_OK=$(dpkg-query -W -f='${Status}' form 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "form not found. Install it with sudo apt-get install form."
  exit
fi
PKG_OK=$(dpkg-query -W -f='${Status}' sqlite3 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "sqlite3 not found. Install it with sudo apt-get install sqlite3."
  exit
fi
PKG_OK=$(dpkg-query -W -f='${Status}' cython3 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "cython3 not found. Install it with sudo apt-get install cython3."
  exit
fi
PKG_OK=$(dpkg-query -W -f='${Status}' autoconf --version 2>/dev/null | grep -c "ok installed")
if test $PKG_OK = "0" ; then
  echo "autoconf not found. Install it with sudo apt-get install autotools-dev."
  exit
fi

cd $homeDIR

madgraph="MG5_aMC_v3.5.4.tar.gz"
URL=https://launchpad.net/mg5amcnlo/3.0/3.5.x/+download/$madgraph
echo -n "Install MadGraph (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	mkdir MG5;
	echo "[installer] getting MadGraph5"; wget $URL 2>/dev/null || curl -O $URL; 
	tar -zxf $madgraph -C MG5 --strip-components 1;
fi

#Get HepMC tarball
hepmc="hepmc2.06.11.tgz"
echo -n "Install HepMC2 (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	mkdir hepMC_tmp
	URL=http://hepmc.web.cern.ch/hepmc/releases/$hepmc
	echo "[installer] getting HepMC"; wget $URL 2>/dev/null || curl -O $URL; tar -zxf $hepmc -C hepMC_tmp;
	mkdir HepMC-2.06.11; mkdir HepMC-2.06.11/build; mkdir HepMC2;
	echo "Installing HepMC in ./HepMC";
	cd HepMC-2.06.11/build;
	../../hepMC_tmp/HepMC-2.06.11/configure --prefix=$homeDIR/HepMC2 --with-momentum=GEV --with-length=MM;
	make;
	make check;
	make install;

	#Clean up
	cd $homeDIR;
	rm -rf hepMC_tmp; rm $hepmc; rm -rf HepMC-2.06.11;
fi


#Get HepMC tarball
hepmc="HepMC3-3.2.5.tar.gz"
echo -n "Install HepMC3 (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	mkdir hepMC_tmp
	URL=http://hepmc.web.cern.ch/hepmc/releases/$hepmc
	echo "[installer] getting HepMC"; wget $URL 2>/dev/null || curl -O $URL; tar -zxf $hepmc -C hepMC_tmp;
	echo "Installing HepMC in ./HepMC";
	mkdir HepMC3
	cd hepMC_tmp/HepMC3-3.2.5/
	cmake -DCMAKE_INSTALL_PREFIX=$homeDIR/HepMC3 -DHEPMC3_ENABLE_ROOTIO=ON   -DHEPMC3_ENABLE_PYTHON=OFF CMakeLists.txt
	make;
	make install;

	#Clean up
	cd $homeDIR;
	rm -rf hepMC_tmp; rm $hepmc;
fi

#Get pythia tarball
pythia="pythia8307.tgz"
URL=https://pythia.org/download/pythia83/$pythia
echo -n "Install Pythia (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	if hash gzip 2>/dev/null; then
		mkdir pythia8;
		echo "[installer] getting Pythia"; wget $URL 2>/dev/null || curl -O $URL; tar -zxf $pythia -C pythia8 --strip-components 1;
		echo "Installing Pythia in pythia8";
		cd pythia8;
		./configure --with-hepmc2=$homeDIR/HepMC2 --with-root=$ROOTSYS --prefix=$homeDIR/pythia8 --with-gzip
		make -j4; make install;
		cd $homeDIR
		rm $pythia;
	else
		echo "[installer] gzip is required. Try to install it with sudo apt-get install gzip";
	fi
fi


fastjet="fastjet-3.4.0.tar.gz"
URL=http://fastjet.fr/repo/$fastjet
echo -n "Install Fastjet (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	mkdir fastjet_build;
	mkdir fastjet;
	echo "[installer] getting FastJet"; wget $URL 2>/dev/null || curl -O $URL; tar -zxf $fastjet -C fastjet_build --strip-components 1;
	echo "Installing FastJet in fastjet";
	cd fastjet_build;
	./configure --prefix=$homeDIR/fastjet;
	make; make install;
	cd $homeDIR;
	rm -r fastjet_build;
	rm $fastjet;	
fi


echo -n "Install Delphes (y/n)? "
repo=https://github.com/delphes/delphes
URL=http://cp3.irmp.ucl.ac.be/downloads/$delphes
read answer
if echo "$answer" | grep -iq "^y" ;then
  latest=`git ls-remote --sort="version:refname" --tags $repo  | grep -v -e "pre" | grep -v -e "\{\}" | cut -d/ -f3- | tail -n1`
  echo "[installer] Cloning Delphes version $latest";
  git clone --branch $latest https://github.com/delphes/delphes.git Delphes
  cd Delphes;
  export PYTHIA8=$homeDIR/pythia8;
  echo "[installer] installing Delphes";
  make HAS_PYTHIA8=true;
  rm -rf .git
  cd $homeDIR;
fi

echo -n "Install CheckMATE (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
  echo "[installer] getting CheckMATE";
  git clone git@github.com:CheckMATE2/checkmate2.git CheckMATE
  cd CheckMATE
  latest=`git ls-remote --tags  --sort=committerdate | cut -d/ -f3- | tail -n1`
  cd $homeDIR
  rm -rf CheckMATE
  echo "Cloning version $latest"
  git clone --branch $latest git@github.com:CheckMATE2/checkmate2.git CheckMATE;
  cd CheckMATE;
  alias python=python3
  rm -rf .git
  autoreconf -i -f;
  ./configure --with-rootsys=$ROOTSYS --with-delphes=$homeDIR/Delphes --with-pythia=$homeDIR/pythia8 --with-madgraph=$homeDIR/MG5 --with-hepmc=$homeDIR/HepMC2
  echo "[installer] installing CheckMATE";
  make -j4
  cd $homeDIR
fi


echo -n "Install MadAnalysis (y/n)? "
read answer
repo=https://github.com/MadAnalysis/madanalysis5
if echo "$answer" | grep -iq "^y" ;then
   echo "[installer] getting MadAnalysis";
   latest=`git ls-remote --refs --sort="version:refname" --tags $repo | cut -d/ -f3-|tail -n1`
   git clone --branch $latest git@github.com:MadAnalysis/madanalysis5.git MadAnalysis5;
   cd MadAnalysis5/bin
   echo -e "install fastjet\ninstall zlib\ninstall delphes\ninstall PAD\nexit\n" > mad_install.txt
   ./ma5 -f < mad_install.txt
   rm mad_install.txt
   cd $homeDIR
   echo "[installer] done";
fi


echo -n "Install Rivet (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo "[installer] Installing Contur using myrivet-bootstrap";
	test -d rivet || mkdir rivet
	test -d tools-build || mkdir tools-build
	INSTALL_PREFIX=$homeDIR/rivet ./myrivet-bootstrap
	echo "[installer] done";
fi

echo -n "Install Contur (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
        cd $homeDIR
        source setenv_rivet.sh
        echo "[installer] Getting Contur from main branch";
        wget "https://gitlab.com/hepcedar/contur/-/archive/main/contur-main.tar.gz";
        mkdir contur;
        tar -zxf "contur-main.tar.gz" -C contur --strip-components 1;
        cd contur;
        echo "[installer] installing Contur"
        make;
        cd $homeDIR;
        rm "contur-main.tar.gz";
	#echo "[installer] Installing Contur using pip3";
	#pip3 install --user contur --break-system-packages;
        #source ~/.local/bin/conturenv.sh
        #cd $CONTUR_DATA_PATH
        #make;
        cd $homeDIR
        echo "[installer] done";
fi


qgraf="qgraf-3.6.6.tgz"
URL=http://qgraf.tecnico.ulisboa.pt/v3.6/$qgraf
echo -n "Install MatchMaker (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	path_to_executable=$(which qgraf)
	if [ -x "$path_to_executable" ] ; then
		echo "QGraf found at $path_to_executable"
	else
		echo "[installer] getting QGraf"; wget --user anonymous --password anonymous $URL 2>/dev/null || curl -O $URL; 
		mkdir qgraf_tmp
		mv $qgraf qgraf_tmp
		cd qgraf_tmp		
		tar -xzf $qgraf
        mkdir fmodules
		gfortran -o qgraf -Os -J fmodules qgraf-3.6.6.f08
		mv qgraf ~/.local/bin/
	fi
	cd $homeDIR
	rm -rf qgraf_tmp
	pip3 install --user matchmakereft
	echo "[installer] MatchMaker has been installed. Run it once (>matchmakereft) to set the path to FeynRules."
fi

#
#
# echo -n "Install CutLang (y/n)? "
# read answer
# if echo "$answer" | grep -iq "^y" ;then
#   echo "[installer] getting CutLang";
#   git clone git@github.com:unelg/CutLang.git CutLang;
#   cd CutLang;
#   cd CLA;
#   echo "[installer] compiling CutLang";
#   make;
#   cd ..;
#   rm -rf .git;
#   rm -rf ADLLHCanalyses;
#   echo "[installer] getting ADLLHCanalyses";
#   git clone git@github.com:ADL4HEP/ADLLHCanalyses.git ADLLHCanalyses;
#   rm -rf ADLLHCanalyses/.git
#   cd $homeDIR
# fi


cd $currentDIR
