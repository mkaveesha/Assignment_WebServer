#!/bin/bash

PRIV_KEY=Desktop/Web-Test5.pem
PUB_IP="18.220.98.155"

ssh -i $PRIV_KEY ec2-user@$PUB_IP

