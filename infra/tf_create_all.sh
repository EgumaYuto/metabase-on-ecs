#!/usr/bin/env bash

TF_CMD=$1
ENV=$2
TF_ARGS=${@:3}

./tf.sh $TF_CMD $ENV platform/network/vpc $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/subnet/public $TF_ARGS
./tf.sh $TF_CMD $ENV platform/network/subnet/private $TF_ARGS
./tf.sh $TF_CMD $ENV platform/route53/public $TF_ARGS
./tf.sh $TF_CMD $ENV platform/route53/private $TF_ARGS
./tf.sh $TF_CMD $ENV platform/ecs-cluster $TF_ARGS
./tf.sh $TF_CMD $ENV platform/parameters/rds $TF_ARGS
./tf.sh $TF_CMD $ENV platform/data/rds $TF_ARGS

./tf.sh $TF_CMD $ENV service/metabase/elb $TF_ARGS
./tf.sh $TF_CMD $ENV service/metabase/ecs $TF_ARGS
./tf.sh $TF_CMD $ENV service/scheduler $TF_ARGS

./tf.sh $TF_CMD $ENV devops/bastion $TF_ARGS
# ./tf.sh $TF_CMD $ENV devops/actions $TF_ARGS