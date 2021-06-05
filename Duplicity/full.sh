#!/bin/bash -ex
env PASSPHRASE=${PASSPHRASE} duplicity full --progress ${LOCAL_PATH} b2://${BB_KEY_ID}:${BB_APPLICATION_KEY}@${BB_BUCKET_ID}/${BB_BUCKET_PATH}