// -*- mode: groovy; fill-column: 120; groovy-indent-offset: 4; -*-

def isReview() {
    return env.JOB_NAME == "aql-examples-review-pipeline"
}

pipeline {
    environment {
        GERRIT_CREDENTIALS_ID="srv-jenkins-io"
    }
    agent {
        kubernetes {
            inheritFrom 'page-size-jenkins-agent'
            yaml '''
            spec:
              containers:
              - name: debian
                image: debian:latest
                command: ["cat"]
                tty: true
'''
        }
    }
    stages {

        stage('checks') {
            environment {
                // Explicitly set HOME, cause some containers don't have one.
                // This specific value is used so  that we have the same HOME in all stages,
                // regardless of the container.
                // This is needed so that git config --global for the safe dirs can be applied
                // once and stay set forever.
                HOME= "${WORKSPACE}"
            }
            stages {
                stage ('aql syntaxcheck') {
                    steps {
                        container('debian') {
                            dir("${WORKSPACE}") {
                                sh "apt-get update && apt-get -y install openssh-client python3 python3-pip"
                                sshagent (credentials: ['cvp-jenkins-robot-distcvp']) {
                                    sh "PATH=${env.PATH} scp -o UserKnownHostsFile=/dev/null \
                                    -o StrictHostKeyChecking=no \
                                    cvp-jenkins-robot-distcvp@distcvp:/dist/storage/aql/latest/aql-v* /tmp/aql"
                                    sh "AQLBIN=/tmp/aql ./aqlcheck.sh"
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('Build and Publish Documentation') {
            steps {
                container('debian') {
                    dir("${WORKSPACE}") {
                        sh "pip install --break-system-packages -r requirements.txt"
                        sh "make all"

                        publishHTML (target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: '_build',
                            reportFiles: 'index.html',
                            reportName: 'Documentation'
                        ])
                    }
                }
            }
        }
    }
}
