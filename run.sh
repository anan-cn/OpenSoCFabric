#!/bin/sh

rm My_MeshWrapper*
sbt "run --hw true --harnessName My_MeshWrapperTest --moduleName My_MeshWrapper --K 3,1 --C 1"
