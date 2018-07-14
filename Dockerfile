# Firefox over VNC
#
# VERSION               0.1
# DOCKER-VERSION        0.2
FROM ubuntu:latest

RUN  apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated software-properties-common libstdc++6 gnupg2 vnc4server
RUN  add-apt-repository ppa:dolphin-emu/ppa -y
RUN  apt-get update && apt-get install -y dolphin-emu


RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
  && echo "deb http://packages.cloud.google.com/apt main" \
    | tee /etc/apt/sources.list.d/gcsfuse.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && apt-get update \
  && apt-get install --yes gcsfuse \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN export myuser=root && \
    export mypasswd=mysecret && \
    mkdir /.vnc && \
    echo $mypasswd > /.vnc/passwd && \
    chown -R $myuser:$myuser .vnc && \
    chmod 0600 /.vnc/passwd

RUN DISPLAY=10.0.2.15:0



# first create user and group for all the X Window stuff
# required to do this first so have consistent uid/gid between server and client container
RUN addgroup --system xusers \
  && adduser \
			--home /home/xuser \
			--disabled-password \
			--shell /bin/bash \
			--gecos "user for running X Window stuff" \
			--ingroup xusers \
			--quiet \
			xuser

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
				x11-utils \
				x11-xserver-utils \
		&& rm -rf /var/lib/apt/lists/*

# create or use the volume depending on how container is run
# ensure that server and client can access the cookie
RUN mkdir -p /Xauthority && chown -R xuser:xusers /Xauthority
VOLUME /Xauthority





# start x11vnc and expose its port
ENV DISPLAY :0.0
EXPOSE 5900
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh






# switch to user and start
USER xuser
ENTRYPOINT ["/entrypoint.sh"]







#CMD /usr/games/dolphin-emu

#docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix recalbox
#if you get Unable to initialize GTK+ error run xhost + command on the hostmachine
