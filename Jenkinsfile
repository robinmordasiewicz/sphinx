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
    stage("cleanWS") {
      steps {
        cleanWs()
        // checkout scm
      }
    }
    stage('prepareWS') {
      steps {
        sh 'mkdir -p sphinx-build-container'
        dir ( 'sphinx-build-container' ) {
          git branch: 'main', url: 'https://github.com/robinmordasiewicz/sphinx-build-container.git'
        }
      }
    }
//    stage('bump container version') {
//      steps {
//        dir ( 'sphinx-build-container' ) {
//          container('ubuntu') {
//            sh "sh increment-version.sh"
//          }
//        }
//      }
//    }
    stage('build container') {
      steps {
        dir ( 'sphinx-build-container' ) {
          container(name: 'kaniko', shell: '/busybox/sh') {
            script {
              sh '''
              /kaniko/executor --dockerfile `pwd`/Dockerfile \
                               --context `pwd` \
                               --destination=robinhoodis/sphinx-build:`cat VERSION`
              '''
              sh '''
              /kaniko/executor --dockerfile `pwd`/Dockerfile \
                               --context `pwd` \
                               --destination=robinhoodis/sphinx-build:latest
              '''
            }
          }
        }
      }
    }
//    stage('commit container version') {
//      steps {
//        dir ( 'sphinx-build-container' ) {
//          sh 'git config user.email "robin@mordasiewicz.com"'
//          sh 'git config user.name "Robin Mordasiewicz"'
//          sh 'git add .'
//          sh 'git tag `cat VERSION`'
//          sh 'git commit -m "`cat VERSION`"'
//          withCredentials([gitUsernamePassword(credentialsId: 'github-pat', gitToolName: 'git')]) {
//            sh '/usr/bin/git push origin main'
//            sh '/usr/bin/git push origin `cat VERSION`'
//          }
//        }
//      }
//    }
//  post {
//    always {
//      cleanWs(cleanWhenNotBuilt: false,
//            deleteDirs: true,
//            disableDeferredWipeout: true,
//            notFailBuild: true,
//            patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
//                     [pattern: '.propsfile', type: 'EXCLUDE']])
//    }
//  }
}
