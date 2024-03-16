# Mercury App

Here is the directory relating to all code for driving the platform. Most of the source code is written in Rust, and the whole thing is wrapped in a ROS Noetic catkin package.

## Instructions for Building

I've included a Dockerfile and Docker Compose for maintaining any system environments needed for building the application. The Docker Compose also contains a ROS Core container for local unit testing with a ROS controller. Catkin Tools are also built into the container for some cleaner functionality if regular catkin commands get annoying.

To easily build the project:
1. `docker compose run --rm --build mercury_app`
2. `source devel/setup.bash`
3. `catkin_make`

## Instructions for Testing

If you want to actually interact with the ROS Core, follow the commands below:
1. `docker compose up --build -d`
2. `docker exec -it mercury-app-rust-builder-1 /bin/bash`
3. `source devel/setup.bash`
4. `catkin_make`
