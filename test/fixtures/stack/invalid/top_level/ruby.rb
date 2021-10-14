preface: A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant
  syntax that is natural to read and easy to write.

env:
  ruby: 2.7

questions:
  -
    question: Please supply your docker username
    help: https://hub.docker.com/signup
    action: "@env[:docker_username] = answer"
  -
    question: Please supply your docker id
    help: https://hub.docker.com/signup
    action: "@env[:docker_id]"
  -
    question: Please supply your docker password
    help: https://hub.docker.com/signup
    action: "@env[:docker_password]"

actions:
  - "@env[:ruby_version] = RUBY_VERSION"