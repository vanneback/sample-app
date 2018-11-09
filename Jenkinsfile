def label = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
  containerTemplate(name: 'golang', image: 'golang:1.10', command: 'cat', ttyEnabled: true), 
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true), 
  containerTemplate(name: 'kubectl', image: 'gcr.io/cloud-builders/kubectl', command: 'cat', ttyEnabled: true)
]) {
  node(label) {
    def  appName = 'sample-app'
    def  feSvcName = "${appName}"
    def  imageTag = "vanneback/go-sample"
    def myRepo = checkout scm
    def gitCommit = myRepo.GIT_COMMIT
    def gitBranch = myRepo.GIT_BRANCH
    def shortGitCommit = "${gitCommit[0..10]}"
    def previousGitCommit = sh(script: "git rev-parse ${gitCommit}~", returnStdout: true)

      
    stage('Test') {
      container('golang') {
        /* sh """
          sleep 200
          ln -s `pwd` /app/
          cd /app/
          go test 
        """ */i
        sh """
          pwd
          echo "git branch = ${gitBranch}"
          echo "git commit = ${gitCommit}"
          echo "myrepo = ${myRepo}"
        sh ("echo testing complete")

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
      /* sh("sleep 300")
        sh("kubectl --namespace=default apply -f k8s/production.yaml")
        sh("kubectl --namespace=default apply -f k8s/service.yaml")
        sh("SELECTOR=`kubectl get svc sample-app -o jsonpath='{.spec.selector.app}'`")
        sh("PORT=`kubectl get svc sample-app -o jsonpath='{.spec.ports[0].nodePort}'`")
        sh("NODE=`kubectl get pod -l app=$SELECTOR -o jsonpath='{.items[0].status.hostIP}'`")
        sh("echo http://$NODE:$PORT") */
        sh("echo deployed")
      }
    }
  }
}

