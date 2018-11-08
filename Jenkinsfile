def project = 'sample-app'
def  appName = 'sample-app'
def  feSvcName = "${appName}"
def  imageTag = "vanneback/go-sample"

pipeline {
  agent {
    kubernetes {
      label 'sample-app'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: cd-jenkins
  containers:
  - name: golang
    image: golang:1.10
    command:
    - cat
    tty: true
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    command:
    - cat
    tty: true
"""
}
  }
  stages {
    stage('Test') {
      steps {
        container('golang') {
          sh """
            ln -s `pwd` /go/src/sample-app
            cd /go/src/sample-app
            go test
          """
        }
      }
    }
    stage('Build and push image with Container Builder') {
      steps {
        container('gcloud') {
          sh "echo push image ${imageTag} ."
        }
      }
    }
    stage('Deploy Production') {
      // Production branch
      when { branch 'master' }
      steps{
        container('kubectl') {
        // Change deployed image in canary to the one we just built
          sh("kubectl --namespace=default apply -f k8s/production/")
          sh("kubectl --namespace=default apply -f k8s/services/")
          SELECTOR = sh("kubectl get svc sample-app -o jsonpath='{.spec.selector.app}'")
          PORT = sh ("kubectl get svc sample-app -o jsonpath='{.spec.ports[0].nodePort}'")
          NODE = sh("kubectl get pod -l app=$SELECTOR -o jsonpath='{.items[0].status.hostIP}'")
          sh("echo http://$NODE:$PORT")
        }
      }
    }
  }
}
