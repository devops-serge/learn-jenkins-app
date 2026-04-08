pipeline {
    agent any

    stages {
        /*
        This is a comment 1
        */
        // This is a comment 2

        // stage('Build') {
        //     agent {
        //         docker {
        //             image 'node:18-alpine'
        //             reuseNode true
        //         }
        //     }
        //     steps {
        //         sh '''
        //         ls -la
        //         node --version
        //         npm --version
        //         npm ci
        //         npm run build
        //         ls -la
        //         '''
        //     }
        // }

        // stage('tests') {
        //     parallel {
        //         stage('Test') {
        //             agent {
        //                 docker {
        //                     image 'node:18-alpine'
        //                     reuseNode true
        //                 }
        //             }
        //             steps {
        //                 sh '''
        //                 echo "Test Stage"
        //                 ls -la
        //                 test -f build/index.html
        //                 npm test
        //                 '''
        //             }
        //             post {
        //                 always {
        //                     junit 'jest-results/junit.xml'
        //                 }
        //             }
        //         }
        //         stage('E2E') {
        //             agent {
        //                 docker {
        //                     image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
        //                     reuseNode true
        //                 }
        //             }
        //             steps {
        //                 sh '''
        //                 echo "E2E Stage"
        //                 npm install serve
        //                 node_modules/.bin/serve -s build &
        //                 sleep 10
        //                 npx playwright test --reporter=html
        //                 '''
        //             }
        //             post {
        //                 always {
        //                     publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Local', reportTitles: '', useWrapperFileDirectly: true])
        //                 }
        //             }
        //         }
        //     }
        // }
        stage('Deploy staging') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            environment {
                NETLIFY_SITE_ID = 'bd61fbd8-7752-4e66-b012-199b24160882'
                NETLIFY_AUTH_TOKEN = credentials('netlify_id')
            }
            steps {
                sh '''
                echo "Deploy staging"
                npm install netlify-cli@20.1.1 node-jq
                node_modules/.bin/netlify status
                node_modules/.bin/netlify deploy --dir=build --json > deploy-output_staging.json
                '''
                script {
                    env.STAGING_URL = sh(script: "node_modules/.bin/node-jq -r '.deploy_url' ddeploy-output_staging.json", returnStdout: true)
                }
            }
        }
    //             stage('E2E staging') {
    //                 agent {
    //                     docker {
    //                         image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
    //                         reuseNode true
    //                     }
    //                 }
    //                 environment {
    //                     CI_ENVIRONMENT_URL = '${env.STAGING_URL}'
    //                 }
    //                 steps {
    //                     sh '''
    //                     echo "E2E Stage"
    //                     // npx playwright test --reporter=html
    //                     '''
    //                 }
    //                 post {
    //                     always {
    //                         publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright E2E Report', reportTitles: '', useWrapperFileDirectly: true])
    //                     }
    //                 }
    //             }
        stage('Approval') {
            steps {
                timeout(time: 60, unit: 'SECONDS') {
                    input message: 'Ready to deploy to Production?', ok: 'Yes'
                }
            }
        }
        stage('Deploy production') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            environment {
                NETLIFY_SITE_ID = '55f54b1c-e3dc-4028-9ed1-ae6c94832252'
                NETLIFY_AUTH_TOKEN = credentials('netlify_id')
            }
            steps {
                sh '''
                echo "Deploy production"
                npm install netlify-cli@20.1.1 node-jq
                node_modules/.bin/netlify status
                node_modules/.bin/netlify deploy --dir=build --prod --json > deploy_output_prod.json
                '''
                script {
                    env.PRODUCTION_URL = sh(script: "node_modules/.bin/node-jq -r '.deploy_url' deploy_output_prod.json", returnStdout: true)
                }
            }
        }
    //             stage('E2E production') {
    //                 agent {
    //                     docker {
    //                         image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
    //                         reuseNode true
    //                     }
    //                 }
    //                 environment {
    //                     CI_ENVIRONMENT_URL = '${env.PRODUCTION_URL}'
    //                 }
    //                 steps {
    //                     sh '''
    //                     echo "E2E Stage"
    //                     // npx playwright test --reporter=html
    //                     '''
    //                 }
    //                 post {
    //                     always {
    //                         publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright E2E Report', reportTitles: '', useWrapperFileDirectly: true])
    //                     }
    //                 }
    //             }
    }
}