pipeline {

    environment {
      TEST = 'JA'
      DB_WNGINE = 'myslql'
    }
    agent { docker { image 'python:3.5.1' } }
    stages {
        stage('build') {
            steps {
                echo "Building"
                sh 'python --version'
            }
        }
        stage('test') {
          steps {
           echo 'Testing'
          }
        }
        stage('deploy') {
          steps {
            echo 'Deploying'
          }
        }
        stage('Sanity check') {
          steps {
            input "Does the staging environment look ok?"
          }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
  }
}
