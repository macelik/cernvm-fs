#!/bin/bash

# Download cvmfs-release-latest_all.deb
wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb

# Install cvmfs-release-latest_all.deb
dpkg -i cvmfs-release-latest_all.deb

# Remove cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb

# Update apt-get
apt-get update

# Install cvmfs
apt-get install cvmfs

# Backup auto.master file
cp /etc/auto.master /etc/auto.master.backup

# Modify auto.master file
sed -i 's%#+dir:/etc/auto.master.d%+dir:/etc/auto.master.d%' /etc/auto.master

# Restart autofs service
systemctl restart autofs

# Create default.local file
touch /etc/cvmfs/default.local

# Add CVMFS configuration to default.local
echo "CVMFS_REPOSITORIES=data.galaxyproject.org" >> /etc/cvmfs/default.local
echo "CVMFS_HTTP_PROXY=DIRECT" >> /etc/cvmfs/default.local
echo "CVMFS_CLIENT_PROFILE=single" >> /etc/cvmfs/default.local
echo "CVMFS_USE_GEOAPI=yes" >> /etc/cvmfs/default.local

# Run cvmfs_config setup
cvmfs_config setup

# Run cvmfs_config probe for data.galaxyproject.org
cvmfs_config probe data.galaxyproject.org

# Change directory to /cvmfs/data.galaxyproject.org/

