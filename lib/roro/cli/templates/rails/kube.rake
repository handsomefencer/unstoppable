# require 'dotenv/tasks'

# Rake.application.options.trace = false

# Dotenv.load('.env.production.cluster')

namespace :kube do

  desc 'Rollout a new deployment'
  task :deploy do
    apply "kube/deployment.yml"
    puts `kubectl rollout restart deployment myapp-deployment`
  end

  desc 'Print useful information aout our Kubernete setup'
  task :list do
    kubectl 'get pods --all-namespaces'
    kubectl 'get services --all-namespaces'
    kubectl 'get ingresses --all-namespaces'
  end

  desc 'Apply our Kubernete configurations to our cluster'
  task :setup do
  
    kubectl "apply -f #{Rails.root}/kube/service.yml"

    # # Add our Docker Hub credentials to our cluster
    # kubectl(%Q{create secret docker-registry regcred \
    #     --docker-server=#{ENV['DOCKER_REGISTRY_SERVER']} \
    #     --docker-username=#{ENV['DOCKER_USERNAME']} \
    #     --docker-password=#{ENV['DOCKER_PASSWORD']} \
    #     --docker-email=#{ENV['DOCKER_EMAIL']} || true
    # })

    # # Install our Service Component
    # apply "kube/service.yml"

    # # Install our Rails app Deployment
    # apply "kube/deployment.yml"

    # # Installs Nginx Ingress controller
    # apply "https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml"

    # # Add a load balancer
    # apply "https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml"

    # # Install our Ingress that will link our load balancer to our service(s)
    # apply "kube/ingress.yml"

    # # Add the Digital Ocean token to the cluster
    # apply "kube/secret-digital-ocean.yml"

    # # Install cert-manager
    # kubectl 'create namespace cert-manager'
    # apply "https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.yaml"

    # # Add our certificate
    # apply "kube/certificate.yml"
     
    # # Add the certificate issuer
    # apply "kube/cluster-issuer.yml"
  end

  desc "Set the number of instances to run in the cluster"
  task :scale, [:count] => [:environment] do |t, args|
     kubectl "scale deployments/myapp-deployment --replicas #{args[:count]}"
  end

  desc "Run database migrates the database"
  task :migrate do
    apply "kube/job-migrate.yml"
  end

  desc "Open a session to a pod on the cluster"
  task :shell do
    exec "kubectl exec -it #{find_first_pod_name} bash"
  end

  desc "Tail the log files on production"
  task :logs do
    exec 'kubectl logs -f -l app=myapp --all-containers'
  end

  desc "Runs a command in production"
  task :run, [:command] => [:environment] do |t, args|
     kubectl "exec -it #{find_first_pod_name} echo $(#{args[:command]})"
  end

  desc "Run rails console in production"
  task :console do
    system "kubectl exec -it #{find_first_pod_name} bundle exec rails console"
  end

  desc "Print the environment variables"
  task :config do
    system "kubectl exec -it #{find_first_pod_name} printenv | sort"
  end

  def apply(configuration)
    if File.file?(configuration)
      puts %x{envsubst < #{configuration} | kubectl apply -f -}
    else
      kubectl "apply -f #{configuration}"
    end
  end

  def kubectl(command)
    print %x{ kubectl #{command} }
  end

  def find_first_pod_name
    `kubectl get pods|grep myapp-deployment|awk '{print $1}'|head -n 1`.to_s.strip
  end
end