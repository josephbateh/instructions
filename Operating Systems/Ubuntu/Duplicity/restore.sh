#!/bin/bash -ex
source duplicity.env
env PASSPHRASE=${PASSPHRASE} duplicity restore --progress b2://${BB_KEY_ID}:${BB_APPLICATION_KEY}@${BB_BUCKET_ID}/${BB_BUCKET_PATH} ${LOCAL_PATH}