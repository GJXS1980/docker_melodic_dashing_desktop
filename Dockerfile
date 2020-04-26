FROM ubuntu:18.04

MAINTAINER Grant Li<gjxslwz@gmail.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Dependencies for system packages
RUN apt-get update \
	&& apt-get install -y supervisor \
		openssh-server vim-tiny \
		xfce4 xfce4-goodies \
		x11vnc xvfb \
		firefox \
		pwgen \
	&& apt-get install --assume-yes apt-utils \
	&& apt-get autoclean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

#	install ros-melodic
# setup keys and setup sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
	&& apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
	&& apt-get update

WORKDIR /root

# Installation
RUN apt-get install -y ros-melodic-desktop-full python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential \
	&& apt-get autoclean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

# Environment setup
RUN /bin/bash -c "echo '#source /opt/ros/melodic/setup.bash' >> ~/.bashrc"

WORKDIR /root

#	install ros-dashing
# setup language environment
RUN locale-gen en_US en_US.UTF-8 \
	&& update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
	&& export LANG=en_US.UTF-8

# setup keys
RUN apt update \
	&& apt install curl gnupg2 lsb-release \
	&& curl http://repo.ros2.org/repos.key | \
	&& apt-key add -

# setup sources.list
RUN sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

# install ros2 packages
RUN apt update \
	&& apt install ros-dashing-desktop python3-argcomplete \
	&& apt-get autoclean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

# Environment setup
RUN /bin/bash -c "echo 'source /opt/ros/dashing/setup.bash' >> ~/.bashrc"

# install others packages
RUN apt update \
	&& apt install ros-dashing-rmw-opensplice-cpp ros-dashing-rmw-connext-cpp \
	&& apt-get autoclean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*


ADD startup.sh ./
ADD supervisord.conf ./

EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["./startup.sh"]


