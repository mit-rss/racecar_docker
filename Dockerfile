FROM ubuntu:jammy

# Set environment variables
ENV ROS_DISTRO=humble
ENV NO_VNC_VERSION=1.4.0
ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8
ENV SIM_WS=/home/sim_ws
ARG DEBIAN_FRONTEND=noninteractive

# Add the ROS deb repo to the apt sources list
RUN apt update && \
        apt install -y --no-install-recommends \
		curl wget gnupg2 lsb-release ca-certificates console-setup \
        python3 python3-pip python3-setuptools locales \
        git unzip build-essential cython3 \
        htop zip dos2unix tmuxp xclip ranger python3-venv \
        python-is-python3 software-properties-common \
    && locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS2
RUN apt update && \
    apt install -y --no-install-recommends \
		ros-${ROS_DISTRO}-desktop \
		python3-colcon-common-extensions \
        ros-dev-tools \
        ros-${ROS_DISTRO}-tf2-geometry-msgs \
        ros-${ROS_DISTRO}-ackermann-msgs \
        ros-${ROS_DISTRO}-tf-transformations \
        ros-${ROS_DISTRO}-navigation2 \
        ros-${ROS_DISTRO}-xacro \
        ros-${ROS_DISTRO}-joy \
        ros-${ROS_DISTRO}-rqt-tf-tree \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

# Set up ROS2
RUN rosdep init && rosdep update --include-eol-distros

# Add neovim PPA
RUN add-apt-repository ppa:neovim-ppa/unstable

# Install VNC and things to install noVNC
RUN apt update && apt install -y --no-install-recommends \
    tigervnc-standalone-server \
    openbox x11-xserver-utils xterm dbus-x11 \
    sudo vim emacs nano neovim gedit screen tmux \
    iputils-ping feh

# Download NoVNC and unpack
RUN wget -q https://github.com/novnc/noVNC/archive/v${NO_VNC_VERSION}.zip && \
    unzip v${NO_VNC_VERSION}.zip && rm v${NO_VNC_VERSION}.zip && \
    git clone --depth 1 https://github.com/novnc/websockify /noVNC-${NO_VNC_VERSION}/utils/websockify

# Install additional python packages
RUN pip install --no-cache-dir "numpy<1.25.0" scipy transforms3d opencv-contrib-python

# Kill the bell!
RUN echo "set bell-style none" >> /etc/inputrc

# Create racecar_ws directory and src before switching to USER
RUN mkdir -p ${SIM_WS}/src && cd ${SIM_WS}/src && \
    git clone https://github.com/mit-rss/racecar_simulator.git && \
    cd ${SIM_WS} && \
    /bin/bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash && colcon build;'

# Copy in default config files
COPY ./config/bash.bashrc /etc/
COPY ./config/screenrc /etc/
COPY ./config/vimrc /etc/vim/vimrc
ADD ./config/openbox /etc/X11/openbox/
COPY ./config/XTerm /etc/X11/app-defaults/
COPY ./config/default.rviz /tmp/

# Create a user
RUN useradd -ms /bin/bash racecar && \
    echo 'racecar:racecar@mit' | chpasswd && \
    usermod -aG sudo racecar

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
COPY ./xstartup.sh /usr/bin/xstartup.sh
RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/xstartup.sh

USER racecar
WORKDIR /home/racecar
