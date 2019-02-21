pipeline {
    agent {
        dockerfile {
            label 'zip-job-docker'
            args '--privileged'
        }
    }
    environment {
        VER = sh(returnStdout: true, script: 'env | grep VERSION | cut -d= -f2').trim()
    }
    stages {
        stage('Build') {
            steps {
                sh '/tmp/zip_job.pl'
            }
        }
        stage('Publish') {
            steps {
                echo "Publishing zip files from job ${JOB_NAME} on version ${VER}"
                /* the part below will not work, since host doesn't exist.
                   So feel free to comment from here up to the end of rtPublishBuildInfo
                   (or delete this code) /*
                rtServer (
                    id: "Artifactory-1",
                    url: "https://artifactory-telaviv",
                    username: "some-user",
                    password: "some-password"
                )
		rtUpload (
                    serverId: "Artifactory-1",
                    spec:
                        """{
                         "files": [
                          {
                           "pattern": "*${VER}*.zip",
                           "target": "binary-storage/${VER}/"
                         }
                      ]
                     }"""
                )
                rtPublishBuildInfo (
                    serverId: "Artifactory-1"
                )
                echo "Publish done."
            }
        }
        stage('Report') {
            steps {
                emailext (
                    mimeType: 'text/html',
                    subject: "[${JOB_NAME}] #${BUILD_NUMBER} - Success",
                    attachLog: true,
                    body: """<html><body>
                        [${JOB_NAME}] #${BUILD_NUMBER} - Success </br>
                        BUILD_URL: ${BUILD_URL}
                        </body></html>""",
                    to: "some.mail@something.com",
                    replyTo: "some.other.mail@something.com"
                )
            }
        }
        stage('Cleanup') {
            steps {
                deleteDir()
            }
        }
    }
    post {
	    failure {
	        emailext (
                mimeType: 'text/html',
                subject: "[${JOB_NAME}] #${BUILD_NUMBER} - Failed",
                attachLog: true,
                body: """<html><body>
                    [${JOB_NAME}] #${BUILD_NUMBER} - Failed </br>
                    BUILD_URL: ${BUILD_URL}
                    </body></html>""",
                to: "some.mail@something.com",
	        replyTo: "some.other.mail@something.com"
            )
        }
    }
}
