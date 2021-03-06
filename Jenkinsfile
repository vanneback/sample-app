def label = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
  containerTemplate(name: 'golang', image: 'golang:1.10', command: 'cat', ttyEnabled: true), 
  containerTemplate(name: 'docker', image: 'docker:18.06.1-ce', command: 'cat', ttyEnabled: true,
  envVars: [ envVar(key: 'BUILD_NUMBER', value: '$env.BUILD_NUMBER')]), 
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.8', command: 'cat', ttyEnabled: true)
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock', type: 'Socket')
]) {

  node(label) {
    def  appName = 'sample-app'
    def  imageTag = "vanneback/go-sample:${env.BUILD_NUMBER}"
    def myRepo = checkout scm

    stage('Test') {
      container('golang') {
        sh '''
          go test
        '''        
      }
    }

    stage('Build and push image with Container Builder') {
      container('docker') {
        /* sh '''
          docker build -t vanneback/go-sample:latest .
        ''' */
        
        withCredentials([[$class: 'UsernamePasswordMultiBinding',
          credentialsId: 'dockerhub',
          usernameVariable: 'DOCKER_HUB_USER',
          passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh '''
            #!/bin/bash
            set -e
            docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
            docker build -t vanneback/go-sample:latest .
            docker push vanneback/go-sample:latest
            '''
        }  
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
          kubectl delete pods -l app=$SELECTOR 
          kubectl rollout status -f k8s/production.yaml
          PORT=$(kubectl get svc sample-app -o jsonpath='{.spec.ports[0].nodePort}')
          NODE=$(kubectl get pod -l app=$SELECTOR -o jsonpath='{.items[0].status.hostIP}')
          echo http://$NODE:$PORT
        '''
        sh("echo deployed")
      }
    }
  }
}

