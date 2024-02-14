#! /bin/bash

cd drive_pub;
cargo build;
cd ../drive_sub;
cargo build;
cd ../gantry_sub;
cargo build;
cd ../gantry_pub;
cargo build;
cd ..
