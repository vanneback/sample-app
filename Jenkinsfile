def label = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
  containerTemplate(name: 'golang', image: 'golang:1.10', command: 'cat', ttyEnabled: true), 
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true), 
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.8', command: 'cat', ttyEnabled: true)
]) {
  node(label) {
    def  appName = 'sample-app'
    def  feSvcName = "${appName}"
    def  imageTag = "vanneback/go-sample"
    def myRepo = checkout scm
    def gitCommit = myRepo.GIT_COMMIT
    def gitURL = myRepo.GIT_URL
    def gitBranch = myRepo.GIT_BRANCH
    def shortGitCommit = "${gitCommit[0..10]}"
    def previousGitCommit = sh(script: "git rev-parse ${gitCommit}~", returnStdout: true)

    stage('Test') {
      container('golang') {
        /* sh """
            git clone ${gitURL}
            cd sample-app
            go test
          echo test
        """ */
        sh("go test")
      }
    }

    stage('Build and push image with Container Builder') {
      container('docker') {
        sh "echo push image ${imageTag} ."
      }
    }
    stage('Deploy Production') {
      // Production branch
      container('kubectl') {
      // Change deployed image in canary to the one we just built
        sh '''
          #!/bin/bash
          kubectl --namespace=default apply -f k8s/production.yaml
          kubectl --namespace=default apply -f k8s/service.yaml
          SELECTOR=$(kubectl get svc sample-app -o jsonpath='{.spec.selector.app}')
          PORT=$(kubectl get svc sample-app -o jsonpath='{.spec.ports[0].nodePort}')
          NODE=$(kubectl get pod -l app=$SELECTOR -o jsonpath='{.items[0].status.hostIP}')
          echo http://$NODE:$PORT
        '''
        /*
        sh("SELECTOR=`kubectl get svc sample-app -o jsonpath='{.spec.selector.app}'`")
        sh("PORT=`kubectl get svc sample-app -o jsonpath='{.spec.ports[0].nodePort}'`")
        sh("NODE=`kubectl get pod -l app=$SELECTOR -o jsonpath='{.items[0].status.hostIP}'`")
        sh("echo http://$NODE:$PORT") */
        sh("echo deployed")
      }
    }
  }
}

