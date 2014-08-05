#!/bin/bash
#This script is a work in development and is not stable.
#This script requires curl and git to be installed
#Run this script using root's login shell under: sudo su -

DATE=$(date)

ENV=$1

#==================================#
#####################
###!!!!!! Still under development.  Not stable!!!!!!!!!!!!!##############
geonode(){
  echo "geonode"
  if [[ $# -ne 2 ]]; then
    echo "Usage: cybergis-script-env.sh geonode [install|reset]"
  else
    ENV=$1
    CMD=$2
    #
    if [[ "$CMD" = "install" ]]; then
      sudo apt-get update
      # Essential build tools and libraries
      sudo apt-get install python-software-properties
      sudo apt-get install -y build-essential libxml2-dev libxslt1-dev libjpeg-dev gettext git python-dev python-pip python-virtualenv
      sudo apt-get install -y libgdal1h libgdal-dev python-gdal
      sudo apt-get install -y libgeos-dev libpq-dev
      # Python and Django dependencies with official packages
      sudo apt-get install -y python-lxml python-psycopg2 python-django python-bs4 python-multipartposthandler transifex-client python-nose python-django-nose python-django-pagination python-django-extensions python-httplib2
      # Java dependencies
      sudo apt-get install -y --force-yes openjdk-6-jdk ant maven2 --no-install-recommends
      #Install python packages for development
      sudo pip install virtualenvwrapper paver
    
      #Add all these lines to ~/.bash_aliases
      echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python' >> ~/.bash_alises
      echo 'export WORKON_HOME=~/.venvs' >> ~/.bash_alises
      echo 'source /usr/local/bin/virtualenvwrapper.sh'>> ~/.bash_alises
      echo 'export PIP_DOWNLOAD_CACHE=$HOME/.pip-downloads' >> ~/.bash_alises
      echo 'workon geonode' >> ~/.bash_alises
    
      cd ~/geonode
      mkvirtualenv geonode
      workon geonode
      pip install pillow tasypie django-taggit django-jsonfield django-downloadview
      #Install GeoNode
      pip install -e geonode
      #cd geonode
      #./restart.sh
    elif [[ "$CMD" = "reset" ]]; then
      # 
      cd ~/geonode
      paver stop
      paver reset_hard
      paver setup
      paver start -b paver start -b 0.0.0.0:8000
      #
    else
      echo "Usage: cybergis-script-env.sh geonode [install|reset]"
    fi
  fi
}

if [[ "$ENV" = "geonode" ]]; then
    
    if [[ $# -ne 2 ]]; then
        echo "Usage: cybergis-script-env.sh geonode [install|reset]"
    else
        export -f geonode
        bash --login -c geonode
    fi

else
    echo "Usage: cybergis-script-env.sh [geonode]"
fi
