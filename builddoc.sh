#!/bin/bash

CMD="$1"; shift
if [ -z "$CMD" ]
then
    CMD="generateHTML"
fi

rm -rf build

CONTAINER_NAME="doctoolchain-$RANDOM"


docker create --entrypoint /bin/bash \
       --name "${CONTAINER_NAME}" \
       rdmueller/doctoolchain:rc-1.2.0 \
       -c "doctoolchain doc $CMD $@ -PinputPath=. \
       -PmainConfigFile=doc/Config.groovy"

docker cp src/main/doc "${CONTAINER_NAME}:/project"

docker start "${CONTAINER_NAME}"
docker wait "${CONTAINER_NAME}"
docker cp "${CONTAINER_NAME}:/project/doc/build" .
docker rm "${CONTAINER_NAME}"



