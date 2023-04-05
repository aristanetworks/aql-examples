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
              - name: artools
                image: docker.corp.arista.io/artools-eos-trunk-x86_64_el7:latest
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
                        container('artools') {
                            dir("${WORKSPACE}") {
                                sh "PATH=${env.PATH}  a4 scp arastra@distcvp:/dist/storage/aql/latest/aql-v* /tmp/aql"
                                sh "AQLBIN=/tmp/aql ./aqlcheck.sh"
                            }
                        }
                    }
                }
            }
        }
    }
}
