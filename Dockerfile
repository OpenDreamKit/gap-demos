FROM gapsystem/gap-docker-master

MAINTAINER Alexander Konovalov <alexander.konovalov@st-andrews.ac.uk>

COPY --chown=1000:1000 . $HOME/gap-demos

RUN cd $GAP_HOME/pkg \
 && wget https://github.com/gap-packages/meataxe64/releases/download/v0.1/meataxe64-0.1.tar.gz \
 && tar -xzf meataxe64*.tar.gz \
 && cd meataxe64* \
 && ./autogen.sh \
 && ./configure --with-gaproot=$GAP_HOME \
 && make

RUN sudo pip3 install ipywidgets RISE jupyter_francy

RUN jupyter-nbextension install rise --user --py

RUN jupyter-nbextension enable rise --user --py

RUN sudo jupyter nbextension enable --user --py --sys-prefix jupyter_francy

USER gap

WORKDIR $HOME/gap-demos/
