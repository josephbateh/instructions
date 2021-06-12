#!/bin/bash -ex
source duplicity.env
env PASSPHRASE=${PASSPHRASE} duplicity list-current-files b2://${BB_KEY_ID}:${BB_APPLICATION_KEY}@${BB_BUCKET_ID}/${BB_BUCKET_PATH}