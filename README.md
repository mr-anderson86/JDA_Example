# Jenkins Docker Agent Example

## Description:

This repository represents a Jenkins pipeline, which all runs on an agent based on a docker image, 
which is been built first on some other remote label (therefor the Docker file).  
  
Screenshots of final results can be found in the [images](images) directory :-) 

## Jenkins job's process:
![Flowchart](https://yuml.me/diagram/plain/activity/(Build%20Docker%20Image)-%3E(Run%20Container)-%3E(Run%20Pipeline%20In%20The%20Container)-%3E(Delete%20The%20Container).png)

Steps:
1. The pipeline builds an image out of the [Dockerfile](Dockerfile) (this is going on the remote label/node/agent).
2. It runs a container using the image above (this is going on the remote label/node/agent).
3. [The rest of the pipeline runs](#the-2-jenkinsfiles-are-with-same-logic-one-declarative-and-one-scripted) inside this Docker container.
4. Once the job is done, it deletes the Docker container.  


## Repository main files:
* [Dockerfile](Dockerfile)
* [zip_job.pl](zip_job.pl) (some perl script what so ever)
* Jenkinsfile - [declerative](Jenkinsfile)
* Jenkinsfile - [scripted](Jenkinsfile_Scripted)


### The Dockerfile:
* Based on centos 7 latest image
* Define environment variable VERSION=1.2.0
* Install perl, vim, zip and unzip
* Copy zip_job.pl into the image's /tmp folder
* Once docker container is up run a command which will print OS type and architecture + verify /tmp/zip_job.pl exists

### The zip_job.pl perl script:
* Create an array of a,b,c,d
* Based on this array create txt files (a.txt,b.txt….)
* Make sure all txt files created and if not - fail the script
* Create zip files with names based on array + VERSION environment variable, that each one will have one txt file inside (a_1.2.0.zip should include a.txt, b_1.2.0.zip should include b.txt  and so on)
* Make sure all zip files created and if not - fail the script 

### The 2 Jenkinsfiles are with same logic, one Declarative and one Scripted:
1. Agent is be based on the [Dockerfile](Dockerfile)
    * it runs in a privileged mode within remote label 'zip-job-docker'
2. Build stage executes the (zip_job.pl)[zip_job.pl] script.
3. Publish stage should upload all the zip files created (only in case build stage succeeded) to Artifactory using the following properties:
    * Artifactory server: "https://artifactory-telaviv"
    * Artifactory user: "some-user"
    * Artifactory password: "some-password"
    * Artifactory repository to upload to: "binary-storage/{VERSION env variable}"
    * (Just note, that this stage fails since this address doesn't exist, so feel free to comment those lines on your private repository).
    * (In addition, you need to install Artifactory plugin version >= 3.0.0 for using Artifactory in Jenkins)
4. Report stage - sends email with job status in the subject to your mail address
5. Cleanup stage - delete the workspace


### The end, enjoy :)
