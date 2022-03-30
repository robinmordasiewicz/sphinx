pipeline {
  options {
    disableConcurrentBuilds(abortPrevious: true)
    skipDefaultCheckout(true)
  }
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: ubuntu
            image: robinhoodis/ubuntu:latest
            command:
            - cat
            tty: true
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug
            imagePullPolicy: Always
            command:
            - /busybox/cat
            tty: true
            volumeMounts:
              - name: kaniko-secret
                mountPath: /kaniko/.docker
          restartPolicy: Never
          volumes:
            - name: kaniko-secret
              secret:
                secretName: regcred
                items:
                  - key: .dockerconfigjson
                    path: config.json
        '''
    }
  }
  stages {
    stage("cleanWs") {
      steps {
        cleanWs()
        // checkout scm
      }
    }
    stage('prepare-workspace') {
      steps {
        git branch: 'main', url: 'https://github.com/robinmordasiewicz/jenkins.git'
        sh 'mkdir -p argocd'
        dir ( 'argocd' ) {
          git branch: 'main', url: 'https://github.com/robinmordasiewicz/jcasc.git'
        }
      }
    }
    stage('increment-version') {
      steps {
        dir ( 'argocd' ) {
          script {
            sh "sh increment-version.sh"
          }
        }
      }
    }
    stage('Build & Push Image') {
      steps {
        container(name: 'kaniko', shell: '/busybox/sh') {
          script {
            sh '''
            /kaniko/executor --dockerfile `pwd`/Dockerfile \
                             --context `pwd` \
                             --destination=robinhoodis/jenkins:`cat argocd/VERSION`
            '''
            sh '''
            /kaniko/executor --dockerfile `pwd`/Dockerfile \
                             --context `pwd` \
                             --destination=robinhoodis/jenkins:latest
            '''
          }
        }
      }
    }
    stage('git-push') {
      steps {
        dir ( 'argocd' ) {
          sh 'git config user.email "robin@mordasiewicz.com"'
          sh 'git config user.name "Robin Mordasiewicz"'
          sh 'git add .'
          sh 'git commit -m "`cat VERSION`"'
          withCredentials([gitUsernamePassword(credentialsId: 'jenkins-pat', gitToolName: 'git')]) {
            sh '/usr/bin/git push origin main'
          }
        }
      }
    }
    stage('Deploy') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          container('ubuntu') {
            sh 'helm upgrade --install  argocd/values.yaml --namespace r-mordasiewicz'
          }
        }
      }
    }
  }
}

