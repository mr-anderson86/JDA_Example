# Jenkins Docker Agent Example

## Description:

This repository represents a Jenkins pipeline, which all runs on an agent based on a docker image, 
which is been built first on some remote other label (therefor the Docker file).


Meaning:
1. The pipeline builds an image out of the Dockerfile (this is going on the remote label/node/agent).
2. It runs a container using the image above (this is going on the remote label/node/agent).
3. The rest of the pipeline runs inside this Docker container.
4. Once the job is done, it deletes the Docker container.

The repository holds 4 files:
1. Dockerfile
2. zip_job.pl (some perl script what so ever)
3. Jenkinsfile - declerative
4. Jenkinsfile - scripted


### 1. The Dockerfile does as follows:
* Based on centos 7 latest image
* Define environment variable VERSION=1.2.0
* Install perl
* Install vim
* Install zip
* Install unzip
* Copy zip_job.pl into the image's /tmp folder
* Once docker container is up run a command which will print OS type and architecture + verify /tmp/zip_job.pl exists

### 2. The zip_job.pl perl script does as follows:
* Create an array of a,b,c,d
* Based on this array create txt files (a.txt,b.txt….)
* Make sure all txt files created and if not - fail the script
* Create zip files with names based on array + VERSION environment variable, that each one will have one txt file inside (a_1.2.0.zip should include a.txt, b_1.2.0.zip should include b.txt  and so on)
* Make sure all zip files created and if not - fail the script 

### 3. The 2 Jenkinsfiles are with same logic, one Declarative and one Scripted:
* Agent is be based on the Dockerfile from step 1
  - it runs in a privileged mode within remote label 'zip-job-docker'
* Build stage executes the zip_job.pl from step 2
* Publish stage should upload all the zip files created (only in case build stage succeeded) to Artifactory using the following properties:
  - Artifactory server: "https://artifactory-telaviv"
  - Artifactory user: "some-user"
  - Artifactory password: "some-password"
  - Artifactory repository to upload to: "binary-storage/{VERSION env variable}"
  - (Just note, that this stage fails since this address doesn't exist, so feel free to comment those lines on your private repository).
* Report stage - sends email with job status in the subject to your mail address
* Cleanup stage - delete the workspace


### The end, enjoy :)

