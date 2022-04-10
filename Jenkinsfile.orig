pipeline {
  options {
    disableConcurrentBuilds()
  }
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug
            imagePullPolicy: IfNotPresent
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
    stage('build sphinx container') {
      steps {
        container(name: 'kaniko', shell: '/busybox/sh') {
          script {
            sh '''
            /kaniko/executor --dockerfile=Dockerfile \
                             --context=git://github.com/robinmordasiewicz/sphinx.git \
                             --destination=robinhoodis/sphinx:`cat VERSION` \
                             --destination=robinhoodis/sphinx:latest \
                             --cache=true
            '''
          }
        }
      }
    }
    stage('pull sphinx version into make-html repo') {
      steps {
        sh 'mkdir make-html'
        dir ( 'make-html' ) {
          git branch: 'main', url: 'https://github.com/robinmordasiewicz/make-html.git'
          sh 'sh increment-version.sh'
        }
      }
    }
    stage('commit changes to the make-html repo') {
      steps {
        dir ( 'make-html' ) {
          sh 'git config user.email "robin@mordasiewicz.com"'
          sh 'git config user.name "Robin Mordasiewicz"'
          sh 'git add .'
          sh 'git diff --quiet && git diff --staged --quiet || git commit -am "Sphinx Container: `cat VERSION`"'
          withCredentials([gitUsernamePassword(credentialsId: 'github-pat', gitToolName: 'git')]) {
            sh 'git diff --quiet && git diff --staged --quiet || git push origin main'
          }
        }
      }
    }
    stage('clean up') {
      steps {
        sh 'rm -rf make-html'
      }
    }
  }
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
