#!/bin/bash

kubectl run -it busybox --image=radial/busyboxplus:curl --namespace=default --generator=run-pod/v1 -- sh
