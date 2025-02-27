#!/usr/bin/env bash

# Copyright (C) 2018-2019 Intel Corporation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
rm -Rf build
mkdir build
ln -s /opt/intel/openvino/inference_engine/samples/
ln -s /opt/intel/openvino/deployment_tools/inference_engine/samples/thirdparty/ thirdparty


error() {
    local code="${3:-1}"
    if [[ -n "$2" ]];then
        echo "Error on or near line $1: $2; exiting with status ${code}"
    else
        echo "Error on or near line $1; exiting with status ${code}"
    fi
    exit "${code}"
}
trap 'error ${LINENO}' ERR

DEMOS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Domo path=$DEMOS_PATH"
#rm -Rf camera_photos
#rm -Rf raw_photos
rm -Rf tmp/

[ -d tmp ] || mkdir tmp
[ -d camera_photos ] || mkdir camera_photos
[ -d raw_photos ] || mkdir raw_photos
[ -d output_photos ] || mkdir output_photos

printf "\nSetting environment variables for building demos...\n"

if [ -z "$INTEL_OPENVINO_DIR" ]; then
    if [ -e "$DEMOS_PATH/../../bin/setupvars.sh" ]; then
        setvars_path="$DEMOS_PATH/../../bin/setupvars.sh"
    elif [ -e "$DEMOS_PATH/../../../bin/setupvars.sh" ]; then
        setvars_path="$DEMOS_PATH/../../../bin/setupvars.sh"
    else
        printf "Error: Failed to set the environment variables automatically. To fix, run the following command:\n source <INSTALL_DIR>/bin/setupvars.sh\n where INSTALL_DIR is the OpenVINO installation directory.\n\n"
        exit 1
    fi
    if ! source $setvars_path ; then
        printf "Unable to run ./setupvars.sh. Please check its presence. \n\n"
    exit 1
fi
else
    # case for run with `sudo -E`
    source "$INTEL_OPENVINO_DIR/bin/setupvars.sh"
fi

if ! command -v cmake &>/dev/null; then
    printf "\n\nCMAKE is not installed. It is required to build Open Model Zoo demos. Please install it. \n\n"
    exit 1
fi

build_dir="$DEMOS_PATH/build"

OS_PATH=$(uname -m)
NUM_THREADS="-j2"

if [ $OS_PATH == "x86_64" ]; then
  OS_PATH="intel64"
  NUM_THREADS="-j8"
fi

if [ -e $build_dir/CMakeCache.txt ]; then
    rm -rf $build_dir/CMakeCache.txt
fi
mkdir -p $build_dir
echo "Build dir=$build_dir"
cd $build_dir
cmake -DCMAKE_BUILD_TYPE=Release $DEMOS_PATH
make $NUM_THREADS

printf "\nBuild completed, you can find binaries for all demos in the $build_dir/ subfolder.\n\n"
printf "\n Executable path: ./build/photo_taker/build/intel64/Release/photo_taker"
printf "\n Executable path: ./build/local_recognizer/build/intel64/Release/local_recognizer"
printf "\n Executable path: ./build/preprocess_tool/build/intel64/Release/preprocess_tool\n\n"


printf "Steps to run::\n"
printf "\n steps:1 : ./build/photo_taker/build/intel64/Release/photo_taker test.mp4" 
printf "\n steps:2 : mv camera_photos raw_photos/name1"
printf "\n steps:3 : ./build/preprocess_tool/build/intel64/Release/preprocess_tool" 
printf "\n steps:4 : ./build/local_recognizer/build/intel64/Release/local_recognizer\n"
 
#/root/omz_demos_build/intel64/Release/pedestrian_tracker_demo -i /root/Downloads/mony_test.mp4 -m_det  /root/Downloads/face-detection-adas-0001/FP32/face-detection-adas-0001.xml -m_reid /root/omz_demos_build/OpenVino-Driver-Behaviour/models/FP32/face-reidentification-retail-0095.xml

