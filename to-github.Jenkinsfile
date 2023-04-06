// Used to forward gerrit commits to public github. yaml config found in
// ardc-config/ops/ansible/inventories/infra/files/jenkins_controller/cvp/jobs/aql-jobs.yml
pipeline {
    agent { label 'jenkins-agent-cloud' }
    stages {
        stage('Mirror to Github') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    extensions: [
                        [$class: 'CleanBeforeCheckout'],
                    ],
                    userRemoteConfigs: [[
                        url: 'https://gerrit.corp.arista.io/aql-examples',
                    ]],
                ])
                sshagent (credentials: ['jenkins-rsa-key']) {
                    // Nodes by default don't have a .ssh folder
                    sh 'mkdir -p ~/.ssh'
                    sh 'if ! grep -q github.com ~/.ssh/known_hosts; then ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts; fi'
                    sh 'git push git@github.com:aristanetworks/aql-examples.git HEAD:master'
                }
            }
        }
    }
}
