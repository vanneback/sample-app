def  appName = 'sample-app'
def  feSvcName = "${appName}"
def  imageTag = "vanneback/go-sample"

/*pipeline {
  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: default
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
}*/
pipeline {
  pod {
    containers {
      container {
        name 'goland'
        image 'golang:1.10'
      }
      container {
        name 'kubectl'
        image 'gcr.io/cloud-builders/kubectl'
      }
      container {
        name 'docker'
        image 'docker'
      }
    }
  }
  agent none
  stages {
    stage('Test') {
      steps {
        container('golang') {
          sh """
            ln -s `pwd` /go/src/sample-app
            cd /go/src/sample-app
            echo "go test"
          """
        }
      }
    }

    stage('Build and push image with Container Builder') {
      steps {
        container('docker') {
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
          sh("SELECTOR=`kubectl get svc sample-app -o jsonpath='{.spec.selector.app}'`")
          sh("PORT=`kubectl get svc sample-app -o jsonpath='{.spec.ports[0].nodePort}'`")
          sh("NODE=`kubectl get pod -l app=$SELECTOR -o jsonpath='{.items[0].status.hostIP}'`")
          sh("echo http://$NODE:$PORT")
        }
      }
    }
  }
}
