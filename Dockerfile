FROM gapsystem/gap-docker-master-hpc

MAINTAINER Alexander Konovalov <alexander.konovalov@st-andrews.ac.uk>

COPY --chown=1000:1000 . $HOME/gap-demos

RUN sudo pip3 install ipywidgets RISE jupyter_francy

RUN jupyter-nbextension install rise --user --py

RUN jupyter-nbextension enable rise --user --py

RUN sudo jupyter nbextension enable --user --py --sys-prefix jupyter_francy

ENV JUPYTER_GAP_EXECUTABLE "/home/gap/inst/gap-master/bin/gap.sh -S --single-thread"

USER gap

WORKDIR $HOME/gap-demos/
