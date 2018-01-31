#!/bin/bash
#wget https://pypi.python.org/packages/3b/72/163c1d2eaf7d7c825f4442d0c8c6469fd77bcbb951dacd09526b54ad8931/inotify_simple-1.1.7.tar.gz
#wget https://pypi.python.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz#md5=5f13a0841a61f7fc295c514490d120d0
wget http://pyyaml.org/download/pyyaml/PyYAML-3.12.tar.gz
wget https://pypi.python.org/packages/83/91/162f2c76729633d1dc36b09746895c7766bc183bba94cb4d2ec398676060/websocket_client-0.46.0.tar.gz#md5=95c97ead3030858d672251e9bc2dbaaf
dir=`pwd`
for file in ./*.tar.gz; do
    tar xvzf $file
    fileNoExt=${file%.tar.gz}
    cd "$dir/${fileNoExt##*/}"
    python setup.py install
    cd $dir
done
#ln -s /home/ling.ma/agent-smith /opt/agent-smith
