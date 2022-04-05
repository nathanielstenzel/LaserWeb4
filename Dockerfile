#
# ---- Base Node ----
FROM node:16-bullseye AS base
# set working directory
WORKDIR /usr/src/app

# Set up Apt, and install udev
RUN apt update
RUN apt install -y build-essential udev

# copy project file
COPY package*.json ./
EXPOSE 8000
# copy app sources
COPY . .

#
# - Bash (used for debug)
FROM base AS bash
WORKDIR /usr/src/app
# define CMD
CMD [ "bash" ]

#
# ---- Dependencies ----
FROM base AS dependencies
# install node packages
RUN npm install -g npm
RUN npm set progress=false
# Run npm install and add nodemon + lw comm server from Git
#  (Currently use --force to allow for broken deps, this should be removed once the dep tree is fixed
RUN npm install -g nodemon && npm -force install && npm install --force lw.comm-server@git+https://github.com/LaserWeb/lw.comm-server.git

#
# ---- Release ----
# This will use the git head version of lw.comm-server + the LW app version bundled with that.
#  it DOES NOT build and serve the version of LaserWeb in this repo
#  this is provided for completeness but is inefficient, lots of unnesscary data and code is bundled but not used
#
FROM dependencies AS release
WORKDIR /usr/src/app
# define CMD
CMD [ "node", "node_modules/lw.comm-server/server.js"]

#
# ---- Dev ----
FROM dependencies AS dev
WORKDIR /usr/src/app
# Bundle the development build
RUN npm run bundle-dev
# Install into lw-comm-server
RUN rm -rfv node_modules/lw.comm-server/app/* && cp -prv dist/* node_modules/lw.comm-server/app/
# define CMD
CMD [ "node", "node_modules/lw.comm-server/server.js"]
