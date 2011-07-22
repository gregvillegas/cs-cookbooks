#
# Cookbook Name:: python_271
# Recipe:: default
#
# Copyright 2011, AutoShepherd, LLC
#
# All rights reserved - Do Not Redistribute
#
tarball="Python-2.7.1.tgz"

#download  RPMFORGE
execute "Download RPM" do
   cwd "/tmp"
   command  "wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.1-1.el5.rf.i386.rpm"
   creates "/tmp/rpmforge-release-0.5.1-1.el5.rf.i386.rpm" 
   action :run
end

#install the RPM
execute "Install RPM" do
   src_file = "/tmp/rpmforge-release-0.5.1-1.el5.rf.i386.rpm"
   command "rpm -Uvh #{src_file}"
   action :run
end

#install GPG key
execute "Install GPG key" do
    key_dir = "/tmp/chef-solo/cookbooks/python_271/files/default"
    command "rpm --import #{key_dir}/RPM-GPG-KEY.dag.txt"
    action :run
end

#install build essentials
execute "Install build-essentils" do
    essential_files = "gdbm-devel readline-devel ncurses-devel zlib-devel"
    command  "yum -y install #{essential_files}"
    action :run
end

#download python
execute "Download Python" do
    tarball_url =  "http://python.org/ftp/python/2.7.1/#{tarball}"
    cwd "/tmp"
    command "wget #{tarball_url}"
    creates "/tmp/#{tarball}"
    action :run
end

#extract tarball
execute "Extract Tarball" do
    cwd "/tmp"
    command "tar xzf /tmp/#{tarball}"
    creates "/tmp/Python-2.7.1"
    action :run
end

#compile and install
execute "Compile and install" do
    cwd "/tmp/Python-2.7.1"
    command "/tmp/Python-2.7.1/configure --prefix=/opt && make && make install"
    action :run
end

#download setuptools
execute "downloadSetupTools" do
    cwd "/tmp"
    command "wget http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg#md5=fe1f997bc722265116870bc7919059ea"
    creates "/tmp/setuptools-0.6c11-py2.7.egg"
    action :run
end

#install setuptools
execute "Install setuptools" do
    cwd "/tmp"
    command "export PATH=/opt/bin:$PATH ; sh setuptools-0.6c11-py2.7.egg && easy_install pip"
    action :run
end

#install PGRPMS repo
execute "Install pgrms repo" do
    pgrms_URL = "http://yum.pgrpms.org/reporpms/9.0/pgdg-centos-9.0-2.noarch.rpm"
    command "rpm -Uvh #{pgrms_URL}"
    action :run
end

#install psycopg2
execute "Install psycopg2" do
    export_path = "PATH=/usr/pgsql-9.0/bin:/opt/bin:$PATH"
    devel_essentials = "postgresql90-libs postgresql90-devel"
    command "yum -y install #{devel_essentials} && export #{export_path}; pip-2.7 install psycopg2 ; yum -y install mercurial  "
    action :run
end
