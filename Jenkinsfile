#!groovy

// wrap all builds in a 2-hour time limit
timeout (time: 120, unit: 'MINUTES') {
    // get a globus-docs builder node
    node ('globus-docs') {
        stage ('Clone from GitHub') {
            sshagent(['github-ssh-key']) {
                checkout scm
            }
        }
        stage ('install build tools') {
            sh 'make build-tools'
        }
        stage ('build content') {
            sh 'make build'
        }
    }
}

