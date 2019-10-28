FROM gapsystem/gap-docker

MAINTAINER Alexander Konovalov <alexander.konovalov@st-andrews.ac.uk>

COPY --chown=1000:1000 . $HOME/gap-demos

RUN sudo pip3 install ipywidgets RISE jupyter_francy

RUN jupyter-nbextension install rise --user --py

RUN jupyter-nbextension enable rise --user --py

RUN jupyter-nbextension enable jupyter_francy --user --py --sys-prefix

USER gap

WORKDIR $HOME/gap-demos/
